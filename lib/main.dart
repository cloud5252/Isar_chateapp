import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:isar_chateapp/App/locator.locator.dart';
import 'package:provider/provider.dart';
import 'package:isar_chateapp/Services/Isar_services/Isar_service.dart';
import 'Services/auth_gate.dart';
import 'Themes/theme_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await IsarService.init();
  await setupLocator();

  runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(), child: const Myapp()));
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const AuthGate(),
    );
  }
}
