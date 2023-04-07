import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_pr/photosss.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'cats_page.dart';
import 'photos_page.dart';

class HomePage extends StatelessWidget {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    addUserDataOnReg();
    TextEditingController emailController = TextEditingController();
    TextEditingController ageController = TextEditingController();
    TextEditingController heightController = TextEditingController();
    TextEditingController weightController = TextEditingController();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 200, 20, 20),
              child: Text('Cloud Firestore Data'),
            ),
            Card(
              elevation: 3,
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 200),
              //height: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text('Email: ${user.email!}'),
                    Text('UID: ${user.uid}'),
                    Container(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: ageController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(255, 178, 202, 213),
                        focusColor: Colors.brown,
                        hintText: 'Возраст',
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: heightController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(255, 178, 202, 213),
                        focusColor: Colors.brown,
                        hintText: 'Рост',
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: weightController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(255, 178, 202, 213),
                        focusColor: Colors.brown,
                        hintText: 'Вес',
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        addUserData(
                            ageController, heightController, weightController);
                      },
                      child: const Text('add data'),
                    ),
                    Container(
                      height: 0,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        updateUserData(
                            ageController, heightController, weightController);
                      },
                      child: const Text('update data'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CatsPage(),
                          ),
                        );
                      },
                      child: const Text('Cats page'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => photosssPage(),
                ),
              );
            },
            child: const Text('Photos page'),
          ),
          OutlinedButton(
            onPressed: () {
              signOut();
            },
            child: const Text('exit'),
          ),
        ],
      ),
    );
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future addUserDataOnReg() async {
    final userAuth = FirebaseAuth.instance.currentUser!;
    final users = fireStore.collection('users');
    return users.add({
      'uid': userAuth.uid,
      'email': userAuth.email!,
    });
  }

  Future addUserData(ageController, heightController, weightController) async {
    final userAuth = FirebaseAuth.instance.currentUser!;
    final users = fireStore.collection('users');
    return users.add({
      'uid': userAuth.uid,
      'email': userAuth.email!,
      'age': ageController.text.trim(),
      'height': heightController.text.trim(),
      'weight': weightController.text.trim(),
    });
  }

  Future updateUserData(
      ageController, heightController, weightController) async {
    final userAuth = FirebaseAuth.instance.currentUser!;
    final users = fireStore.collection('users');
    return users.doc('myUser').set(
      {
        'uid': userAuth.uid,
        'email': userAuth.email!,
        'age': ageController.text.trim(),
        'height': heightController.text.trim(),
        'weight': weightController.text.trim(),
      },
    );
  }
}
