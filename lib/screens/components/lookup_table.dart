import 'package:brims/screens/components/delete_lookup.dart';
import 'package:brims/screens/components/edit_lookup.dart';
import 'package:flutter/material.dart';

class LookupTable<T> extends StatelessWidget {
  final List<String> columns;
  final List<T> items; // Row data
  // A callback function that returns a List<dynamic>
  final List<dynamic> Function(T item) buildRow;
  final void Function(T item, List<dynamic> newValues)? onEdit;
  final void Function(T item)? onDelete;

  const LookupTable({
    super.key,
    required this.columns,
    required this.items,
    required this.buildRow,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DataTable(
          columns: [
            ...columns.map(
              // For every column, return DataColumn
              (column) => DataColumn(
                label: Text(
                  column,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const DataColumn(
              label: Text(
                "Actions",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          rows:
              items.isEmpty
                  ? [
                    DataRow(
                      cells: [
                        DataCell(const Text('No data yet')),
                        for (int i = 1; i < columns.length + 1; i++)
                          DataCell.empty,
                      ],
                    ),
                  ]
                  : List.generate(items.length, (index) {
                    final item = items[index];
                    final row = buildRow(item);
                    return DataRow(
                      cells: [
                        ...row.map((val) => DataCell(Text(val.toString()))),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  if (onEdit != null) {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (_) => EditLookup(
                                            columns: columns,
                                            rowData: row,
                                            onSave:
                                                (newValues) =>
                                                    onEdit!(item, newValues),
                                          ),
                                    );
                                  }
                                },
                              ),

                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red.shade400,
                                onPressed:
                                    () => {
                                      if (onDelete != null)
                                        {
                                          showDialog(
                                            context: context,
                                            builder:
                                                (_) => DeleteLookup<T>(
                                                  item: item,
                                                  onDelete: onDelete!,
                                                ),
                                          ),
                                        },
                                    },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
        ),
      ],
    );
  }
}
