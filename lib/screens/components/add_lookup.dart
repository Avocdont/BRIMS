import 'package:flutter/material.dart';

class AddLookup extends StatefulWidget {
  final List<String> columns; // Column names
  final Future<void> Function(List<String> values)
  onInsert; // Callback function

  const AddLookup({super.key, required this.columns, required this.onInsert});

  @override
  State<AddLookup> createState() => _AddLookupState();
}

class _AddLookupState extends State<AddLookup> {
  final _formKey = GlobalKey<FormState>();
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.columns.length, // Number of elements to be generated
      (index) => TextEditingController(), // Starts at index 0
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _insert() async {
    if (_formKey.currentState!.validate()) {
      // Makes a bunch of iterable then turns it into a list
      final values = _controllers.map((c) => c.text).toList();
      await widget.onInsert(values); // Uses the passed insert function
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Row"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: List.generate(widget.columns.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.columns[index],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    TextFormField(
                      controller: _controllers[index],
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: const OutlineInputBorder(),
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? "Cannot be empty"
                                  : null,
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
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          onPressed: _insert,
          child: const Text("Insert", style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}
