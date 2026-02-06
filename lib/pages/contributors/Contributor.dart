import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:gtr_app/Environment.dart';
import 'package:gtr_app/pages/contributors/Update_Form.dart';
import 'package:gtr_app/pages/contributors/View_Form.dart';
import 'package:gtr_app/themes/Theme_Data.dart';
import 'package:gtr_app/routes/Routes.dart';
import 'package:gtr_app/routes/Navigator_Left.dart';
import 'package:gtr_app/utilities/Debug.dart';

void main() {
  runApp(const Contributor());
}

class Contributor extends StatelessWidget {
  const Contributor({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: HOST_API, //
      theme: Theme_Data.get_theme(),
      home: const Contributor_Page(),
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class Contributor_Page extends StatefulWidget {
  const Contributor_Page({super.key});

  @override
  State<Contributor_Page> createState() => _Contributor_PageState();
}

class _Contributor_PageState extends State<Contributor_Page> {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: HOST_API, //
      connectTimeout: Duration(seconds: 10), //
      sendTimeout: Duration(seconds: 10), //
      receiveTimeout: Duration(seconds: 10), //
    ),
  );

  FlutterSecureStorage secure_storage = FlutterSecureStorage();
  String? access_token;

  List<Map<String, dynamic>> all_data = [];
  List<Map<String, dynamic>> search_data = [];

  bool is_search = false;

  TextEditingController c_search = TextEditingController();

  bool is_admin = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    access_token = await secure_storage.read(key: 'access_token');
    // debug("Access Token: $access_token");

    await dio
        .post(
          "/contributor/read", //
          data: FormData.fromMap({}),
        )
        .then((r) {
          // debug("Contributor Data: ${r.data}");
          all_data = List<Map<String, dynamic>>.from(r.data);
          search_data = List<Map<String, dynamic>>.from(r.data);
          if (!mounted) return;
          setState(() {});
        });

    if (is_search) {
      search_contributors(c_search.text);
    }
  }

  void search_contributors(String query) {
    debug("Search query: $query");
    search_data = all_data.where((contributor) => (contributor['name'] ?? '').toLowerCase().contains(query.toLowerCase()) || (contributor['position'] ?? '').toLowerCase().contains(query.toLowerCase())).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: is_search
            ? TextField(
                controller: c_search,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search ...',
                  border: InputBorder.none, //
                ),
                onChanged: (value) {
                  search_contributors(value);
                },
              )
            : Text("Contributors"), //
        actionsPadding: EdgeInsets.only(right: 16),
        actions: [
          IconButton(
            onPressed: () {
              is_search = !is_search;
              if (!is_search) {
                c_search.clear();
                search_data = List<Map<String, dynamic>>.from(all_data);
              }
              setState(() {});
            },
            icon: is_search ? Icon(Icons.close) : Icon(Icons.search),
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: 600,
          child: ReorderableListView(
            buildDefaultDragHandles: false,
            footer: SizedBox(height: 80),
            onReorder: (int old_order, int new_order) async {
              if (new_order > old_order) new_order -= 1;

              int old_order_value = search_data[old_order]['order'];
              int new_order_value = search_data[new_order]['order'];

              search_data.insert(new_order, search_data.removeAt(old_order));
              setState(() {});

              await dio
                  .post(
                    "/contributor/reorder", //
                    data: FormData.fromMap({
                      "old_order": old_order_value, //
                      "new_order": new_order_value, //
                    }),
                  )
                  .then((r) {
                    init();
                    setState(() {});
                  });
            },
            children: [
              for (int i = 0; i < search_data.length; i++)
                ListTile(
                  key: ValueKey(search_data[i]['order']),
                  contentPadding: const EdgeInsets.only(left: 8, right: 8),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      is_search || !is_admin
                          ? SizedBox.shrink() //
                          : ReorderableDragStartListener(index: i, child: Icon(Icons.drag_indicator)),
                      SizedBox(width: 8),
                      search_data[i]['image'] == null
                          ? Image.network('$MINIO_PUBLIC/logo.png', width: 50, height: 50, fit: BoxFit.cover) //
                          : Image.network('$MINIO_PUBLIC/${search_data[i]['image']}', width: 50, height: 50, fit: BoxFit.cover), //
                    ],
                  ),
                  title: Text(search_data[i]['name'] ?? ''),
                  subtitle: Text(search_data[i]['position'] ?? ''),
                  trailing: !is_admin
                      ? SizedBox.shrink() //
                      : IconButton(
                          onPressed: () {
                            debug(search_data[i]);
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: (context) => Update_Form(
                                      input_json: {
                                        'id': search_data[i]['_id']['\$oid'] ?? '', //
                                        'name': search_data[i]['name'] ?? '', //
                                        'position': search_data[i]['position'] ?? '',
                                        'description': search_data[i]['description'] ?? '', //
                                      },
                                    ),
                                  ),
                                )
                                .then((output_json) async {
                                  debug("Output JSON: $output_json");
                                  if (output_json != null) {
                                    await dio.post(
                                      "/contributor/update", //
                                      data: FormData.fromMap({
                                        "id": output_json['id'], //
                                        "name": output_json['name'], //
                                        "position": output_json['position'], //
                                        "description": output_json['description'], //
                                      }),
                                    );
                                  }
                                  init();
                                  show_snackbar(context: context, message: "Update successful", color: Colors.green);
                                })
                                .catchError((e) {
                                  show_snackbar(context: context, message: "Update failed", color: Colors.red);
                                });
                          },
                          icon: Icon(Icons.edit),
                        ),
                  // view details
                  onTap: () {
                    debug("Tapped on ${search_data[i]['name']}");
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => View_Form(
                          input_json: {
                            'image': search_data[i]['image'] ?? '', //
                            'name': search_data[i]['name'] ?? '', //
                            'position': search_data[i]['position'] ?? '', //
                            'description': search_data[i]['description'] ?? '', //
                          },
                        ),
                      ),
                    );
                  },
                  // delete
                  onLongPress: () {
                    debug("Long pressed on ${search_data[i]['name']}");
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Delete ${search_data[i]['name']}'),
                          content: Text('Are you sure?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
                            TextButton(
                              onPressed: () async {
                                await dio
                                    .post(
                                      "/contributor/delete", //
                                      data: FormData.fromMap({
                                        "id": search_data[i]['_id']['\$oid'] ?? '', //
                                      }),
                                    )
                                    .then((r) {
                                      init();
                                      show_snackbar(context: context, message: "Delete successful", color: Colors.green);
                                    })
                                    .catchError((e) {
                                      show_snackbar(context: context, message: "Delete failed", color: Colors.red);
                                    });

                                Navigator.of(context).pop(); // Dismiss dialog
                              },
                              child: Text('Delete', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: !is_admin
          ? SizedBox.shrink() //
          : SizedBox(
              width: 600,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      heroTag: 'add',
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      onPressed: () async {
                        await dio
                            .post(
                              "/contributor/create", //
                              data: FormData.fromMap({}),
                            )
                            .then((r) {
                              init();
                              // show_snackbar(context: context, message: "Add successful", color: Colors.green);
                            })
                            .catchError((e) {
                              // show_snackbar(context: context, message: "Add failed", color: Colors.red);
                            });
                      },
                      tooltip: 'Add new contributor',
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

void show_snackbar({
  required BuildContext context, //
  required String message, //
  required Color color, //
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white),
            SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 8, left: 8, right: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
    );
}
