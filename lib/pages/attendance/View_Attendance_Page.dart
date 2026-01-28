import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
      home: const View_Attendance_Page(), //
      debugShowCheckedModeBanner: false, //
    );
  }
}

class View_Attendance_Page extends StatefulWidget {
  const View_Attendance_Page({super.key});

  @override
  State<View_Attendance_Page> createState() => _View_Attendance_PageState();
}

class _View_Attendance_PageState extends State<View_Attendance_Page> {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: HOST_API, //
      connectTimeout: Duration(seconds: 10), //
      sendTimeout: Duration(seconds: 10), //
      receiveTimeout: Duration(seconds: 10), //
    ),
  );

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    dio
        .post('/attendance/attendances')
        .then((r) {
          loading = false;
          response = r.data;
          setState(() {});
        })
        .catchError((_) {
          loading = false;
          response = null;
          setState(() {});
          // show_snackbar_message(context: context, message: "Error", color: Colors.red);
        });
  }

  dynamic response;
  bool loading = true;
  String? error;

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (error != null) {
      body = Center(child: Text('Error: $error'));
    } else if (response == null || response == null) {
      body = const Center(child: Text('No data available'));
    } else {
      body = JsonTableWithSearch(
        //
        jsonList: response,
        preferredOrder: [
          //
          'Name',
          'Sub',
          'Type',
          'Scaned At',
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('View Attendance Page')),
      body: body,
    );
  }
}

class JsonTableWithSearch extends StatefulWidget {
  const JsonTableWithSearch({required this.jsonList, this.preferredOrder, super.key});

  // Accept dynamic list because the response body may be List<dynamic>
  final List<dynamic> jsonList;
  // Optional preferred column order (by column name)
  final List<String>? preferredOrder;

  @override
  State<JsonTableWithSearch> createState() => _JsonTableWithSearchState();
}

class _JsonTableWithSearchState extends State<JsonTableWithSearch> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Build a column list preserving preferred order first (if provided),
  // then first-seen order across all rows for remaining columns.
  List<String> _buildColumns() {
    final cols = <String>[];
    final seen = <String>{};

    if (widget.preferredOrder != null) {
      for (final pref in widget.preferredOrder!) {
        for (final row in widget.jsonList) {
          if (row is Map && row.containsKey(pref) && !seen.contains(pref)) {
            cols.add(pref);
            seen.add(pref);
            break;
          }
        }
      }
    }

    for (final row in widget.jsonList) {
      if (row is Map) {
        for (final key in row.keys) {
          final k = key.toString();
          if (!seen.contains(k)) {
            cols.add(k);
            seen.add(k);
          }
        }
      }
    }
    return cols;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.jsonList.isEmpty) {
      return const Center(child: Text("No data available"));
    }

    final columns = _buildColumns();
    final filter = _controller.text.trim().toLowerCase();

    // Filter rows using a single global filter
    final filtered = widget.jsonList.where((row) {
      if (filter.isEmpty) return true;
      if (row is Map) {
        // match if any column value contains the filter
        for (final col in columns) {
          final val = row.containsKey(col) ? (row[col]?.toString() ?? '') : '';
          if (val.toLowerCase().contains(filter)) return true;
        }
        return false;
      } else {
        return row.toString().toLowerCase().contains(filter);
      }
    }).toList();

    return Center(
      child: Column(
        children: [
          // Single global filter input
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: SizedBox(
              width: double.infinity,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Search',
                  hintText: 'Search',
                  border: const OutlineInputBorder(),
                  isDense: true,
                  suffixIcon: _controller.text.isNotEmpty ? IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() => _controller.clear())) : null,
                ),
                autofocus: true,
              ),
            ),
          ),

          // Table with header + rows
          Expanded(
            child: SingleChildScrollView(
              // vertical scroll
              child: SingleChildScrollView(
                // horizontal scroll
                scrollDirection: Axis.horizontal,
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: {for (int i = 0; i < columns.length; i++) i: IntrinsicColumnWidth()},
                  children: [
                    // Header row
                    TableRow(
                      decoration: BoxDecoration(color: Theme.of(context).dividerColor.withOpacity(0.06)),
                      children: columns
                          .map(
                            (col) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                              child: Text(col, style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          )
                          .toList(),
                    ),
                    // Data rows
                    ...filtered.map((row) {
                      return TableRow(
                        children: columns.map((col) {
                          final v = (row is Map && row.containsKey(col)) ? row[col] : null;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                            child: Text(v?.toString() ?? '', style: const TextStyle(fontSize: 14)),
                          );
                        }).toList(),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// void show_snackbar_message({
//   required BuildContext context, //
//   required String message, //
//   required Color color, //
// }) {
//   ScaffoldMessenger.of(context)
//     ..hideCurrentSnackBar()
//     ..showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(Icons.info_outline, color: Colors.white),
//             const SizedBox(width: 8),
//             Text(message),
//           ],
//         ),
//         backgroundColor: color,
//       ),
//     );
// }
