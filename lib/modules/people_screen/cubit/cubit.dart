import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat_app_th/modules/people_screen/cubit/states.dart';
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

class PeopleCubit extends Cubit<PeopleStates> {
  PeopleCubit() : super(PeopleInitialState());

  static PeopleCubit get(context) => BlocProvider.of(context);
  FirebaseService service = FirebaseService();
  QuerySnapshot? snapshot;
  UserModel? userModel;
  getuserList(){
    return service.users.
    get().then ((QuerySnapshot querySnapshot) {
      snapshot=querySnapshot;
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
      text: text,
      receiverId: receiverId,
      senderID: service.user!.uid,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uid)
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
        .doc(userModel!.uid)
        .collection('messages')
        .add(model.toJson())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState(error.toString()));
    });
  }

  getChatsList(){
    return service.users.
    get().then ((QuerySnapshot querySnapshot) {
      snapshot=querySnapshot;
      emit(GetChatsListState());
    });
  }
}
