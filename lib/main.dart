import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mafia1/models/role.dart';
import 'package:mafia1/models/user.dart';
import 'package:mafia1/screens/intro_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(RoleAdapter());
  await Hive.openBox('Users');
  await Hive.openBox('Roles');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Locale('fa'),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: IntroScreen(),
      ),
    );
  }
}
