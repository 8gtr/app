import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gtr_app/pages/profile/Update_Form.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:gtr_app/Environment.dart';
import 'package:gtr_app/utilities/Debug.dart';
import 'package:gtr_app/routes/Routes.dart';
import 'package:gtr_app/themes/Theme_Data.dart';
import 'package:gtr_app/routes/Navigator_Left.dart';

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
      home: const Profile_Page(),
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class Profile_Page extends StatefulWidget {
  const Profile_Page({super.key});

  @override
  State<Profile_Page> createState() => _Profile_PageState();
}

class _Profile_PageState extends State<Profile_Page> {
  @override
  void initState() {
    debug('Profile Page Loaded');
    super.initState();
    init();
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
  String? access_token;

  String? id;
  String? name;
  String? phone_number;
  String? email;
  String? address;

  //
  String? role;

  //
  String? username;
  String? password;
  String? telegram_id;
  String? profile_image;
  String? background_image;

  void init() async {
    id = null;
    name = null;
    phone_number = null;
    email = null;
    address = null;
    role = null;
    //
    username = null;
    password = null;
    telegram_id = null;
    profile_image = null;
    background_image = null;

    access_token = await secure_storage.read(key: 'access_token');
    debug('Access Token: $access_token');

    if (access_token != null) {
      dio.options.headers['Authorization'] = 'Bearer $access_token';

      await dio
          .post(
            '/credential/read', //
            data: FormData.fromMap({}),
          )
          .then((r) {
            debug('Credential Data: ${r.data}');
            id = r.data['id'];
            name = r.data['name'];
            phone_number = r.data['phone_number'];
            email = r.data['email'];
            address = r.data['address'];
            role = r.data['role'];
            debug(role);
            //
            username = r.data['username'];
            password = r.data['password_hash'];
            telegram_id = r.data['telegram_id'];
            profile_image = r.data['profile_image'];
            background_image = r.data['background_image'];
            // debug(background_image!);

            setState(() {});
          })
          .catchError((e) {});
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile Page")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SizedBox(
              width: 600,
              child: Column(
                children: [
                  // background and profile
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          SizedBox(
                            width: 600,
                            height: 200, //
                            child: background_image == null
                                ? Image.asset(
                                    'assets/background.png',
                                    fit: BoxFit.cover, //
                                  )
                                : Image.network(
                                    '$MINIO/$background_image',
                                    fit: BoxFit.cover, //
                                  ),
                          ),
                          if (access_token != null)
                            IconButton(
                              onPressed: () async {
                                // upload background image
                                final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

                                if (image == null) {
                                  return;
                                }

                                await dio
                                    .post(
                                      '/credential/upload', //
                                      data: FormData.fromMap({
                                        'background_image': MultipartFile.fromBytes(
                                          await image.readAsBytes(), //
                                          filename: image.name,
                                        ),
                                      }),
                                    )
                                    .then((r) {
                                      init();
                                      show_snackbar(context: context, message: 'Update Success', color: Colors.green);
                                    })
                                    .catchError((e) {
                                      show_snackbar(context: context, message: 'Update Fail', color: Colors.red);
                                    });
                              },
                              icon: Icon(Icons.upload_outlined, color: Colors.blue),
                            ),
                        ],
                      ),

                      // profile
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: profile_image == null
                                ? Image.asset('assets/logo.png', fit: BoxFit.cover) //
                                : Image.network('$MINIO/$profile_image', fit: BoxFit.cover), //
                          ),
                          if (access_token != null)
                            IconButton(
                              onPressed: () async {
                                // upload background image
                                final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

                                // if no image selected
                                if (image == null) return;

                                // upload image to server
                                await dio
                                    .post(
                                      '/credential/upload', //
                                      data: FormData.fromMap({
                                        'profile_image': MultipartFile.fromBytes(
                                          await image.readAsBytes(), //
                                          filename: image.name,
                                        ),
                                      }),
                                    )
                                    .then((r) {
                                      init();
                                      show_snackbar(context: context, message: 'Update Success', color: Colors.green);
                                    })
                                    .catchError((e) {
                                      show_snackbar(context: context, message: 'Update Fail', color: Colors.red);
                                    });
                              },
                              icon: Icon(Icons.upload_outlined, color: Colors.blue),
                            ),
                        ],
                      ),
                    ],
                  ),

                  // sign in and sign up buttons
                  if (access_token == null) ...[
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(Routes.Sign_In()).then((value) => init());
                          },
                          child: Text('Sign In'),
                        ), //
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(Routes.Sign_Up()).then((value) {
                              if (value == true) {
                                Navigator.of(context).push(Routes.Sign_In()).then((value) => init());
                              }
                            });
                          },
                          child: Text('Sign Up'),
                        ), //
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(Routes.Reset()).then((value) {
                              if (value == true) {
                                Navigator.of(context).push(Routes.Sign_In()).then((value) => init());
                              }
                            });
                          },
                          child: Text('Reset'),
                        ), //
                      ],
                    ),
                  ],

                  // teacher
                  if (access_token != null && role == 'teacher') ...[
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(Routes.QR_Generator());
                          },
                          child: Text('Check Attendance'),
                        ), //
                        //
                      ],
                    ),
                  ],

                  // student
                  if (access_token != null && (role == null || role == 'student')) ...[
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator //
                                .of(context)
                                .push(Routes.QR_Scan())
                                .then((output) async {
                                  if (output != null) {
                                    await dio
                                        .post(
                                          "/attendance/qr_scan",
                                          data: FormData.fromMap({
                                            "code": output, //
                                          }),
                                        )
                                        .then((r) {
                                          show_snackbar(context: context, message: 'Scan Successful', color: Colors.green);
                                        })
                                        .catchError((e) {
                                          show_snackbar(context: context, message: 'Scan Failed: $e', color: Colors.red);
                                        });
                                  }
                                });
                          },
                          child: Text('Scan Attendance'),
                        ), //
                        //
                      ],
                    ),
                  ],

                  SizedBox(height: 8),

                  ExpansionTile(
                    title: Text('Information', style: TextStyle(fontWeight: FontWeight.bold)),
                    tilePadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                    initiallyExpanded: true,
                    children: [
                      //
                      Row(
                        children: [
                          Icon(Icons.badge), //
                          SizedBox(width: 8, height: 40),
                          Text("ID: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(id ?? ""),
                          Spacer(),
                          if (access_token != null)
                            IconButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(
                                      MaterialPageRoute(
                                        builder: (context) => Update_Form(
                                          title: 'ID', //
                                          input: id ?? '',
                                        ),
                                      ),
                                    )
                                    .then((output) async {
                                      debug(output);
                                      if (output == null) return;
                                      await dio
                                          .post(
                                            '/credential/update', //
                                            data: FormData.fromMap({'id': output}),
                                          )
                                          .then((r) {
                                            init();
                                            show_snackbar(context: context, message: 'Update Success', color: Colors.green);
                                          })
                                          .catchError((e) {
                                            show_snackbar(context: context, message: 'Update Fail', color: Colors.red);
                                          });
                                    });
                              },
                              icon: Icon(Icons.edit),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.person), //
                          SizedBox(width: 8, height: 40),
                          Text("Name: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(name ?? ""),
                          Spacer(),
                          if (access_token != null)
                            IconButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(
                                      MaterialPageRoute(
                                        builder: (context) => Update_Form(
                                          title: 'Name', //
                                          input: name ?? '',
                                        ),
                                      ),
                                    )
                                    .then((output) async {
                                      debug(output);
                                      if (output == null) return;
                                      await dio
                                          .post(
                                            '/credential/update', //
                                            data: FormData.fromMap({'name': output}),
                                          )
                                          .then((r) {
                                            init();
                                            show_snackbar(context: context, message: 'Update Success', color: Colors.green);
                                          })
                                          .catchError((e) {
                                            show_snackbar(context: context, message: 'Update Fail', color: Colors.red);
                                          });
                                    });
                              },
                              icon: Icon(Icons.edit),
                            ),
                        ],
                      ),
                      //
                      Row(
                        children: [
                          Icon(Icons.phone), //
                          SizedBox(width: 8, height: 40),
                          Text("Phone: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(phone_number ?? ""),
                          Spacer(),
                          if (access_token != null)
                            IconButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(
                                      MaterialPageRoute(
                                        builder: (context) => Update_Form(
                                          title: 'Phone Number', //
                                          input: phone_number ?? '',
                                          keyboard_type: TextInputType.phone,
                                        ),
                                      ),
                                    )
                                    .then((output) async {
                                      debug(output);
                                      if (output == null) return;
                                      await dio
                                          .post(
                                            '/credential/update', //
                                            data: FormData.fromMap({'phone_number': output}),
                                          )
                                          .then((r) {
                                            init();
                                            show_snackbar(context: context, message: 'Update Success', color: Colors.green);
                                          })
                                          .catchError((e) {
                                            show_snackbar(context: context, message: 'Update Fail', color: Colors.red);
                                          });
                                    });
                              },
                              icon: Icon(Icons.edit),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.phone), //
                          SizedBox(width: 8, height: 40),
                          Text("Email: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(email ?? ""),
                          Spacer(),
                          if (access_token != null)
                            IconButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(
                                      MaterialPageRoute(
                                        builder: (context) => Update_Form(
                                          title: 'Email', //
                                          input: email ?? '',
                                          keyboard_type: TextInputType.emailAddress,
                                        ),
                                      ),
                                    )
                                    .then((output) async {
                                      debug(output);
                                      if (output == null) return;
                                      await dio
                                          .post(
                                            '/credential/update', //
                                            data: FormData.fromMap({'email': output}),
                                          )
                                          .then((r) {
                                            init();
                                            show_snackbar(context: context, message: 'Update Success', color: Colors.green);
                                          })
                                          .catchError((e) {
                                            show_snackbar(context: context, message: 'Update Fail', color: Colors.red);
                                          });
                                    });
                              },
                              icon: Icon(Icons.edit),
                            ),
                        ],
                      ),
                      //
                      Row(
                        children: [
                          Icon(Icons.place), //
                          SizedBox(width: 8, height: 40),
                          Text("Address: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(address ?? ""),
                          Spacer(),
                          if (access_token != null)
                            IconButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(
                                      MaterialPageRoute(
                                        builder: (context) => Update_Form(
                                          title: 'Address', //
                                          input: address ?? '',
                                        ),
                                      ),
                                    )
                                    .then((output) async {
                                      debug(output);
                                      if (output == null) return;
                                      await dio
                                          .post(
                                            '/credential/update', //
                                            data: FormData.fromMap({'address': output}),
                                          )
                                          .then((r) {
                                            init();
                                            show_snackbar(context: context, message: 'Update Success', color: Colors.green);
                                          })
                                          .catchError((e) {
                                            show_snackbar(context: context, message: 'Update Fail', color: Colors.red);
                                          });
                                    });
                              },
                              icon: Icon(Icons.edit),
                            ),
                        ],
                      ),
                    ],
                  ),

                  // credential
                  ExpansionTile(
                    title: Text('Credential', style: TextStyle(fontWeight: FontWeight.bold)),
                    tilePadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                    initiallyExpanded: kDebugMode,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person), //
                          SizedBox(width: 8, height: 40),
                          Text("Username: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(username ?? ""),
                          Spacer(),
                          if (access_token != null)
                            IconButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(
                                      MaterialPageRoute(
                                        builder: (context) => Update_Form(
                                          title: 'Username', //
                                          input: username ?? '',
                                        ),
                                      ),
                                    )
                                    .then((output) async {
                                      debug(output);
                                      if (output == null) return;
                                      await dio
                                          .post(
                                            '/credential/update', //
                                            data: FormData.fromMap({'username': output}),
                                          )
                                          .then((r) {
                                            init();
                                            show_snackbar(context: context, message: 'Update Success', color: Colors.green);
                                          })
                                          .catchError((e) {
                                            show_snackbar(context: context, message: 'Update Fail', color: Colors.red);
                                          });
                                    });
                              },
                              icon: Icon(Icons.edit),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.security_rounded), //
                          SizedBox(width: 8, height: 40),
                          Text("Password: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(access_token != null ? "**********" : ""),
                          Spacer(),
                          if (access_token != null)
                            IconButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(
                                      MaterialPageRoute(
                                        builder: (context) => Update_Form(
                                          title: 'Password', //
                                          input: '',
                                        ),
                                      ),
                                    )
                                    .then((output) async {
                                      debug(output);
                                      if (output == null) return;
                                      await dio
                                          .post(
                                            '/credential/update', //
                                            data: FormData.fromMap({'password': output}),
                                          )
                                          .then((r) {
                                            init();
                                            show_snackbar(context: context, message: 'Update Success', color: Colors.green);
                                          })
                                          .catchError((e) {
                                            show_snackbar(context: context, message: 'Update Fail', color: Colors.red);
                                          });
                                    });
                              },
                              icon: Icon(Icons.edit),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.telegram), //
                          SizedBox(width: 8, height: 40),
                          Text("Telegram ID: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(telegram_id ?? ""),
                          Spacer(),
                          if (access_token != null)
                            IconButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(
                                      MaterialPageRoute(
                                        builder: (context) => Update_Form(
                                          title: 'Telegram ID', //
                                          input: telegram_id ?? '',
                                          keyboard_type: TextInputType.number,
                                        ),
                                      ),
                                    )
                                    .then((output) async {
                                      debug(output);
                                      if (output == null) return;
                                      await dio
                                          .post(
                                            '/credential/update', //
                                            data: FormData.fromMap({'telegram_id': output}),
                                          )
                                          .then((r) {
                                            init();
                                            show_snackbar(context: context, message: 'Update Success', color: Colors.green);
                                          })
                                          .catchError((e) {
                                            show_snackbar(context: context, message: 'Update Fail', color: Colors.red);
                                          });
                                    });
                              },
                              icon: Icon(Icons.edit),
                            ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 8),

                  // sign out button
                  if (access_token != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            // debug('Sign Out Clicked');
                            secure_storage.delete(key: 'access_token');
                            init();
                          },
                          child: Text('Sign Out', style: TextStyle(color: Colors.red)),
                        ), //
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),

      drawer: const Navigator_Left(),
    );
  }
}

Future<String?> show_edit_dialog({
  required BuildContext context, //
  required String title,
  required String input,
  TextInputType? keyboard_type,
}) {
  final controller = TextEditingController(text: input);

  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: 400,
        child: TextField(
          controller: controller, //
          keyboardType: keyboard_type ?? TextInputType.text,
          //   autofocus: true, //
          onSubmitted: (value) => Navigator.of(ctx).pop(controller.text),
        ),
      ),
      actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(controller.text), child: Text('Save'))],
    ),
  );
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
