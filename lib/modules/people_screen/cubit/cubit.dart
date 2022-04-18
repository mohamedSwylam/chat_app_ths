import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:chat_app_th/modules/people_screen/cubit/states.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
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

import '../../../shared/components/components.dart';
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
  void sendVoiceMessage({
    required String receiverId,
    required String dateTime,
    required String message,
  }) {
    MessageModel model = MessageModel(
      dateTime: dateTime,
      message: chatVoiceUrl,
      type: 'voice',
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
  bool isLoading = false;

  changeBetweenSendAndVoiceIcon(writeText) {
    bool _isEmpty = false;
    writeText.isEmpty ? _isEmpty = true : _isEmpty = false;
    this.writeTextPresent = !_isEmpty;
    emit(ChangeBetweenSendAndVoiceIcon());
  }
  //audio recorder
  /// Audio Player and Dio Downloader Initialized
  final AudioPlayer _justAudioPlayer = AudioPlayer();

  final Record _record = Record();

  /// Some Integer Value Initialized
  late double _currAudioPlayingTime;
  int _lastAudioPlayingIndex = 0;

  double _audioPlayingSpeed = 1.0;

  /// Audio Playing Time Related
  String _totalDuration = '0:00';
  String _loadingTime = '0:00';

  double _chatBoxHeight = 0.0;

  String _hintText = "Type Here...";

  late Directory _audioDirectory;

  /// For Audio Player
  IconData _iconData = Icons.play_arrow_rounded;

  final ScrollController _scrollController = ScrollController(
    initialScrollOffset: 0.0,
  );

  _makeDirectoryForRecordings() async {
    final Directory? directory = await getExternalStorageDirectory();

    _audioDirectory = await Directory(directory!.path + '/Recordings/')
        .create(); // This directory will create Once in whole Application
  }
  takePermissionForStorage() async {
    var status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      {
        // showToast("Thanks For Storage Permission", _fToast,
        //     toastColor: Colors.green, fontSize: 16.0);

        _makeDirectoryForRecordings();
      }
    } else {
      showSnackBar("Some Problem May Be Arrive", context);
    }
  }
  String? chatVoiceUrl;
  void _voiceAndAudioSend(context,String recordedFilePath,
      {String audioExtension = '.mp3',
  required String receiverId,
  required String dateTime,
  required String message,
}) async {
    await SystemChannels.textInput.invokeMethod('TextInput.hide');

    if (_justAudioPlayer.duration != null) {
          _justAudioPlayer.stop();
          _iconData = Icons.play_arrow_rounded;
        emit(JustAudioPlayerState());
    }

    await _justAudioPlayer.setFilePath(recordedFilePath);

    if (_justAudioPlayer.duration!.inMinutes > 20)
    showSnackBar("Audio File Duration Can't be greater than 20 minutes", context);

    else {
   /*     setState(() {
          this._isLoading = true;
        });*/
      final String _messageTime =
          "${DateTime.now().hour}:${DateTime.now().minute}";

      final String? downloadedVoicePath = await service
          .uploadMediaToStorage(File(recordedFilePath),
          reference: 'chatVoices/');

      if (downloadedVoicePath != null) {
        chatVoiceUrl=downloadedVoicePath;
        sendVoiceMessage(receiverId: receiverId, dateTime: dateTime, message: message);}}


    /*      setState(() {
            this._allConversationMessages.add({
              recordedFilePath: _messageTime,
            });
            this._chatMessageCategoryHolder.add(ChatMessageTypes.Audio);
            this._conversationMessageHolder.add(false);
          });

          setState(() {
            _scrollController.jumpTo(
              _scrollController.position.maxScrollExtent +
                  _amountToScroll(ChatMessageTypes.Audio)+30.0,
            );
          });

        await _localDatabase.insertMessageInUserTable(
            userName: widget.userName,
            actualMessage: recordedFilePath.toString(),
            chatMessageTypes: ChatMessageTypes.Audio,
            messageHolderType: MessageHolderType.Me,
            messageDateLocal: DateTime.now().toString().split(" ")[0],
            messageTimeLocal: _messageTime);
      }
       setState(() {
          this._isLoading = false;
        });*/
    }

  void voiceTake(context,{required String receiverId,
    required String dateTime,
    required String message,}) async {
    if (!await Permission.microphone.status.isGranted) {
      final microphoneStatus = await Permission.microphone.request();
      if (microphoneStatus != PermissionStatus.granted)
        showSnackBar("Microphone Permission Required To Record Voice", context);
    } else {
      if (await this._record.isRecording()) {
            _hintText = 'Type Here...';
            emit(ChangeHintTextToTypeHere());
            final String? recordedFilePath = await this._record.stop();
        _voiceAndAudioSend(context,recordedFilePath.toString(),receiverId: receiverId, dateTime: dateTime, message: message);
      } else {
            _hintText = 'Recording....';
            emit(ChangeHintTextToRecording());
            await this._record
            .start(
          path: '${_audioDirectory.path}${DateTime.now()}.aac',

        )

    .then((value) {
      print("Recording");
    });
      }
    }
  }
}