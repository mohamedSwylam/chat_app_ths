import 'dart:io';
import 'package:chat_app_th/modules/people_screen/cubit/cubit.dart';
import 'package:chat_app_th/shared/styles/icon_broken.dart';
import 'package:chat_app_th/widget/image_message.dart';
import 'package:chat_app_th/widget/text_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:record/record.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../models/user_model.dart';
import '../modules/people_screen/chat_room_screen.dart';
import '../services/firebase_service.dart';
import '../shared/components/components.dart';
import '../shared/styles/color.dart';

class ChatsList extends StatelessWidget {
  final String receiverId;

   ChatsList({Key? key, required this.receiverId,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseService service = FirebaseService();
    var cubit = PeopleCubit.get(context);
    return Column(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: service.users
              .doc(service.user!.uid)
              .collection('chats')
              .doc(receiverId)
              .collection('messages')
              .orderBy('dateTime', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.data!.size == 0) {
              return Text("No Chats yet");
            }
            return Expanded(
              child: ListView.builder(
                reverse: true,
                controller: cubit.scrollController,
                itemCount: snapshot.data!.size,
                itemBuilder: (context, index) {
                  var data = snapshot.data!.docs[index];
                  if (service.user!.uid == data['senderID'])
                    return MyMessageItem(data: data, index: index, );
                  return MessageItem(
                    data: data,
                    index: index,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class MessageItem extends StatelessWidget {
  MessageItem({
    Key? key,
    required this.data,
    required this.index,
  }) : super(key: key);

  final QueryDocumentSnapshot<Object?> data;
  final int index;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    switch (data['type']) {
      case 'text':
        {
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
                padding:
                    EdgeInsets.only(left: 16, top: 25, bottom: 25, right: 32),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  color: Color(0xff006D84),
                ),
                child: Text(
                  data['message'],
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )),
          );
        }
        break;
      case 'img':
        {
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: size.height / 2.5,
              width: size.width / 2,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: InkWell(
                onTap: (){},
                child: Container(
                  height: size.height / 2.5,
                  width: size.width / 2,
                  decoration: BoxDecoration(border: Border.all()),
                  child: data['message'] != ""
                      ? Image.network(
                          data['message'],
                          fit: BoxFit.fill,
                        )
                      : CircularProgressIndicator(),
                ),
              ),
            ),
          );
        }
        break;
      case 'document':
        {
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                margin: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width / 3,
                  left: 5.0,
                  top: 30.0,
                ),
                child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Stack(
                      children: [
                        Center(
                            child: Text(
                          'Loading Error',
                          style: TextStyle(
                            fontFamily: 'Lora',
                            color: Colors.red,
                            fontSize: 20.0,
                            letterSpacing: 1.0,
                          ),
                        )),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: PdfView(
                            path: data['message'],
                          ),
                        ),
                        Center(
                          child: GestureDetector(
                            child: Icon(
                              Icons.open_in_new_rounded,
                              size: 40.0,
                              color: Colors.blue,
                            ),
                            onTap: () async {
                              /*  final OpenResult openResult = await OpenFile.open(
                              this
                                  ._allConversationMessages[index]
                                  .keys
                                  .first);

                          openFileResultStatus(openResult: openResult);*/
                            },
                          ),
                        ),
                      ],
                    ))),
          );
        }
        break;
      default:
        {
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(),
          );
        }
        break;
    }
  }
}

class MyMessageItem extends StatefulWidget {
  MyMessageItem({
    Key? key,
    required this.data,
    required this.index,
  }) : super(key: key);

  final QueryDocumentSnapshot<Object?> data;
  final int index;

  @override
  State<MyMessageItem> createState() => _MyMessageItemState();
}

class _MyMessageItemState extends State<MyMessageItem> {

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

  void chatMicrophoneOnTapAction(int index) async {
    try {
      _justAudioPlayer.positionStream.listen((event) {
        if (mounted) {
          setState(() {
            _currAudioPlayingTime = event.inMicroseconds.ceilToDouble();
            _loadingTime =
            '${event.inMinutes} : ${event.inSeconds > 59 ? event.inSeconds % 60 : event.inSeconds}';
          });
        }
      });

      _justAudioPlayer.playerStateStream.listen((event) {
        if (event.processingState == ProcessingState.completed) {
          _justAudioPlayer.stop();
          if (mounted) {
            setState(() {
              this._loadingTime = '0:00';
              this._iconData = Icons.play_arrow_rounded;
            });
          }
        }
      });

      if (_lastAudioPlayingIndex != index) {
        await _justAudioPlayer.setUrl(widget.data['message']);

        if (mounted) {
          setState(() {
            _lastAudioPlayingIndex = index;
            _totalDuration =
            '${_justAudioPlayer.duration!.inMinutes} : ${_justAudioPlayer.duration!.inSeconds > 59 ? _justAudioPlayer.duration!.inSeconds % 60 : _justAudioPlayer.duration!.inSeconds}';
            _iconData = Icons.pause;
            this._audioPlayingSpeed = 1.0;
            _justAudioPlayer.setSpeed(this._audioPlayingSpeed);
          });
        }

        await _justAudioPlayer.play();
      } else {
        print(_justAudioPlayer.processingState);
        if (_justAudioPlayer.processingState == ProcessingState.idle) {
          await _justAudioPlayer.setUrl(widget.data['message']);

          if (mounted) {
            setState(() {
              _lastAudioPlayingIndex = index;
              _totalDuration =
              '${_justAudioPlayer.duration!.inMinutes} : ${_justAudioPlayer.duration!.inSeconds}';
              _iconData = Icons.pause;
            });
          }

          await _justAudioPlayer.play();
        } else if (_justAudioPlayer.playing) {
          if (mounted) {
            setState(() {
              _iconData = Icons.play_arrow_rounded;
            });
          }

          await _justAudioPlayer.pause();
        } else if (_justAudioPlayer.processingState == ProcessingState.ready) {
          if (mounted) {
            setState(() {
              _iconData = Icons.pause;
            });
          }

          await _justAudioPlayer.play();
        } else if (_justAudioPlayer.processingState ==
            ProcessingState.completed) {}
      }
    } catch (e) {
      print('Audio Playing Error');
      showSnackBar('May be Audio File Not Found',context);
    }
  }



  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    _justAudioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var cubit = PeopleCubit.get(context);
    switch (widget.data['type']) {
      case 'text':
        {
          return Align(
            alignment: Alignment.centerRight,
            child: TextMessage(message: widget.data['message']),
          );
        }
        break;
      case 'img':
        {
          return Align(
            alignment: Alignment.centerRight,
            child: ImageMessage(message: widget.data['message']),
          );
        }
        break;
      case 'document':
        {
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
                padding:
                    EdgeInsets.only(left: 16, top: 25, bottom: 25, right: 32),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  color: Color(0xff006D84),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PDFView(
                          url: widget.data['message'],
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        IconBroken.Document,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        'Document',
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                )),
          );
        }
        break;
      case 'audio':
        {
          return Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding:
                  EdgeInsets.only(left: 16, top: 25, bottom: 25, right: 32),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                color: Color(0xff006D84),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 20.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      chatMicrophoneOnTapAction(widget.index);
                    },
                    child: Icon(
                      _iconData,
                      color: Color.fromRGBO(10, 255, 30, 1),
                      size: 35.0,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              top: 26.0,
                            ),
                            child: LinearPercentIndicator(
                              percent: _justAudioPlayer.duration == null
                                  ? 0.0
                                  : _lastAudioPlayingIndex == widget.index
                                  ? _currAudioPlayingTime /
                                  _justAudioPlayer
                                      .duration!.inMicroseconds
                                      .ceilToDouble() <=
                                  1.0
                                  ? _currAudioPlayingTime /
                                  _justAudioPlayer
                                      .duration!.inMicroseconds
                                      .ceilToDouble()
                                  : 0.0
                                  : 0,
                              backgroundColor: Colors.black26,
                              progressColor: Colors.lightBlue

                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 7.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _lastAudioPlayingIndex == widget.index
                                          ? _loadingTime
                                          : '0:00',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      _lastAudioPlayingIndex == widget.index
                                          ? _totalDuration
                                          : '',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: GestureDetector(
                      child: Text(
                              '${_audioPlayingSpeed.toString().contains('.0') ? _audioPlayingSpeed.toString().split('.')[0] : _audioPlayingSpeed}x',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                      onTap: () {
                        print('Audio Play Speed Tapped');
                        if (mounted) {
                          setState(() {
                            if (this._audioPlayingSpeed != 3.0)
                              this._audioPlayingSpeed += 0.5;
                            else
                              this._audioPlayingSpeed = 1.0;

                            _justAudioPlayer.setSpeed(this._audioPlayingSpeed);
                          });
                        }
                      }),
                  ),
                ],
              ),
            ),
          );
        }
        break;
      default:
        {
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(),
          );
        }
        break;
    }
  }
}


class PDFView extends StatelessWidget {
  final String url;
  PdfViewerController? _pdfViewerController;

  PDFView({required this.url, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pdf View'),
      ),
      body: Container(
          height: size.height,
          width: size.width,
          color: Colors.black,
          child: SfPdfViewer.network(
            url,
            controller: _pdfViewerController,
          )),
    );
  }
}
