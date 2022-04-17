import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseService {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  User? user = FirebaseAuth.instance.currentUser;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String> uploadImage(XFile? file, String? reference) async {
    File _file = File(file!.path);
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref(reference);
    await ref.putFile(_file);
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }


  Future<void> addUser({Map<String, dynamic>? data}) {
    return users
        .doc(user!.uid)
        .set(data)
        .then((value) => print("User Register Successfully"))
        .catchError((error) => print("Failed to Register User: $error"));
  }


  Future uploadFile({File? image, String? reference,}) async {
    firebase_storage.Reference storageReference = storage.ref().child(
        '$reference/${DateTime
            .now()
            .microsecondsSinceEpoch}');
    firebase_storage.UploadTask uploadTask = storageReference.putFile(image!);
    await uploadTask;
    return storageReference.getDownloadURL();
  }
  Future<String?> uploadMediaToStorage(File filePath,
      {required String reference}) async {
    try {
      String? downLoadUrl;

      final String fileName =
          '${FirebaseAuth.instance.currentUser!.uid}${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}${DateTime.now().millisecond}';

      final Reference firebaseStorageRef =
      FirebaseStorage.instance.ref(reference).child(fileName);

      print('Firebase Storage Reference: $firebaseStorageRef');

      final UploadTask uploadTask = firebaseStorageRef.putFile(filePath);

      await uploadTask.whenComplete(() async {
        print("Media Uploaded");
        downLoadUrl = await firebaseStorageRef.getDownloadURL();
        print("Download Url: $downLoadUrl}");
      });

      return downLoadUrl!;
    } catch (e) {
      print("Error: Firebase Storage Exception is: ${e.toString()}");
      return null;
    }
  }
}
