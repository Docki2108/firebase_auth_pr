import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(user.email!),
            OutlinedButton(
              onPressed: () {
                signOut();
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
