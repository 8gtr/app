import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:gtr_app/Environment.dart';
import 'package:gtr_app/utilities/Debug.dart';
import 'package:gtr_app/routes/Routes.dart';
import 'package:gtr_app/themes/Theme_Data.dart';

void main() {
  usePathUrlStrategy();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data.get_theme(),
      home: Reset_Page(),
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class Reset_Page extends StatefulWidget {
  const Reset_Page({super.key});

  @override
  State<Reset_Page> createState() => _Reset_PageState();
}

class _Reset_PageState extends State<Reset_Page> {
  @override
  void initState() {
    super.initState();
    debug('Reset Page Loaded');
  }

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: HOST_API, //
      connectTimeout: Duration(seconds: 10), //
      sendTimeout: Duration(seconds: 10), //
      receiveTimeout: Duration(seconds: 10), //
    ),
  );

  FlutterSecureStorage secure_storage = FlutterSecureStorage();

  bool is_new_password_visible = false;
  bool is_confirm_new_password_visible = false;

  TextEditingController controller_telegram_id = TextEditingController();
  TextEditingController controller_signup_otp = TextEditingController();
  TextEditingController controller_new_username = TextEditingController();
  TextEditingController controller_new_password = TextEditingController();
  TextEditingController controller_confirm_new_password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reset Page")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SizedBox(
              width: 600,
              child: Column(
                children: [
                  TextField(
                    controller: controller_telegram_id,
                    decoration: InputDecoration(
                      labelText: 'Telegram ID',
                      suffixIcon: TextButton(
                        onPressed: () async {
                          await launchUrl(Uri.parse('https://t.me/gtr_otp_bot'));
                        },
                        child: Text("Open Bot"),
                      ),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),

                  SizedBox(height: 8),

                  TextField(
                    controller: controller_signup_otp,
                    decoration: InputDecoration(
                      labelText: 'Reset OTP', //
                      suffixIcon: TextButton(
                        onPressed: () async {
                          await dio
                              .post(
                                '/credential/reset_otp', //
                                data: FormData.fromMap({
                                  'telegram_id': controller_telegram_id.text, //
                                }),
                              )
                              .then((r) {
                                show_snackbar(context: context, message: 'Reset OTP sent', color: Colors.green);
                              })
                              .catchError((e) {
                                show_snackbar(context: context, message: 'Error', color: Colors.red);
                              });
                        },
                        child: Text("Get OTP"),
                      ),
                    ),
                    enabled: controller_telegram_id.text.isNotEmpty,
                    onChanged: (_) => setState(() {}),
                  ),

                  SizedBox(height: 8),

                  TextField(
                    controller: controller_new_username,
                    decoration: InputDecoration(labelText: 'New Username'),
                    enabled: controller_signup_otp.text.isNotEmpty,
                    onChanged: (_) => setState(() {}),
                  ),

                  SizedBox(height: 8),

                  TextField(
                    controller: controller_new_password,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          is_new_password_visible = !is_new_password_visible;
                          setState(() {});
                        },
                        icon: Icon(!is_new_password_visible ? Icons.visibility : Icons.visibility_off),
                      ),
                    ),
                    obscureText: !is_new_password_visible,
                    enabled: controller_signup_otp.text.isNotEmpty,
                    onChanged: (_) => setState(() {}),
                  ),

                  SizedBox(height: 8),

                  TextField(
                    controller: controller_confirm_new_password,
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            is_confirm_new_password_visible = !is_confirm_new_password_visible;
                          });
                        },
                        icon: Icon(!is_confirm_new_password_visible ? Icons.visibility : Icons.visibility_off),
                      ),
                    ),
                    obscureText: !is_confirm_new_password_visible,
                    enabled: controller_new_password.text.isNotEmpty,
                  ),

                  SizedBox(height: 8),

                  OutlinedButton(
                    onPressed:
                        controller_telegram_id.text.isEmpty || //
                            controller_signup_otp.text.isEmpty || //
                            controller_new_username.text.isEmpty ||
                            controller_new_password.text.isEmpty ||
                            controller_confirm_new_password.text.isEmpty ||
                            controller_new_password.text != controller_confirm_new_password.text
                        ? null
                        : () async {
                            await dio
                                .post(
                                  '/credential/reset', //
                                  data: FormData.fromMap({
                                    'telegram_id': controller_telegram_id.text, //
                                    'reset_otp': controller_signup_otp.text, //
                                    'username': controller_new_username.text, //
                                    'password': controller_new_password.text, //
                                  }),
                                )
                                .then((r) {
                                  show_snackbar(context: context, message: 'Reset Completed', color: Colors.green);
                                  Navigator.of(context).pop(true); // reset successful
                                })
                                .catchError((e) {
                                  show_snackbar(context: context, message: 'Error', color: Colors.red);
                                });
                          },
                    child: Text('Reset'),
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
