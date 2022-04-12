import 'package:chat_app_th/modules/people_screen/cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/message_model.dart';
import '../../models/user_model.dart';
import '../../shared/styles/color.dart';
import '../../shared/styles/icon_broken.dart';
import 'cubit/states.dart';

class ChatRoomScreen extends StatelessWidget {
  UserModel userModel;

   ChatRoomScreen({required this.userModel, Key? key})
      : super(key: key);

  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
         var cubit= PeopleCubit.get(context);
        //SocialCubit.get(context).getMessages(receiverId: userModel.uid);
        return BlocConsumer<PeopleCubit, PeopleStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage('${userModel.image}'),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text('${userModel.firstName}'),
                  ],
                ),
              ),
              body:  Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(itemBuilder: (context, index) {
                       // var message = SocialCubit.get(context).messages[index];
                      //  if(SocialCubit.get(context).userModel.uId == message.senderID)
                          return buildMyMessageItem();
                        return buildMessageItem();
                      },
                        separatorBuilder: (context, index) =>SizedBox(height: 15,),
                        itemCount: 10,
                        physics: BouncingScrollPhysics(),
                      ),
                    ),
                    Container(
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0),
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
                             /*   SocialCubit.get(context).sendMessage(
                                  receiverId: userModel.uId,
                                  dateTime: DateTime.now().toString(),
                                  text: messageController.text,
                                );*/
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
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMessageItem() =>
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          child: Text('Hello y ebn steen wes5a'),
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(10.0),
              topStart: Radius.circular(10.0),
              topEnd: Radius.circular(10.0),
            ),
            color: Colors.grey[300],
          ),
        ),
      );

  Widget buildMyMessageItem() =>
      Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          child: Text('Hello y ebn wes5a'),
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.only(
              bottomStart: Radius.circular(10.0),
              topStart: Radius.circular(10.0),
              topEnd: Radius.circular(10.0),
            ),
            color: defaultColor.withOpacity(.2),
          ),
        ),
      );
}