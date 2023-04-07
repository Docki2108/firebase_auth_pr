import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class UploadImagePage extends StatefulWidget {
  const UploadImagePage({super.key});

  @override
  State<UploadImagePage> createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Text('Image Upload')
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_enhance_outlined),
        onPressed: () {},
      ),
    );
  }
}
