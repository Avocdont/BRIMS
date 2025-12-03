import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as scn;

class DeleteLookup<T> extends StatefulWidget {
  final T item;
  final void Function(T item) onDelete;

  const DeleteLookup({super.key, required this.item, required this.onDelete});

  @override
  State<DeleteLookup<T>> createState() => _DeleteLookupState<T>();
}

class _DeleteLookupState<T> extends State<DeleteLookup<T>> {
  void _delete() {
    widget.onDelete(widget.item);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Are you sure you want to delete?"),
      content: Row(
        children: [
          scn.PrimaryButton(onPressed: _delete, child: const Text('Delete')),
          scn.PrimaryButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
