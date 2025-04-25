import 'package:flutter/material.dart';
import 'widgets/home_navigation.dart';
import 'database/db_helper.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeNavigation(),
    );
  }
}
