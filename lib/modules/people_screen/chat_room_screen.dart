import 'package:chat_app_th/modules/people_screen/cubit/cubit.dart';
import 'package:chat_app_th/widget/chats_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/message_model.dart';
import '../../models/user_model.dart';
import '../../shared/styles/color.dart';
import '../../shared/styles/icon_broken.dart';
import 'cubit/states.dart';

class ChatRoomScreen extends StatelessWidget {
  var userModel;

  ChatRoomScreen({required this.userModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PeopleCubit, PeopleStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = PeopleCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            titleSpacing: 0.0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 15,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage('${userModel['userImage']}'),
                ),
                SizedBox(
                  width: 15,
                ),
                Row(
                  children: [
                    Text('${userModel['firstName']}'),
                    SizedBox(
                      width: 5,
                    ),
                    Text('${userModel['lastName']}'),
                  ],
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Expanded(
                  child: ChatsList(receiverId: userModel['uid']),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 20 / 2,
                  ),
                  decoration: BoxDecoration(
                    color: Theme
                        .of(context)
                        .scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 32,
                        color: Color(0xFF087949).withOpacity(0.08),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              color: defaultColor.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.sentiment_satisfied_alt_outlined,
                                  color: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color!
                                      .withOpacity(0.64),
                                ),
                                SizedBox(width: 20 / 4),
                                Expanded(
                                  child: TextFormField(
                                    controller: cubit.messageController,
                                    onChanged: (value) {
                                      cubit.changeBetweenSendAndVoiceIcon(
                                          value);
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Type message ...',
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                 cubit.showDifferentChatOptions(context);
                                  },
                                  icon: Icon(
                                    Icons.attach_file,
                                    color: Theme
                                        .of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color!
                                        .withOpacity(0.64),
                                  ),
                                ),

                                SizedBox(width: 20 / 4),
                                IconButton(
                                  onPressed: () {
                                    cubit.pickChatImage(
                                      receiverId: userModel['uid'],
                                      dateTime: DateTime.now().toString(),
                                      message: '',
                                    );
                                    cubit.scrollController.animateTo(
                                        cubit.scrollController.position
                                            .maxScrollExtent,
                                        duration: Duration(milliseconds: 50),
                                        curve: Curves.easeIn);
                                  },
                                  icon: Icon(
                                    Icons.camera_alt_outlined,
                                    color: Theme
                                        .of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color!
                                        .withOpacity(0.64),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        cubit.writeTextPresent ?
                        IconButton(
                          onPressed: () {
                            cubit.sendMessage(
                              receiverId: userModel['uid'],
                              dateTime: DateTime.now().toString(),
                              text: cubit.messageController.text,
                            );
                            cubit.messageController.clear();
                            cubit.scrollController.animateTo(
                                cubit.scrollController.position.maxScrollExtent,
                                duration: Duration(milliseconds: 50),
                                curve: Curves.easeIn);
                          },
                          icon: Icon(Icons.send, color: defaultColor),
                        ): IconButton(
                          onPressed: () {
                            cubit.voiceTake(context,
                              receiverId: userModel['uid'],
                              dateTime: DateTime.now().toString(),
                              message: '',
                            );
                          },
                          icon: Icon(Icons.mic, color: defaultColor),
                        ),
                      ],
                    ),
                  ),
                ),
                /*Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: TextFormField(
                            controller: messageController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'type your message here ...',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 50.0,
                        color: defaultColor,
                        child: MaterialButton(
                          minWidth: 1.0,
                          onPressed: () {
                            cubit.sendMessage(
                              receiverId: userModel['uid'],
                              dateTime: DateTime.now().toString(),
                              text: messageController.text,
                            );
                            messageController.clear();
                            cubit.scrollController.animateTo(
                                cubit.scrollController.position.maxScrollExtent,
                                duration: Duration(milliseconds: 50),
                                curve: Curves.easeIn);
                          },
                          child: Icon(
                            IconBroken.Send,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),*/
              ],
            ),
          ),
        );
      },
    );
  }
}
