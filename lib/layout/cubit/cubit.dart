import 'package:bloc/bloc.dart';
import 'package:chat_app_th/layout/cubit/states.dart';
import 'package:chat_app_th/modules/calls_screen/calls_screen.dart';
import 'package:chat_app_th/modules/chats_screen/chats_screen.dart';
import 'package:chat_app_th/modules/people_screen/people_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../modules/settings_screen/settings_screen.dart';
import '../../services/firebase_service.dart';

class AppCubit extends Cubit<AppStates>  {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> screens = [
    ChatsScreen(),
    CallsScreen(),
    PeopleScreen(),
    SettingsScreen(),
  ];
  List<String> titles = [
    'Chats',
    'Calls',
    'People',
    'Settings',
  ];

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(ChangeBottomNavState());
  }
}