import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_pr/widgets/reg_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'anon_page.dart';
import 'change.dart';
import 'enter.dart';
import 'home_page.dart';
import 'widgets/login_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Change.route,
      routes: {
        EnterPage.route: (BuildContext context) => const EnterPage(),
        Change.route: (BuildContext context) => Change(),
        AnonPage.route: (BuildContext context) => AnonPage(),
      },
    ),
  );
}
