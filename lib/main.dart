import 'package:bloc/bloc.dart';
import 'package:chat_app_th/modules/calls_screen/calls_screen.dart';
import 'package:chat_app_th/modules/calls_screen/cubit/cubit.dart';
import 'package:chat_app_th/modules/chats_screen/chats_screen.dart';
import 'package:chat_app_th/modules/chats_screen/cubit/cubit.dart';
import 'package:chat_app_th/modules/people_screen/cubit/cubit.dart';
import 'package:chat_app_th/modules/people_screen/people_screen.dart';
import 'package:chat_app_th/modules/settings_screen/cubit/cubit.dart';
import 'package:chat_app_th/modules/settings_screen/settings_screen.dart';
import 'package:chat_app_th/shared/bloc_observer.dart';
import 'package:chat_app_th/shared/network/local/cache_helper.dart';
import 'package:chat_app_th/shared/styles/color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'layout/app_layout.dart';
import 'layout/cubit/cubit.dart';
import 'layout/cubit/states.dart';
import 'package:sizer/sizer.dart';
import 'modules/Login/cubit/cubit.dart';
import 'modules/Login/login_screen.dart';
import 'modules/register/cubit/cubit.dart';
import 'modules/register/register_screen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => AppCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => CallsCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => ChatsCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => PeopleCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => SettingsCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => RegisterCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => LoginCubit(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Sizer(builder: (context, orientation, deviceType) {
            return MaterialApp(
              title: 'Chat App',
              debugShowCheckedModeBanner: false,
              builder: EasyLoading.init(),
              theme: ThemeData(
                fontFamily: 'Lato',
                primaryColor: defaultColor,
                primarySwatch: defaultColor,
              ),
              routes: {
                AppLayout.id: (context) => AppLayout(),
                CallsScreen.id: (context) => CallsScreen(),
                ChatsScreen.id: (context) => ChatsScreen(),
                PeopleScreen.id: (context) => PeopleScreen(),
                LoginScreen.id: (context) => LoginScreen(),
                RegisterScreen.id: (context) => RegisterScreen(),
                SettingsScreen.id: (context) => SettingsScreen(),
              },
              initialRoute: RegisterScreen.id,
            );
          });
        },
      ),
    );
  }
}
