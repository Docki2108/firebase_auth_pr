import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class cats_page extends StatelessWidget {
  cats_page({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: CatsPage(),
    );
  }
}

class CatsPage extends StatefulWidget {
  CatsPage({Key? key}) : super(key: key);

  @override
  State<CatsPage> createState() => _CatsPagePageState();
}

class _CatsPagePageState extends State<CatsPage> {
  TextEditingController catsNameController = TextEditingController();
  TextEditingController catsAgeController = TextEditingController();
  TextEditingController catsColorController = TextEditingController();

  TextEditingController catsNameController2 = TextEditingController();
  TextEditingController catsAgeController2 = TextEditingController();
  TextEditingController catsColorController2 = TextEditingController();

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;

  final CollectionReference catsCollection =
      FirebaseFirestore.instance.collection("cats");

  //
  Future<void> updateCat([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      catsNameController2.text = documentSnapshot['name'];
      catsAgeController2.text = documentSnapshot['age'];
      catsColorController2.text = documentSnapshot['color'];
    }
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext qwe) {
        return Padding(
          padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(qwe).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: catsNameController2,
                decoration: const InputDecoration(labelText: 'name'),
              ),
              TextFormField(
                controller: catsAgeController2,
                decoration: const InputDecoration(labelText: 'age'),
              ),
              TextFormField(
                controller: catsColorController2,
                decoration: const InputDecoration(labelText: 'color'),
              ),
              OutlinedButton(
                onPressed: () async {
                  final String name = catsNameController2.text;
                  final String age = catsAgeController2.text;
                  final String color = catsColorController2.text;

                  await catsCollection
                      .doc(documentSnapshot!.id)
                      .update({"name": name, "age": age, "color": color});
                },
                child: Text('update'),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        centerTitle: true,
        title: const Text('Cats'),
      ),
      body: StreamBuilder(
        stream: catsCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(documentSnapshot['name']),
                      subtitle: Column(
                        children: [
                          Row(
                            children: [
                              Text('AGE: ' + documentSnapshot['age'] + ' '),
                            ],
                          ),
                          Row(
                            children: [
                              Text('COLOR: ' + documentSnapshot['color'] + ' '),
                            ],
                          ),
                          Row(
                            children: [
                              Text('OWNER: ' + documentSnapshot['owner'] + ' '),
                            ],
                          )
                        ],
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                deleteCat(documentSnapshot.id);
                              },
                              icon: Icon(Icons.delete_outline_outlined),
                            ),
                            IconButton(
                              onPressed: () {
                                updateCat(documentSnapshot);
                              },
                              icon: Icon(Icons.mode_edit_outline_outlined),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.exposure_plus_1),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                'Cat Add',
              ),
              content: Column(
                children: [
                  TextFormField(
                    controller: catsNameController,
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
                      hintText: 'Имя кошачего',
                    ),
                  ),
                  Container(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: catsAgeController,
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
                    controller: catsColorController,
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
                      hintText: 'Цвет',
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                OutlinedButton(
                  onPressed: () async {
                    addCatsData(catsAgeController, catsNameController,
                        catsColorController);
                  },
                  child: const Text(
                    'Add',
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: const Text(
                    'Go back',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> deleteCat(String id) async {
    await catsCollection.doc(id).delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('deleted'),
      ),
    );
  }

  Future addCatsData(
      catsAgeController, catsNameController, catsColorController) async {
    final userAuth = FirebaseAuth.instance.currentUser!;
    final cats = fireStore.collection('cats');
    return cats.add({
      'age': catsAgeController.text.trim(),
      'name': catsNameController.text.trim(),
      'color': catsColorController.text.trim(),
      'owner': userAuth.email!,
      // 'phone': userAuth.phoneNumber!,
    });
  }

  Future updateCatsData(
      catsAgeController, catsNameController, catsColorController) async {
    final userAuth = FirebaseAuth.instance.currentUser!;
    final cats = fireStore.collection('cats');
    return cats.doc('updatedCat').set({
      'age': catsAgeController.text.trim(),
      'name': catsNameController.text.trim(),
      'color': catsColorController.text.trim(),
      'owner': userAuth.email!,
    });
  }
}
