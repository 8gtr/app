import 'package:flutter/material.dart';

import 'package:gtr_app/Environment.dart';
import 'package:gtr_app/routes/Routes.dart';
import 'package:gtr_app/utilities/Debug.dart';

class Left_Navigator extends StatefulWidget {
  const Left_Navigator({super.key});

  static void close_drawer(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  State<Left_Navigator> createState() => _Left_NavigatorState();
}

class _Left_NavigatorState extends State<Left_Navigator> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 200, //
            alignment: Alignment.center,
            child: Image.asset(
              'assets/background.png',
              height: 200,
              fit: BoxFit.cover, //
            ), //
          ),

          // Option
          ExpansionTile(
            leading: Icon(Icons.list_alt_outlined),
            title: Text('Options'),
            children: [
              ListTile(
                leading: Icon(Icons.school_outlined), //
                title: Text('Option #1', overflow: TextOverflow.ellipsis, maxLines: 1),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.school_outlined), //
                title: Text('Option #2', overflow: TextOverflow.ellipsis, maxLines: 1),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.school_outlined), //
                title: Text('Option #3', overflow: TextOverflow.ellipsis, maxLines: 1),
                onTap: () {},
              ),
            ],
          ),
          // Demo
          ExpansionTile(
            leading: Icon(Icons.list_alt_outlined),
            title: Text('Options'),
            children: [
              ListTile(
                leading: Icon(Icons.school_outlined), //
                title: Text('Option #1', overflow: TextOverflow.ellipsis, maxLines: 1),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.school_outlined), //
                title: Text('Option #2', overflow: TextOverflow.ellipsis, maxLines: 1),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.school_outlined), //
                title: Text('Option #3', overflow: TextOverflow.ellipsis, maxLines: 1),
                onTap: () {},
              ),
            ],
          ),

          // view attendance
          ListTile(
            leading: Icon(Icons.info_outline), //
            title: Text('View Attendance', overflow: TextOverflow.ellipsis, maxLines: 1),
            onTap: () {
              Navigator.of(context).pop(); //
              Navigator.of(context).push(Routes.View_Attendance());
            },
          ),

          // about us
          ListTile(
            leading: Icon(Icons.info_outline), //
            title: Text('About Us', overflow: TextOverflow.ellipsis, maxLines: 1),
            onTap: () {
              Navigator.pop(context); //
              // Navigator.of(context).pushNamed('/about');
            },
          ),
        ],
      ),
    );
  }
}
