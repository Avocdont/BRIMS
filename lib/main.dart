import 'package:brims/screens/form_screen.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as scn;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return scn.ShadcnApp(
      theme: scn.ThemeData(
        colorScheme: scn.ColorSchemes.darkBlue(),
        radius: 0.5,
      ),
      home: Profile(),
    );
  }
}
