import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gtr_app/Environment.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() async {
  runApp(MaterialApp(home: QR_Generator_Page()));
}

class QR_Generator_Page extends StatefulWidget {
  const QR_Generator_Page({super.key});

  @override
  State<QR_Generator_Page> createState() => QR_Generator_PageState();
}

class QR_Generator_PageState extends State<QR_Generator_Page> {
  bool is_enable_scan = false;
  bool is_selected_class_name = false;
  bool is_selected_class_type = false;

  String qr = "";

  List<String> _class_names = [];
  List<String> _class_types = [];

  String class_name = "";
  String class_type = "";

  Dio dio = Dio(
    BaseOptions(
      baseUrl: HOST_API, //
      contentType: Headers.formUrlEncodedContentType, //
      connectTimeout: Duration(seconds: 5), //
    ),
  );
  FlutterSecureStorage secure_storage = FlutterSecureStorage();

  String? access_token;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    access_token = await secure_storage.read(key: "access_token");

    if (access_token != null) {
      dio.options.headers['Authorization'] = 'Bearer $access_token';

      await dio
          .post("/attendance/classes") //
          .then((response) {
            for (var item in response.data) {
              _class_names.add(item["class_name"]);
            }
            setState(() {});
          })
          .catchError((_) {
            show_snackbar_message(context: context, message: "Error", color: Colors.red);
          });

      await dio
          .post("/attendance/class_types") //
          .then((response) {
            for (var item in response.data) {
              _class_types.add(item["class_type"]);
            }
            setState(() {});
          })
          .catchError((_) {
            show_snackbar_message(context: context, message: "Error", color: Colors.red);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Generate QR Page")),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: DropdownWithSearch(
                      items: _class_names,
                      isEnabled: !is_enable_scan,
                      onChanged: (value) {
                        is_selected_class_name = value != null ? true : false;
                        class_name = value ?? "";
                        setState(() {});
                      },
                    ),
                  ),

                  SizedBox(width: 8),

                  Expanded(
                    child: DropdownWithSearch(
                      items: _class_types,
                      isEnabled: !is_enable_scan,
                      onChanged: (value) {
                        is_selected_class_type = value != null ? true : false;
                        class_type = value ?? "";
                        setState(() {});
                      },
                    ),
                  ),

                  SizedBox(width: 8),

                  // enable scan
                  if (!is_enable_scan)
                    OutlinedButton.icon(
                      icon: Icon(Icons.play_arrow, color: Colors.green),
                      label: Text("Enable", style: TextStyle(color: Colors.green)), //
                      onPressed: (is_selected_class_name && is_selected_class_type)
                          ? () async {
                              String timestamp = DateTime.now().toIso8601String().replaceAll(RegExp(r'\D'), '');
                              await dio
                                  .post(
                                    '/attendance/enable_qr_scan',
                                    data: FormData.fromMap({
                                      "code": timestamp.toString(), //
                                      "class_name": class_name, //
                                      "class_type": class_type, //
                                    }),
                                  )
                                  .then((response) {
                                    is_enable_scan = true;
                                    qr = timestamp;
                                    setState(() {});
                                    show_snackbar_message(context: context, message: "QR enabled", color: Colors.green);
                                  })
                                  .catchError((error) {
                                    show_snackbar_message(context: context, message: "Error", color: Colors.red);
                                  });
                            }
                          : null,
                    ),

                  // disable scan
                  if (is_enable_scan)
                    OutlinedButton.icon(
                      icon: Icon(Icons.stop, color: Colors.red),
                      label: Text("Disable", style: TextStyle(color: Colors.red)), //
                      onPressed: (is_selected_class_name && is_selected_class_type)
                          ? () async {
                              await dio
                                  .post('/attendance/disable_qr_scan')
                                  .then((response) {
                                    is_enable_scan = false;
                                    qr = "";
                                    setState(() {});
                                    show_snackbar_message(context: context, message: "QR disabled", color: Colors.green);
                                  })
                                  .catchError((error) {
                                    show_snackbar_message(context: context, message: "Error", color: Colors.red);
                                  });
                            }
                          : null,
                    ),
                ],
              ),
              if (is_enable_scan)
                Expanded(
                  child: QrImageView(
                    data: qr, //
                  ),
                ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class DropdownWithSearch<T> extends StatefulWidget {
  final List<T> items;
  final T? initialValue;
  final ValueChanged<T?>? onChanged;
  final String hintText;
  final bool allowClear;
  final bool isEnabled;

  const DropdownWithSearch({
    //
    super.key,
    required this.items,
    this.initialValue,
    this.onChanged,
    this.hintText = '',
    this.allowClear = true,
    this.isEnabled = true,
  });

  @override
  State<DropdownWithSearch<T>> createState() => _DropdownWithSearchState<T>();
}

class _DropdownWithSearchState<T> extends State<DropdownWithSearch<T>> {
  T? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
  }

  void _openSearchDialog() async {
    if (!widget.isEnabled) return;
    final T? result = await showDialog<T>(
      context: context,
      builder: (context) => _SearchDialog<T>(items: widget.items, initialSelection: _selected, hintText: widget.hintText, allowClear: widget.allowClear),
    );

    if (result != null || (result == null && widget.allowClear == true)) {
      setState(() => _selected = result);
      widget.onChanged?.call(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final display = _selected?.toString();

    return GestureDetector(
      onTap: widget.isEnabled ? _openSearchDialog : null,
      child: Opacity(
        opacity: widget.isEnabled ? 1.0 : 0.6,
        child: InputDecorator(
          decoration: InputDecoration(
            enabled: widget.isEnabled,
            labelText: widget.hintText.isNotEmpty ? widget.hintText : null,
            border: const OutlineInputBorder(),
            suffixIcon: _selected != null && widget.allowClear && widget.isEnabled
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() => _selected = null);
                      widget.onChanged?.call(null);
                    },
                  )
                : Icon(Icons.arrow_drop_down, color: widget.isEnabled ? null : Theme.of(context).disabledColor),
          ),
          // Ensure the text does not wrap and shows ellipsis when too long
          child: Text(
            display ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: display != null ? (widget.isEnabled ? null : TextStyle(color: Theme.of(context).disabledColor)) : TextStyle(color: widget.isEnabled ? Theme.of(context).hintColor : Theme.of(context).disabledColor),
          ),
        ),
      ),
    );
  }
}

class _SearchDialog<T> extends StatefulWidget {
  final List<T> items;
  final T? initialSelection;
  final String hintText;
  final bool allowClear;

  const _SearchDialog({super.key, required this.items, this.initialSelection, this.hintText = '', this.allowClear = true});

  @override
  State<_SearchDialog<T>> createState() => _SearchDialogState<T>();
}

class _SearchDialogState<T> extends State<_SearchDialog<T>> {
  late List<T> _filtered;
  final TextEditingController _searchController = TextEditingController();
  T? _selected;

  @override
  void initState() {
    super.initState();
    _filtered = List<T>.from(widget.items);
    _selected = widget.initialSelection;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final q = _searchController.text.toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filtered = List<T>.from(widget.items);
      } else {
        _filtered = widget.items.where((e) => e.toString().toLowerCase().contains(q)).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.hintText.isNotEmpty ? Text(widget.hintText) : null,
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(hintText: 'Search...'),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _filtered.isEmpty
                  ? const Center(child: Text('No results'))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) {
                        final item = _filtered[index];
                        final label = item.toString();
                        final selected = _selected != null && _selected.toString() == label;
                        return ListTile(
                          title: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: false),
                          trailing: selected ? const Icon(Icons.check) : null,
                          onTap: () {
                            _selected = item;
                            Navigator.of(context).pop<T>(_selected);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [TextButton(onPressed: () => Navigator.of(context).pop<T?>(widget.initialSelection), child: const Text('Cancel'))],
    );
  }
}

void pprint(dynamic data) {
  const encoder = JsonEncoder.withIndent('  ');
  print(encoder.convert(data));
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
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: color,
      ),
    );
}
