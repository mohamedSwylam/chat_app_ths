import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:record/record.dart';

import '../shared/components/components.dart';

class AudioMessage extends StatefulWidget {
  final String message;
  final int index;
  const AudioMessage({Key? key, required this.message,required this.index}) : super(key: key);

  @override
  _AudioMessageState createState() => _AudioMessageState();
}

class _AudioMessageState extends State<AudioMessage> {
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

  void _chatMicrophoneOnLongPressAction() async {
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
  }

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
        await _justAudioPlayer.setUrl(widget.message);

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
          await _justAudioPlayer.setUrl(widget.message);

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
    return Container(
      padding:
      EdgeInsets.only(left: 0, top: 5, bottom: 10, right: 15),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
          bottomLeft: Radius.circular(32),
        ),
        color: Colors.blue.shade200,
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
            onLongPress: (){
              _chatMicrophoneOnLongPressAction();
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
    );
  }
}
