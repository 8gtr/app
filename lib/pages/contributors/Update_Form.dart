import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:image_picker/image_picker.dart';

import 'package:gtr_app/routes/Routes.dart';
import 'package:gtr_app/Environment.dart';
import 'package:gtr_app/utilities/Debug.dart';
import 'package:gtr_app/themes/Theme_Data.dart';
import 'package:gtr_app/routes/Navigator_Left.dart';

void main() {
  usePathUrlStrategy();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: HOST_API,
      theme: Theme_Data.get_theme(),
      routes: Routes.routes,
      home: Update_Form(
        input_json: {
          'id': '12345', //
          'name': 'Sample Name', //
          'position': 'Update Sample', //
          'description': 'This is a sample description. \nIt can span multiple lines.', //
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Update_Form extends StatefulWidget {
  const Update_Form({super.key, required this.input_json});

  final Map<String, dynamic> input_json;

  @override
  State<Update_Form> createState() => _Update_FormState();
}

class _Update_FormState extends State<Update_Form> {
  //
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: HOST_API, //
      connectTimeout: Duration(seconds: 10), //
      sendTimeout: Duration(seconds: 10), //
      receiveTimeout: Duration(seconds: 10), //
    ),
  );

  TextEditingController c_name = TextEditingController();
  TextEditingController c_position = TextEditingController();
  TextEditingController c_description = TextEditingController();

  @override
  void initState() {
    super.initState();

    debug('Input JSON: ${widget.input_json}');

    c_name.text = widget.input_json['name'] ?? '';
    c_position.text = widget.input_json['position'] ?? '';
    c_description.text = widget.input_json['description'] ?? '';
    setState(() {});
  }

  void on_cancel() {
    Navigator.of(context).pop();
  }

  void on_update() {
    Navigator.of(context).pop({
      'id': widget.input_json['id'], //
      'name': c_name.text, //
      'position': c_position.text, //
      'description': c_description.text, //
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Form')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: SizedBox(
              width: 600,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // upload image button
                      OutlinedButton.icon(
                        onPressed: () async {
                          // Add image_picker package to pubspec.yaml
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                          if (image == null) {
                            return;
                          }

                          await dio
                              .post(
                                '/contributor/upload', //
                                data: FormData.fromMap({
                                  'id': widget.input_json['id'], //
                                  'image': MultipartFile.fromBytes(
                                    await image.readAsBytes(), //
                                    filename: image.name,
                                  ),
                                }),
                              )
                              .then((r) {
                                show_snackbar(context: context, message: 'Update Success', color: Colors.green);
                              })
                              .catchError((e) {
                                show_snackbar(context: context, message: 'Update Fail', color: Colors.red);
                              });
                        },
                        icon: Icon(Icons.upload),
                        label: Text('Upload'),
                      ),

                      OutlinedButton.icon(
                        onPressed: () async {
                          //
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(source: ImageSource.camera);
                          if (image == null) {
                            return;
                          }

                          // await dio
                          //     .post('/contributor/upload', data: FormData.fromMap({'id': widget.input_json['id'], 'image': MultipartFile.fromBytes(await image.readAsBytes(), filename: image.name)}))
                          //     .then((r) {
                          //       show_snackbar(context: context, message: 'Upload Success', color: Colors.green);
                          //     })
                          //     .catchError((e) {
                          //       show_snackbar(context: context, message: 'Upload Fail', color: Colors.red);
                          //     });
                        },
                        label: Text("Camera"),
                        icon: Icon(Icons.camera_alt),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),
                  TextField(
                    controller: c_name,
                    autofocus: true,
                    decoration: InputDecoration(labelText: 'Name'), //
                    keyboardType: TextInputType.text,
                    // onSubmitted: (_) => on_update(),
                  ),
                  //
                  SizedBox(height: 8),
                  TextField(
                    controller: c_position,
                    decoration: InputDecoration(labelText: 'Position'), //
                    keyboardType: TextInputType.text,
                    // onSubmitted: (_) => on_update(),
                  ),

                  SizedBox(height: 8),

                  //multi line text field
                  TextField(
                    controller: c_description,
                    decoration: InputDecoration(labelText: 'Description', alignLabelWithHint: true),
                    keyboardType: TextInputType.multiline,
                    minLines: 5,
                    maxLines: null,
                  ),

                  SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () => on_cancel(),
                        child: Text('Cancel'), //
                      ),
                      OutlinedButton(
                        onPressed: () => on_update(),
                        child: Text('Update'), //
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
      ),
    );
}
