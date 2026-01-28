import 'package:flutter/material.dart';

import 'package:gtr_app/pages/About.dart';
import 'package:gtr_app/pages/attendance/View_Attendance_Page.dart';
import 'package:gtr_app/pages/profile/Reset_Page.dart';
import 'package:gtr_app/pages/profile/Sign_In_Page.dart';
import 'package:gtr_app/pages/profile/Sign_Up.dart';

class Routes {
  static Sign_In() => _route(Sign_In_Page());
  static Sign_Up() => _route(Sign_Up_Page());
  static Reset() => _route(Reset_Page());
  static View_Attendance() => _route(View_Attendance_Page());

  // exposed routes
  static final Map<String, WidgetBuilder> routes = {
    '/about': (context) => const About_Page(), //
  };
}

MaterialPageRoute _route(Widget page) {
  return MaterialPageRoute(
    builder: (bc) => page, //
    settings: RouteSettings(), //
  );
}
