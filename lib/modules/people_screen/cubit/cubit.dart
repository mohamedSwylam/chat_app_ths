import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat_app_th/modules/people_screen/cubit/states.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../layout/cubit/cubit.dart';
import '../../../models/message_model.dart';
import '../../../models/user_model.dart';
import '../../../services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mime_type/mime_type.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
class PeopleCubit extends Cubit<PeopleStates> {
  PeopleCubit() : super(PeopleInitialState());

  static PeopleCubit get(context) => BlocProvider.of(context);
  FirebaseService service = FirebaseService();
  QuerySnapshot? snapshot;
  UserModel? userModel;

  getuserList() {
    return service.users.
    get().then((QuerySnapshot querySnapshot) {
      snapshot = querySnapshot;
      emit(GetUsersListState());
    });
  }

  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
  }) {
    MessageModel model = MessageModel(
      dateTime: dateTime,
      message: text,
      type: 'text',
      receiverId: receiverId,
      senderID: service.user!.uid,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(service.user!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toJson())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState(error.toString()));
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(service.user!.uid)
        .collection('messages')
        .add(model.toJson())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState(error.toString()));
    });
  }

  getChatsList() {
    return service.users.
    get().then((QuerySnapshot querySnapshot) {
      snapshot = querySnapshot;
      emit(GetChatsListState());
    });
  }

  final scrollController = ScrollController();
  var messageController = TextEditingController();

  IconData changeSendIcon() {
    if (messageController.text.isEmpty) {
      return Icons.mic;
    } else {
      return Icons.send;
    }
  }

  //chat image
  final ImagePicker picker = ImagePicker();
  XFile? chatImage;
  String? chatImageUrl;

  Future<XFile?> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  pickChatImage({
    required String receiverId,
    required String dateTime,
    required String message,
  }) async {
    pickImage().then((value) {
      chatImage = value;
      uploadChatImage(message: message,dateTime: dateTime,receiverId: receiverId);
      emit(PickChatImageSuccessState());
    }).catchError((error) {
      emit(PickChatImageErrorState(error.toString()));
    });
  }
   Future<void>uploadChatImage({
     required String receiverId,
     required String dateTime,
     required String message,
   }) async {
    File _file = File(chatImage!.path);
    String fileName = Uuid().v1();
    firebase_storage.Reference ref = FirebaseStorage.instance.ref()
        .child('images').child('$fileName.jpg');
    await ref.putFile(_file);
    String downloadURL = await ref.getDownloadURL();
    if (downloadURL != null) {
      chatImageUrl = downloadURL;
      sendImageMessage(receiverId: receiverId,dateTime: dateTime,message: message);
      emit(UploadChatImageSuccessState());
    }
  }
  void sendImageMessage({
    required String receiverId,
    required String dateTime,
    required String message,
  }) {
        MessageModel model = MessageModel(
          dateTime: dateTime,
          message: chatImageUrl,
          type: 'img',
          receiverId: receiverId,
          senderID: service.user!.uid,
        );
        FirebaseFirestore.instance
            .collection('users')
            .doc(service.user!.uid)
            .collection('chats')
            .doc(receiverId)
            .collection('messages')
            .add(model.toJson())
            .then((value) {
          emit(SocialSendMessageSuccessState());
        }).catchError((error) {
          emit(SocialSendMessageErrorState(error.toString()));
        });
        FirebaseFirestore.instance
            .collection('users')
            .doc(receiverId)
            .collection('chats')
            .doc(service.user!.uid)
            .collection('messages')
            .add(model.toJson())
            .then((value) {
          emit(SocialSendMessageSuccessState());
        }).catchError((error) {
          emit(SocialSendMessageErrorState(error.toString()));
        });
  }
  bool writeTextPresent = false;
  changeBetweenSendAndVoiceIcon(writeText) {
    bool _isEmpty = false;
    writeText.isEmpty ? _isEmpty = true : _isEmpty = false;
    this.writeTextPresent = !_isEmpty;
    emit(ChangeBetweenSendAndVoiceIcon());
  }
}