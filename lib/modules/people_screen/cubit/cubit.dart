import 'dart:io';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
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
import 'package:circle_list/circle_list.dart';
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
    return service.users.get().then((QuerySnapshot querySnapshot) {
      snapshot = querySnapshot;
      emit(GetUsersListState());
    });
  }

  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String message,
    required String type,
  }) {
    MessageModel model = MessageModel(
      dateTime: dateTime,
      message: message,
      type: type,
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
    return service.users.get().then((QuerySnapshot querySnapshot) {
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
      uploadChatImage(
          message: message, dateTime: dateTime, receiverId: receiverId);
      emit(PickChatImageSuccessState());
    }).catchError((error) {
      emit(PickChatImageErrorState(error.toString()));
    });
  }

  Future<void> uploadChatImage({
    required String receiverId,
    required String dateTime,
    required String message,
  }) async {
    File _file = File(chatImage!.path);
    String fileName = Uuid().v1();
    firebase_storage.Reference ref =
        FirebaseStorage.instance.ref().child('images').child('$fileName.jpg');
    await ref.putFile(_file);
    String downloadURL = await ref.getDownloadURL();
    if (downloadURL != null) {
      chatImageUrl = downloadURL;
      sendImageMessage(
          receiverId: receiverId, dateTime: dateTime, message: message);
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
  final AudioPlayer justAudioPlayer = AudioPlayer();

  final Record record = Record();

  /// Some Integer Value Initialized
  late double currAudioPlayingTime;
  int lastAudioPlayingIndex = 0;

  double audioPlayingSpeed = 1.0;

  /// Audio Playing Time Related
  String totalDuration = '0:00';
  String loadingTime = '0:00';

  double chatBoxHeight = 0.0;

  String hintText = "Type Here...";

  late Directory _audioDirectory;

  /// For Audio Player
  IconData iconData = Icons.play_arrow_rounded;

  final ScrollController _crollController = ScrollController(
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

  void _voiceAndAudioSend(
    context,
    String recordedFilePath, {
    String audioExtension = '.mp3',
    required String receiverId,
    required String dateTime,
    required String message,
  }) async {
    final String? downloadedVoicePath = await service.uploadMediaToStorage(
        File(recordedFilePath),
        reference: 'chatVoices/');

    if (downloadedVoicePath != null) {
      sendMessage(
          receiverId: receiverId, dateTime: dateTime, message: downloadedVoicePath,type:'audio');
    }
  }
/*  void chatMicrophoneOnTapAction(int index,data) async {
    try {
      justAudioPlayer.positionStream.listen((event) {
            currAudioPlayingTime = event.inMicroseconds.ceilToDouble();
            loadingTime =
            '${event.inMinutes} : ${event.inSeconds > 59 ? event.inSeconds % 60 : event.inSeconds}';
            emit(JustAudioPlayerPositionState());
      });

      justAudioPlayer.playerStateStream.listen((event) {
        if (event.processingState == ProcessingState.completed) {
          justAudioPlayer.stop();
              this.loadingTime = '0:00';
              this.iconData = Icons.play_arrow_rounded;
          emit(JustAudioPlayerStopState());
        }
      });

      if (lastAudioPlayingIndex != index) {
        await justAudioPlayer
            .setFilePath(data);
            lastAudioPlayingIndex = index;
            totalDuration =
            '${justAudioPlayer.duration!.inMinutes} : ${justAudioPlayer.duration!.inSeconds > 59 ? justAudioPlayer.duration!.inSeconds % 60 : justAudioPlayer.duration!.inSeconds}';
            iconData = Icons.pause;
            this.audioPlayingSpeed = 1.0;
            justAudioPlayer.setSpeed(this.audioPlayingSpeed);
        emit(JustAudioPlayerSpeedState());
        await justAudioPlayer.play();
      } else {
        print(justAudioPlayer.processingState);
        if (justAudioPlayer.processingState == ProcessingState.idle) {
          await justAudioPlayer
              .setFilePath(data);
              lastAudioPlayingIndex = index;
              totalDuration =
              '${justAudioPlayer.duration!.inMinutes} : ${justAudioPlayer.duration!.inSeconds}';
              iconData = Icons.pause;
          emit(JustAudioPlayerStopState());

          await justAudioPlayer.play();
        } else if (justAudioPlayer.playing) {
              iconData = Icons.play_arrow_rounded;
              emit(ChangeIconDataToPlayState());

          await justAudioPlayer.pause();
        } else if (justAudioPlayer.processingState == ProcessingState.ready) {
              iconData = Icons.pause;
              emit(ChangeIconDataToPauseState());

          await justAudioPlayer.play();
        } else if (justAudioPlayer.processingState ==
            ProcessingState.completed) {}
      }
    } catch (e) {
      print('Audio Playing Error');
      //showSnackBar('May be Audio File Not Found',context);
    }
  }*/

/*  void _chatMicrophoneOnLongPressAction() async {
    if (_justAudioPlayer.playing) {
      await _justAudioPlayer.stop();

      if (mounted) {
        setState(() {
          print('Audio Play Completed');
          _justAudioPlayer.stop();
          if (mounted) {
            setState(() {
              _loadingTime = '0:00';
              _iconData = Icons.play_arrow_rounded;
              _lastAudioPlayingIndex = -1;
            });
          }
        });
      }
    }
  }*/
  void voiceTake(
    context, {
    required String receiverId,
    required String dateTime,
    required String message,
  }) async {
    if (!await Permission.microphone.status.isGranted) {
      final microphoneStatus = await Permission.microphone.request();
      if (microphoneStatus != PermissionStatus.granted)
        showSnackBar("Microphone Permission Required To Record Voice", context);
    } else {
      if (await this.record.isRecording()) {
        hintText = 'Type Here...';
        emit(ChangeHintTextToTypeHere());
        final String? recordedFilePath = await this.record.stop();
        _voiceAndAudioSend(context, recordedFilePath.toString(),
            receiverId: receiverId, dateTime: dateTime, message: message);
      } else {
        hintText = 'Recording....';
        emit(ChangeHintTextToRecording());
        await this
            .record
            .start(
              path: '${_audioDirectory.path}${DateTime.now()}.aac',
            )
            .then((value) {
          print("Recording");
        });
      }
    }
  }

  void showDifferentChatOptions(context,{
    required String receiverId,
    required String dateTime,
    required String message,
  }) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              elevation: 0.3,
              backgroundColor: Color.fromRGBO(34, 48, 60, 0.5),
              content: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.7,
                child: Center(
                  child: CircleList(
                    initialAngle: 55,
                    outerRadius: MediaQuery.of(context).size.width / 3.2,
                    innerRadius: MediaQuery.of(context).size.width / 10,
                    showInitialAnimation: true,
                    innerCircleColor: Color.fromRGBO(34, 48, 60, 1),
                    outerCircleColor: Color.fromRGBO(0, 0, 0, 0.1),
                    origin: Offset(0, 0),
                    rotateMode: RotateMode.allRotate,
                    centerWidget: Center(
                      child: Text(
                        "G",
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 45.0,
                        ),
                      ),
                    ),
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: Colors.blue,
                              width: 3,
                            )),
                        child: GestureDetector(
                          onTap: () async {},
                          onLongPress: () async {},
                          child: Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.lightGreen,
                          ),
                        ),
                      ),
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: Colors.blue,
                              width: 3,
                            )),
                        child: GestureDetector(
                          onTap: () async {
                            /*      if (mounted) {
                          setState(() {
                            this._isLoading = true;
                          });
                        }

                        final pickedVideo = await ImagePicker().pickVideo(
                            source: ImageSource.camera,
                            maxDuration: Duration(seconds: 15));

                        if (pickedVideo != null) {
                          final String thumbnailPathTake =
                          await _nativeCallback.getTheVideoThumbnail(
                              videoPath: pickedVideo.path);

                          _addSelectedMediaToChat(pickedVideo.path,
                              chatMessageTypeTake: ChatMessageTypes.Video,
                              thumbnailPath: thumbnailPathTake);
                        }

                        if (mounted) {
                          setState(() {
                            this._isLoading = false;
                          });
                        }*/
                          },
                          onLongPress: () async {
                            /*       if (mounted) {
                          setState(() {
                            this._isLoading = true;
                          });
                        }

                        final pickedVideo = await ImagePicker().pickVideo(
                            source: ImageSource.gallery,
                            maxDuration: Duration(seconds: 15));

                        if (pickedVideo != null) {
                          final String thumbnailPathTake =
                          await _nativeCallback.getTheVideoThumbnail(
                              videoPath: pickedVideo.path);

                          _addSelectedMediaToChat(pickedVideo.path,
                              chatMessageTypeTake: ChatMessageTypes.Video,
                              thumbnailPath: thumbnailPathTake);
                        }

                        if (mounted) {
                          setState(() {
                            this._isLoading = false;
                          });
                        }*/
                          },
                          child: Icon(
                            Icons.video_collection,
                            color: Colors.lightGreen,
                          ),
                        ),
                      ),
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: Colors.blue,
                              width: 3,
                            )),
                        child: GestureDetector(
                          onTap: () async {
                            pickFileFromStorage(context,receiverId: receiverId,dateTime: dateTime,message: message);
                          },
                          child: Icon(
                            Icons.document_scanner_outlined,
                            color: Colors.lightGreen,
                          ),
                        ),
                      ),
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: Colors.blue,
                              width: 3,
                            )),
                        child: GestureDetector(
                          onTap: () async {
                            /*                final PermissionStatus locationPermissionStatus =
                        await Permission.location.request();
                        if (locationPermissionStatus ==
                            PermissionStatus.granted) {
                          await _takeLocationInput();
                        } else {
                          showToast(
                              "Location Permission Required", this._fToast);
                        }*/
                          },
                          child: Icon(
                            Icons.location_on_rounded,
                            color: Colors.lightGreen,
                          ),
                        ),
                      ),
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: Colors.blue,
                              width: 3,
                            )),
                        child: GestureDetector(
                          child: Icon(
                            Icons.music_note_rounded,
                            color: Colors.lightGreen,
                          ),
                          onTap: () async {
                            pickAudioFromStorage(context,receiverId: receiverId,dateTime: dateTime,message: message);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  // document sent

  Future<void> pickFileFromStorage(context,{
    required String receiverId,
    required String dateTime,
    required String message,
  }) async {
    List<String> _allowedExtensions = [
      'pdf',
      'doc',
      'docx',
      'ppt',
      'pptx',
      'c',
      'cpp',
      'py',
      'text'
    ];
    try {
      if (!await Permission.storage.isGranted) takePermissionForStorage();

      final FilePickerResult? filePickerResult =
          await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: _allowedExtensions,
      );

      if (filePickerResult != null && filePickerResult.files.length > 0) {
        Navigator.pop(context);

        filePickerResult.files.forEach((file) async {
          print(file.path);

          if (_allowedExtensions.contains(file.extension)) {
            /*   if (mounted) {
              setState(() {
                this._isLoading = true;
              });
            }*/

            final String _messageTime =
                "${DateTime.now().hour}:${DateTime.now().minute}";

            final String? downloadedDocumentPath = await service
                .uploadMediaToStorage(File(File(file.path.toString()).path),
                    reference: 'chatDocuments/');

            if (downloadedDocumentPath != null) {
              sendMessage(
                  receiverId: receiverId, dateTime: dateTime, message: downloadedDocumentPath,type:'document');
            }
          }

          /*           await _cloudStoreDataManagement.sendMessageToConnection(
                  chatMessageTypes: ChatMessageTypes.Document,
                  connectionUserName: widget.userName,
                  sendMessageData: {
                    ChatMessageTypes.Document.toString(): {
                      "${downloadedDocumentPath.toString()}+.${file.extension}":
                      _messageTime
                    }
                  });

              if (mounted) {
                setState(() {
                  this._allConversationMessages.add({
                    File(file.path.toString()).path: _messageTime,
                  });

                  this
                      ._chatMessageCategoryHolder
                      .add(ChatMessageTypes.Document);
                  this._conversationMessageHolder.add(false);
                });
              }

              if (mounted) {
                setState(() {
                  _scrollController.jumpTo(
                    _scrollController.position.maxScrollExtent +
                        _amountToScroll(ChatMessageTypes.Document),
                  );
                });
              }

              await _localDatabase.insertMessageInUserTable(
                  userName: widget.userName,
                  actualMessage: File(file.path.toString()).path.toString(),
                  chatMessageTypes: ChatMessageTypes.Document,
                  messageHolderType: MessageHolderType.Me,
                  messageDateLocal: DateTime.now().toString().split(" ")[0],
                  messageTimeLocal: _messageTime);
            }

            if (mounted) {
              setState(() {
                this._isLoading = false;
              });
            }*/
          else {
            showSnackBar(
              context,
              'Not Supporting Document Format',
            );
          }
        });
      }
    } catch (e) {
      showSnackBar(
        context,
        'Some Error Happened',
      );
    }
  }

  void openFileResultStatus(context,{required OpenResult openResult}) {
    if (openResult.type == ResultType.permissionDenied)
      showSnackBar('Permission Denied to Open File', context);
    else if (openResult.type == ResultType.noAppToOpen)
      showSnackBar('No App Found to Open', context);
    else if (openResult.type == ResultType.error)
      showSnackBar('Error in Opening File', context);
    else if (openResult.type == ResultType.fileNotFound)
      showSnackBar('Sorry, File Not Found', context);
  }
  //send audio

  Future<void> pickAudioFromStorage(context,{
    required String receiverId,
    required String dateTime,
    required String message,
  }) async {
    final List<String> _allowedExtensions = const [
      'mp3',
      'm4a',
      'wav',
      'ogg',
    ];
    final FilePickerResult? _audioFilePickerResult =
    await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    Navigator.pop(context);

    if (_audioFilePickerResult != null) {
      _audioFilePickerResult.files.forEach((element) {
        print('Name: ${element.path}');
        print('Extension: ${element.extension}');
        if (_allowedExtensions
            .contains(element.extension)) {
          _voiceAndAudioSend(context,element.path.toString(),audioExtension: '.${element.extension}',receiverId: receiverId,dateTime: dateTime,message: message
              );
        } else {
          _voiceAndAudioSend(context,element.path.toString(),message: message,dateTime: dateTime,receiverId: receiverId,);
        }
      });
    }
  }
  //audio test

}
