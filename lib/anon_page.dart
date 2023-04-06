import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AnonPage extends StatefulWidget {
  AnonPage({super.key});
  static const String route = "/Change/Anon";
  final user = FirebaseAuth.instance.currentUser!;

  @override
  State<AnonPage> createState() => _AnonPageState();
}

class _AnonPageState extends State<AnonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Anon'),
            OutlinedButton(
              onPressed: () {
                signOut();
                Navigator.of(context, rootNavigator: true).pushNamed("/Change");
              },
              child: Text('Выйти'),
            ),
          ],
        ),
      ),
    );
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
