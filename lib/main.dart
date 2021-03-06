import 'package:bloc/bloc.dart';
import 'package:chat_app_th/modules/calls_screen/calls_screen.dart';
import 'package:chat_app_th/modules/calls_screen/cubit/cubit.dart';
import 'package:chat_app_th/modules/chats_screen/chats_screen.dart';
import 'package:chat_app_th/modules/chats_screen/cubit/cubit.dart';
import 'package:chat_app_th/modules/people_screen/cubit/cubit.dart';
import 'package:chat_app_th/modules/people_screen/people_screen.dart';
import 'package:chat_app_th/modules/settings_screen/cubit/cubit.dart';
import 'package:chat_app_th/modules/settings_screen/settings_screen.dart';
import 'package:chat_app_th/services/notification/foreground_receive_notificaion_management.dart';
import 'package:chat_app_th/shared/bloc_observer.dart';
import 'package:chat_app_th/shared/components/constants.dart';
import 'package:chat_app_th/shared/network/local/cache_helper.dart';
import 'package:chat_app_th/shared/styles/color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  Widget widget;
  uId = CacheHelper.getData(key: 'uId');
  if(uId != null){
    widget = AppLayout();
  }else{
    widget=LoginScreen();
  }
  /// Initialize Notification Settings
  await notificationInitialize();

  /// For Background Message Handling
  FirebaseMessaging.onBackgroundMessage(backgroundMsgAction);

  /// For Foreground Message Handling
  FirebaseMessaging.onMessage.listen((messageEvent) {
    print(
        "Message Data is: ${messageEvent.notification!.title}     ${messageEvent.notification!.body}");

    _receiveAndShowNotificationInitialization(
        title: messageEvent.notification!.title.toString(),
        body: messageEvent.notification!.body.toString());
  });
  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget? startWidget;

  MyApp({this.startWidget});
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
          create: (BuildContext context) => PeopleCubit()..getuserList(),
        ),
        BlocProvider(
          create: (BuildContext context) => SettingsCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => RegisterCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => SocialLoginCubit(),
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
                RegisterrScreen.id: (context) => RegisterrScreen(),
                SettingsScreen.id: (context) => SettingsScreen(),
              },
              initialRoute: LoginScreen.id,
            );
          });
        },
      ),
    );
  }
}
Future<void> notificationInitialize() async {
  /// Subscribe to a topic
  await FirebaseMessaging.instance.subscribeToTopic("Generation_YT");

  /// Foreground Notification Options Enabled
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

/// Receive And show Notification Customization
void _receiveAndShowNotificationInitialization(
    {required String title, required String body}) async {
  final ForegroundNotificationManagement _fgNotifyManagement =
  ForegroundNotificationManagement();

  print("Notification Activated");

  await _fgNotifyManagement.showNotification(title: title, body: body);
}

Future<void> backgroundMsgAction(RemoteMessage message) async {
  await Firebase.initializeApp();

  _receiveAndShowNotificationInitialization(
      title: message.notification!.title.toString(),
      body: message.notification!.body.toString());
}