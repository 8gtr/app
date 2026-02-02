import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

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
          'title': 'Update Sample', //
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
  TextEditingController c_name = TextEditingController();
  TextEditingController c_title = TextEditingController();

  @override
  void initState() {
    super.initState();

    debug('Input JSON: ${widget.input_json}');

    c_name.text = widget.input_json['name'];
    c_title.text = widget.input_json['title'];
    setState(() {});
  }

  void on_cancel() {
    Navigator.of(context).pop();
  }

  void on_update() {
    Navigator.of(context).pop({
      'id': widget.input_json['id'], //
      'name': c_name.text, //
      'title': c_title.text, //
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
                  // upload image button
                  OutlinedButton.icon(
                    onPressed: () async {
                      // Add image_picker package to pubspec.yaml
                      // import 'package:image_picker/image_picker.dart';
                      // final ImagePicker picker = ImagePicker();
                      // final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                      // if (image != null) {
                      //   setState(() {
                      //     // Handle the selected image
                      //   });
                      // }
                    },
                    icon: Icon(Icons.upload),
                    label: Text('Upload Image'),
                  ),

                  SizedBox(height: 8),
                  TextField(
                    controller: c_name,
                    autofocus: true,
                    decoration: InputDecoration(labelText: 'Name'), //
                    keyboardType: TextInputType.text,
                    onSubmitted: (_) => on_update(),
                  ),
                  //
                  SizedBox(height: 8),
                  TextField(
                    controller: c_title,
                    decoration: InputDecoration(labelText: 'Title'), //
                    keyboardType: TextInputType.text,
                    onSubmitted: (_) => on_update(),
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
