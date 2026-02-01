import 'package:flutter/material.dart';

import 'package:gtr_app/pages/contributors/Contributor.dart';
import 'package:gtr_app/pages/Contact_Us.dart';
import 'package:gtr_app/pages/Schedule.dart';
import 'package:gtr_app/pages/attendance/QR_Generator_Page.dart';
import 'package:gtr_app/pages/attendance/QR_Scan_Page.dart';
import 'package:gtr_app/pages/attendance/View_Attendance_Page.dart';
import 'package:gtr_app/pages/courses/Mobile_Application.dart';
import 'package:gtr_app/pages/courses/Network_Administrator.dart';
import 'package:gtr_app/pages/courses/Object_Oriented_Programming.dart';
import 'package:gtr_app/pages/courses/Operating_System.dart';
import 'package:gtr_app/pages/department/Alumni.dart';
import 'package:gtr_app/pages/department/Facilities.dart';
import 'package:gtr_app/pages/department/Staffs.dart';
import 'package:gtr_app/pages/department/Students.dart';
import 'package:gtr_app/pages/lab_and_service/Digital_FAB_Lab.dart';
import 'package:gtr_app/pages/lab_and_service/EMC_Lab.dart';
import 'package:gtr_app/pages/lab_and_service/Training.dart';
import 'package:gtr_app/pages/profile/Reset_Page.dart';
import 'package:gtr_app/pages/profile/Sign_In_Page.dart';
import 'package:gtr_app/pages/profile/Sign_Up.dart';
import 'package:gtr_app/pages/program/Associate_Degree.dart';
import 'package:gtr_app/pages/program/Engineer_Degree.dart';
import 'package:gtr_app/pages/project/Capacity_Building_Project.dart';
import 'package:gtr_app/pages/project/Publication.dart';
import 'package:gtr_app/pages/project/Research_Project.dart';

class Routes {
  // anonymous routes
  static Sign_In() => _route(Sign_In_Page());
  static Sign_Up() => _route(Sign_Up_Page());
  static Reset() => _route(Reset_Page());
  static View_Attendance() => _route(View_Attendance_Page());
  static QR_Scan() => _route(QR_Scan_Page());
  static QR_Generator() => _route(QR_Generator_Page());

  //
  static Staffs() => _route(Staffs_Page());
  static Students() => _route(Students_Page());
  static Facilities() => _route(Facilities_Page());
  static Alumni() => _route(Alumni_Page());
  //
  static Associate_Degree() => _route(Associate_Degree_Page());
  static Engineer_Degree() => _route(Engineer_Degree_Page());
  //
  static Research_Project() => _route(Research_Project_Page());
  static Capacity_Building_Project() => _route(Capacity_Building_Page());
  static Publication() => _route(Publication_Page());
  //
  static Digital_Fab_Lab() => _route(Digital_Fab_Lab_Page());
  static EMC_Lab() => _route(EMC_Lab_Page());
  static Training() => _route(Training_Page());
  //
  static Contact_Us() => _route(Contact_Us_Page());
  static Schedule() => _route(Schedule_Page());
  //
  static Operating_System() => _route(Operating_System_Page());
  static Mobile_Application() => _route(Mobile_Application_Page());
  static Object_Oriented_Programming() => _route(Object_Oriented_Programming_Page());
  static Network_Administrator() => _route(Network_Administrator_Page());

  // exposed routes
  static final Map<String, WidgetBuilder> routes = {
    '/about': (context) => const Contributor_Page(), //
  };
}

MaterialPageRoute _route(Widget page) {
  return MaterialPageRoute(
    builder: (bc) => page, //
    settings: RouteSettings(), //
  );
}
