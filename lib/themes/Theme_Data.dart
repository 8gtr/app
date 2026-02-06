import 'package:flutter/material.dart';

class Theme_Data {
  static ThemeData get_theme() {
    return ThemeData(
      //
      //
      fontFamily: 'NotoSansKhmer',
      //
      //
      colorScheme: ColorScheme.fromSeed(
        // seedColor: Colors.yellow[800]!,
        seedColor: Colors.blue,
        // background: const Color(0xFFFFD700), // gold color
        // seedColor: const Color(0xFFC0C0C0), // silver color
        // primary: Colors.blueAccent, //
      ),

      // [APP BAR]
      //
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        // shape: const RoundedRectangleBorder(
        //   side: BorderSide(
        // color: Colors.grey,
        //     width: 1, //
        //   ),
        // ),
        // elevation: 0,
        // shape: const RoundedRectangleBorder(
        //   side: BorderSide(
        //     color: Colors.grey,
        //     width: 1, //
        //   ),
        // ),
        // elevation: 2,
      ),
      //
      //

      // [SCAFFOLD]
      //
      //
      //

      // [TEXT]
      //
      textTheme: const TextTheme(
        // bodyMedium: TextStyle(fontSize: 12.0), //
        // textcolor
      ),
      //
      //

      // [OUTLINED BUTTON]
      //
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 16.0), //
          foregroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0), //
          ),
          minimumSize: Size(0, 40),
          padding: EdgeInsets.symmetric(horizontal: 8),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: TextStyle(fontSize: 16.0), //
          foregroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0), //
          ),
        ),
      ),

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: Colors.blue, //
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0), //
          ),
        ),
      ),
      //
      //

      //
      //
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0), //
        ),
      ),

      drawerTheme: DrawerThemeData(
        width: 300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0), //
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        //
        border: const OutlineInputBorder(),
      ),

      // iconButtonTheme: IconButtonThemeData(
      //   style: IconButton.styleFrom(
      //     foregroundColor: Colors.blue, //
      //     backgroundColor: Colors.transparent,
      //   ),
      // ),
      //
      //
      // expansionTileTheme: ExpansionTileThemeData(
      //   iconColor: Colors.black,
      //   textColor: Colors.black,
      //   collapsedIconColor: Colors.black,
      //   collapsedTextColor: Colors.black, //
      // ),

      // listtile
      // listTileTheme: ListTileThemeData(
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(0), //
      //   ),
      //   textColor: Colors.blue,
      //   iconColor: Colors.blue,
      // ),
      // bottomAppBarTheme: BottomAppBarThemeData(color: Colors.amber),
      // scaffoldBackgroundColor: Colors.white,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        // backgroundColor: Colors.blue, //
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[600],
        type: BottomNavigationBarType.fixed,

        // set border around
        elevation: 10,
      ),

      // platform: TargetPlatform.iOS,
      useMaterial3: true,
    );
  }
}

// usage: Themes_Data.theme
