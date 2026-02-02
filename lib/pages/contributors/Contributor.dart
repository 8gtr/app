import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:gtr_app/Environment.dart';
import 'package:gtr_app/pages/contributors/Update_Form.dart';
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

  List<Map<String, dynamic>> samples = [];

  @override
  void initState() {
    super.initState();
    // debug('Contributor Page Loaded');
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
          samples = List<Map<String, dynamic>>.from(r.data);
          if (!mounted) return;
          setState(() {});
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contributor Page")),
      body: Center(
        child: SizedBox(
          width: 600,
          child: ReorderableListView(
            buildDefaultDragHandles: false,
            footer: SizedBox(height: 80),
            onReorder: (int old_order, int new_order) async {
              if (new_order > old_order) new_order -= 1;

              debug(samples[old_order]['order']);
              debug(samples[new_order]['order']);
              debug("Reorder: $old_order -> $new_order");

              await dio
                  .post(
                    "/contributor/reorder", //
                    data: FormData.fromMap({
                      "old_order": samples[old_order]['order'], //
                      "new_order": samples[new_order]['order'], //
                    }),
                  )
                  .then((r) {
                    init();
                    setState(() {});
                  });
            },
            children: [
              for (int i = 0; i < samples.length; i++)
                ListTile(
                  key: ValueKey(samples[i]['order']),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ReorderableDragStartListener(index: i, child: Icon(Icons.drag_indicator)),
                      SizedBox(width: 8),
                      Image.asset('assets/logo.png'),
                    ],
                  ),
                  title: Text(samples[i]['name'] ?? ''),
                  subtitle: Text(samples[i]['title'] ?? ''),
                  trailing: IconButton(
                    onPressed: () {
                      debug(samples[i]);
                      Navigator.of(context)
                          .push(
                            MaterialPageRoute(
                              builder: (context) => Update_Form(
                                input_json: {
                                  'id': samples[i]['_id']['\$oid'] ?? '', //
                                  'name': samples[i]['name'] ?? '', //
                                  'title': samples[i]['title'] ?? '',
                                },
                              ),
                            ),
                          )
                          .then((output_json) async {
                            debug("Output JSON: $output_json");
                            // debug("Updated Name: $name, Title: $title");

                            if (output_json != null) {
                              await dio
                                  .post(
                                    "/contributor/update", //
                                    data: FormData.fromMap({
                                      "id": output_json['id'], //
                                      "name": output_json['name'], //
                                      "title": output_json['title'], //
                                    }),
                                  )
                                  .then((r) {
                                    init();
                                  });
                            }
                          });
                    },
                    icon: Icon(Icons.edit),
                  ),
                  onTap: () {},
                ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 600,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                heroTag: 'search',
                onPressed: () {
                  // TODO: Implement search functionality
                },
                tooltip: 'Search contributors',
                child: const Icon(Icons.search),
              ),

              FloatingActionButton(
                heroTag: 'add',
                onPressed: () async {
                  try {
                    await dio.post("/contributor/create", data: FormData.fromMap({}));
                    if (mounted) init();
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create contributor: $e')));
                    }
                  }
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
