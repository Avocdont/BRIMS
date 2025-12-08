import 'package:flutter/material.dart';

class BarangayPage extends StatefulWidget {
  const BarangayPage({super.key});

  @override
  State<BarangayPage> createState() => _BarangayPageState();
}

class _BarangayPageState extends State<BarangayPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Barangay"));
  }
}
