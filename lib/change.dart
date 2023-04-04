import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Change extends StatelessWidget {
  const Change({super.key});
  static const String route = "/Change";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton(
            onPressed: () {
              FirebaseAuth.instance.signInAnonymously().then((user) {
                Navigator.of(context, rootNavigator: true)
                    .pushNamed("/Change/Anon");
              }).catchError((e) {
                log(e);
              });
            },
            child: const Text('Войти без авторизации'),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed("/Change/EnterPage");
            },
            child: const Text('Войти с авторизацией'),
          ),
        ],
      ),
    );
  }
}
