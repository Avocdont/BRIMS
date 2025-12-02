import 'package:brims/locator.dart';
import 'package:brims/provider/lookup_provider.dart';
import 'package:brims/screens/lookup_table_edit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as scn;

void main() {
  runApp(const MainApp());
  setUp();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LookupProvider>(create: (_) => LookupProvider()),
      ],
      child: scn.ShadcnApp(
        theme: scn.ThemeData(
          colorScheme: scn.ColorSchemes.darkBlue(),
          radius: 0.5,
        ),
        home: LookupTableEdit(),
      ),
    );
  }
}
