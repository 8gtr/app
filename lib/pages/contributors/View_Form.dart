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
      home: const View_Form(
        title: 'Title', //
        input: 'Input',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class View_Form extends StatefulWidget {
  const View_Form({
    super.key,
    required this.title, //
    required this.input, //
    this.keyboard_type = TextInputType.text,
  });

  final String title;
  final String input;
  final TextInputType keyboard_type;

  @override
  State<View_Form> createState() => _View_FormState();
}

class _View_FormState extends State<View_Form> {
  @override
  void initState() {
    super.initState();
    controller_input.text = widget.input;
    setState(() {});
  }

  //
  TextEditingController controller_input = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit ${widget.title}')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: SizedBox(
              width: 600,
              child: Column(
                children: [
                  TextField(
                    controller: controller_input,
                    autofocus: true,
                    decoration: InputDecoration(labelText: widget.title), //
                    keyboardType: widget.keyboard_type,
                    onSubmitted: (_) => Navigator.of(context).pop(controller_input.text),
                  ),

                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancel'), //
                      ),
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(controller_input.text),
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
