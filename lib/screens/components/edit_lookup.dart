import 'package:flutter/material.dart';

class EditLookup extends StatefulWidget {
  final List<String> columns; // Column names
  final List<dynamic> rowData; // Current values
  final void Function(List<dynamic> newValues) onSave;

  const EditLookup({
    super.key,
    required this.columns,
    required this.rowData,
    required this.onSave,
  });

  @override
  State<EditLookup> createState() => _EditLookupState();
}

class _EditLookupState extends State<EditLookup> {
  final _formKey = GlobalKey<FormState>();
  late List<TextEditingController> _controllers;

  // Header hit text field
  // text field
  // Save Cancel

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.columns.length,
      (index) => TextEditingController(text: widget.rowData[index].toString()),
    );
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final newValues = _controllers.map((c) => c.text).toList();
      widget.onSave(newValues);
      Navigator.of(context).pop(); // Close dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Row"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: List.generate(widget.columns.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.columns[i],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      controller: _controllers[i],
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: const OutlineInputBorder(),
                      ),
                      validator:
                          (v) =>
                              v == null || v.isEmpty ? "Cannot be empty" : null,
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: _save,
          child: const Text("Save"),
        ),
      ],
    );
  }
}
