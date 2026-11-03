import 'package:flutter/material.dart';

import 'controllers/auth_controller.dart';
import 'repositories/auth_repository_impl.dart';
import 'views/auth/login_page.dart';

void main() => runApp(const StudentAuthApp());

class StudentAuthApp extends StatefulWidget {
  const StudentAuthApp({super.key});

  @override
  State<StudentAuthApp> createState() => _StudentAuthAppState();
}

class _StudentAuthAppState extends State<StudentAuthApp> {
  // Controller واحد يُمرَّر للشاشات الأربع، ويستقبل Repository عبر الحقن.
  late final AuthController _controller = AuthController(AuthRepositoryImpl());

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'نظام المصادقة الطلابي',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
      home: LoginPage(controller: _controller),
    );
  }
}
