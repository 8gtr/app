import 'package:flutter/material.dart';

import 'package:gtr_app/Environment.dart';
import 'package:gtr_app/routes/Routes.dart';
import 'package:gtr_app/utilities/Debug.dart';

class Navigator_Left extends StatefulWidget {
  const Navigator_Left({super.key});

  static void close_drawer(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  State<Navigator_Left> createState() => _Navigator_LeftState();
}

class _Navigator_LeftState extends State<Navigator_Left> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 200, //
            alignment: Alignment.center,
            child: Image.network(
              '$MINIO_PUBLIC/background.png',
              height: 200,
              fit: BoxFit.cover, //
            ), //
          ),

          // department
          ExpansionTile(
            leading: Icon(Icons.list_alt_outlined),
            title: Text('Department'),
            children: [
              ListTile(
                leading: Icon(Icons.school_outlined), //
                title: Text('Staffs', overflow: TextOverflow.ellipsis, maxLines: 1),
                onTap: () {
                  Navigator.of(context).pop(); //
                  Navigator.of(context).push(Routes.Staffs());
                },
              ),
              ListTile(
                leading: Icon(Icons.school_outlined), //
                title: Text('Students', overflow: TextOverflow.ellipsis, maxLines: 1),
                onTap: () {
                  Navigator.of(context).pop(); //
                  Navigator.of(context).push(Routes.Students());
                },
              ),
              ListTile(
                leading: Icon(Icons.school_outlined), //
                title: Text('Facilities', overflow: TextOverflow.ellipsis, maxLines: 1),
                onTap: () {
                  Navigator.of(context).pop(); //
                  Navigator.of(context).push(Routes.Facilities());
                },
              ),
              ListTile(
                leading: Icon(Icons.school_outlined), //
                title: Text('Alumni', overflow: TextOverflow.ellipsis, maxLines: 1),
                onTap: () {
                  Navigator.of(context).pop(); //
                  Navigator.of(context).push(Routes.Alumni());
                },
              ),
            ],
          ),

          // program
          ExpansionTile(
            leading: Icon(Icons.list_alt_outlined),
            title: Text('Program'),
            children: [
              ListTile(
                leading: Icon(Icons.school_outlined), //
                title: Text('Associat\'s Degree', overflow: TextOverflow.ellipsis, maxLines: 1),
                onTap: () {
                  Navigator.of(context).pop(); //
                  Navigator.of(context).push(Routes.Associate_Degree());
                },
              ),
              ListTile(
                leading: Icon(Icons.school_outlined), //
                title: Text('Engineer\'s Degree', overflow: TextOverflow.ellipsis, maxLines: 1),
                onTap: () {
                  Navigator.of(context).pop(); //
                  Navigator.of(context).push(Routes.Engineer_Degree());
                },
              ),
            ],
          ),

          // project
          ExpansionTile(
            leading: Icon(Icons.list_alt_outlined),
            title: Text('Project'),
            children: [
              ListTile(
                leading: Icon(Icons.school_outlined), //
                title: Text('Research Project', overflow: TextOverflow.ellipsis, maxLines: 1),
                onTap: () {
                  Navigator.of(context).pop(); //
                  Navigator.of(context).push(Routes.Research_Project());
                },
              ),
              ListTile(
                leading: Icon(Icons.school_outlined), //
                title: Text('Capacity Building Project', overflow: TextOverflow.ellipsis, maxLines: 1),
                onTap: () {
                  Navigator.of(context).pop(); //
                  Navigator.of(context).push(Routes.Capacity_Building_Project());
                },
              ),
              ListTile(
                leading: Icon(Icons.school_outlined), //
                title: Text('Publication', overflow: TextOverflow.ellipsis, maxLines: 1),
                onTap: () {
                  Navigator.of(context).pop(); //
                  Navigator.of(context).push(Routes.Publication());
                },
              ),
            ],
          ),

          // Lab & Services
          ExpansionTile(
            leading: Icon(Icons.list_alt_outlined),
            title: Text('Lab & Services'),
            children: [
              ListTile(
                leading: Icon(Icons.school_outlined), //
                title: Text('Digital Fab Lab', overflow: TextOverflow.ellipsis, maxLines: 1),
                onTap: () {
                  Navigator.of(context).pop(); //
                  Navigator.of(context).push(Routes.Digital_Fab_Lab());
                },
              ),
              ListTile(
                leading: Icon(Icons.school_outlined), //
                title: Text('EMC Lab', overflow: TextOverflow.ellipsis, maxLines: 1),
                onTap: () {
                  Navigator.of(context).pop(); //
                  Navigator.of(context).push(Routes.EMC_Lab());
                },
              ),
              ListTile(
                leading: Icon(Icons.school_outlined), //
                title: Text('Training', overflow: TextOverflow.ellipsis, maxLines: 1),
                onTap: () {
                  Navigator.of(context).pop(); //
                  Navigator.of(context).push(Routes.Training());
                },
              ),
            ],
          ),
          // courses
          // ExpansionTile(
          //   leading: Icon(Icons.list_alt_outlined),
          //   title: Text('Courses'),
          //   children: [
          //     ListTile(
          //       leading: Icon(Icons.school_outlined), //
          //       title: Text('Operating System', overflow: TextOverflow.ellipsis, maxLines: 1),
          //       onTap: () {
          //         Navigator.of(context).pop(); //
          //         Navigator.of(context).push(Routes.Operating_System());
          //       },
          //     ),
          //     ListTile(
          //       leading: Icon(Icons.school_outlined), //
          //       title: Text('Mobile Application', overflow: TextOverflow.ellipsis, maxLines: 1),
          //       onTap: () {
          //         Navigator.of(context).pop(); //
          //         Navigator.of(context).push(Routes.Mobile_Application());
          //       },
          //     ),
          //     ListTile(
          //       leading: Icon(Icons.school_outlined), //
          //       title: Text('Object Oriented Programming', overflow: TextOverflow.ellipsis, maxLines: 1),
          //       onTap: () {
          //         Navigator.of(context).pop(); //
          //         Navigator.of(context).push(Routes.Object_Oriented_Programming());
          //       },
          //     ),
          //     ListTile(
          //       leading: Icon(Icons.school_outlined), //
          //       title: Text('Network Administrator', overflow: TextOverflow.ellipsis, maxLines: 1),
          //       onTap: () {
          //         Navigator.of(context).pop(); //
          //         Navigator.of(context).push(Routes.Network_Administrator());
          //       },
          //     ),
          //   ],
          // ),
          // schedule
          ListTile(
            leading: Icon(Icons.info_outline), //
            title: Text('Schedule', overflow: TextOverflow.ellipsis, maxLines: 1),
            onTap: () {
              Navigator.of(context).pop(); //
              Navigator.of(context).push(Routes.Schedule());
            },
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
          // contact us
          ListTile(
            leading: Icon(Icons.info_outline), //
            title: Text('Contact Us', overflow: TextOverflow.ellipsis, maxLines: 1),
            onTap: () {
              Navigator.of(context).pop(); //
              Navigator.of(context).push(Routes.Contact_Us());
            },
          ),
          // thank
          ListTile(
            leading: Icon(Icons.info_outline), //
            title: Text('Contributors', overflow: TextOverflow.ellipsis, maxLines: 1),
            onTap: () {
              Navigator.pop(context); //
              Navigator.of(context).pushNamed('/about');
            },
          ),
        ],
      ),
    );
  }
}
