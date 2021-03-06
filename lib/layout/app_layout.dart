import 'package:chat_app_th/shared/styles/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import '../shared/styles/icon_broken.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class AppLayout extends StatefulWidget {
  static String id='AppLayout';
  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex]),
            elevation: 0.0,
            actions: [
              IconButton(onPressed: (){}, icon: Icon(IconBroken.Notification),),
              IconButton(onPressed: (){}, icon: Icon(IconBroken.Search),),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottomNav(index);
            },
            items: [
              BottomNavigationBarItem(icon: Icon(IconBroken.Chat,),label: 'Chats',backgroundColor:defaultColor),
              BottomNavigationBarItem(icon: Icon(IconBroken.Call),label: 'Calls',backgroundColor:defaultColor),
              BottomNavigationBarItem(icon: Icon(IconBroken.User),label: 'People',backgroundColor:defaultColor),
              BottomNavigationBarItem(icon: Icon(IconBroken.Setting),label: 'Settings',backgroundColor:defaultColor),
            ],
          ),
        );
      },
    );
  }
}
