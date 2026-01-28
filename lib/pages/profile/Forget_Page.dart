import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:hive_flutter/hive_flutter.dart';

import 'package:gtr_app/Environment.dart';
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
      theme: Theme_Data.get_theme(), //
      home: const Forget_Page(), //
      debugShowCheckedModeBanner: false, //
    );
  }
}

class Forget_Page extends StatefulWidget {
  const Forget_Page({super.key});

  @override
  State<Forget_Page> createState() => Forget_PageState();
}

class Forget_PageState extends State<Forget_Page> {
  //
  var telegram_id_controller = TextEditingController();

  Dio dio = Dio(
    BaseOptions(
      baseUrl: HOST_API, //
      connectTimeout: Duration(seconds: 5), //
    ),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recovery Page')),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Center(
            child: Column(
              children: [
                // title
                SizedBox(
                  width: 600,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text('Recovery Credential', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),

                const SizedBox(height: 8),
                // Telegram id
                SizedBox(
                  width: 600,
                  child: TextField(
                    controller: telegram_id_controller,
                    decoration: InputDecoration(
                      labelText: 'Telegram ID',
                      suffixIcon: TextButton(
                        onPressed: () async {
                          await launchUrl(Uri.parse('https://t.me/gtr_otp_bot'));
                        },
                        child: Text('Open Bot.'),
                      ),
                      errorText: is_telegram_id_error(telegram_id: telegram_id_controller.text),
                    ),
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),

                const SizedBox(height: 16),
                // button reset password
                SizedBox(
                  width: 600,
                  height: 40,
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.lock_reset), //
                    onPressed: is_telegram_id_error(telegram_id: telegram_id_controller.text) == null
                        ? () async {
                            await dio
                                .post(
                                  '/credential/recovery', //
                                  data: FormData.fromMap({
                                    'telegram_id': telegram_id_controller.text, //
                                  }),
                                )
                                .then((response) {
                                  Navigator.pop(context);
                                  show_snackbar_message(context: context, message: 'Recovery successful.', color: Colors.green);
                                })
                                .catchError((error) {
                                  show_snackbar_message(context: context, message: 'Recovery failed.', color: Colors.red);
                                });
                          }
                        : null,
                    label: Text('Recover'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String? is_telegram_id_error({
  required String telegram_id, //
}) {
  // accept only number
  final regex = RegExp(r'^[0-9]+$');

  if (telegram_id.isEmpty) {
    return '* Please enter your Telegram ID.';
  }

  if (!regex.hasMatch(telegram_id)) {
    return '* numbers only.';
  }

  // accept
  return null;
}

void show_snackbar_message({
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
