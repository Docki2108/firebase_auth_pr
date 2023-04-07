import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class photosss extends StatelessWidget {
  photosss({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: photosssPage(),
    );
  }
}

class photosssPage extends StatefulWidget {
  photosssPage({Key? key}) : super(key: key);

  @override
  State<photosssPage> createState() => _photosssPagePageState();
}

class _photosssPagePageState extends State<photosssPage> {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  bool loading = false;

  Future<void> uploadImage(String inputSource) async {
    final picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
        source:
            inputSource == 'camera' ? ImageSource.camera : ImageSource.gallery);

    if (pickedImage == null) {
      return null;
    }
    String fileName = pickedImage.name;
    File imageFile = File(pickedImage.path);

    try {
      setState(() {
        loading = true;
      });
      await firebaseStorage.ref(fileName).putFile(imageFile);
      setState(() {
        loading = false;
      });
    } on FirebaseException catch (e) {
      print(e);
    } catch (error) {
      print(error);
    }
  }

  Future<List> loadImages() async {
    List<Map> files = [];
    final ListResult result = await firebaseStorage.ref().listAll();
    final List<Reference> allFiles = result.items;

    await Future.forEach(allFiles, (Reference file) async {
      final String fileUrl = await file.getDownloadURL();
      files.add({"url": fileUrl, "path": file.fullPath});
    });

    return files;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        centerTitle: true,
        title: const Text('Photos'),
      ),
      body: Column(
        children: [
          Text('sd'),
          Expanded(
            child: FutureBuilder(
              future: loadImages(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data.length ?? 0,
                  itemBuilder: (context, index) {
                    final Map image = snapshot.data[index];
                    return Row(
                      children: [
                        Expanded(
                            child: Card(
                          child: Container(
                            height: 50,
                            width: 50,
                            child: Image.network(image["url"]),
                          ),
                        )),
                        IconButton(
                            onPressed: () async {
                              await delete(image["path"]);
                            },
                            icon: Icon(Icons.delete))
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_enhance_outlined),
        onPressed: () {
          uploadImage("camera");
        },
      ),
    );
  }

  Future<void> delete(String ref) async {
    await firebaseStorage.ref(ref).delete();
    setState(() {});
  }
}
