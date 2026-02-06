import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:gtr_app/Environment.dart';
import 'package:gtr_app/utilities/Debug.dart';
import 'package:gtr_app/routes/Routes.dart';
import 'package:gtr_app/themes/Theme_Data.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data.get_theme(),
      home: Sign_In_Page(),
      routes: Routes.routes, //
      debugShowCheckedModeBanner: false,
    );
  }
}

class Sign_In_Page extends StatefulWidget {
  const Sign_In_Page({super.key});

  @override
  State<Sign_In_Page> createState() => _Sign_In_PageState();
}

class _Sign_In_PageState extends State<Sign_In_Page> {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: HOST_API, //
      connectTimeout: Duration(seconds: 10), //
      sendTimeout: Duration(seconds: 10), //
      receiveTimeout: Duration(seconds: 10), //
    ),
  );

  bool is_password_visible = false;

  TextEditingController controller_username = TextEditingController();
  TextEditingController controller_password = TextEditingController();

  FlutterSecureStorage secure_storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    debug('Sign In Page Loaded');
  }

  void on_signin() async {
    //
    await dio
        .post(
          '/credential/signin', //
          data: FormData.fromMap({
            'username': controller_username.text, //
            'password': controller_password.text, //
          }),
        )
        .then((r) async {
          show_snackbar(
            context: context, //
            message: 'Sign In Successful',
            color: Colors.green,
          );
          debug(r.data['access_token']);
          await secure_storage.write(
            key: 'access_token', //
            value: r.data['access_token'],
          );
          Navigator.pop(context); //
        })
        .catchError((e) {
          show_snackbar(
            context: context, //
            message: 'Sign In Failed',
            color: Colors.red,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign In Page")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SizedBox(
              width: 600,
              child: Column(
                children: [
                  TextField(
                    controller: controller_username, //
                    autofocus: true,
                    decoration: InputDecoration(labelText: 'Username'),
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => on_signin(),
                  ),

                  SizedBox(height: 8),

                  TextField(
                    controller: controller_password,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          is_password_visible = !is_password_visible;
                          setState(() {});
                        },
                        icon: Icon(!is_password_visible ? Icons.visibility : Icons.visibility_off),
                      ),
                    ),
                    obscureText: !is_password_visible,
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => on_signin(),
                  ),

                  SizedBox(height: 8),

                  OutlinedButton(
                    onPressed:
                        controller_username.text.isEmpty || //
                            controller_password.text.isEmpty
                        ? null
                        : () => on_signin(),
                    child: Text('Sign In'),
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
