import 'dart:async';
import 'package:FlutterMobilenet/services/tensorflow-service.dart';
import 'package:flutter/material.dart';

class Recognition extends StatefulWidget {
  Recognition({Key key, @required this.ready}) : super(key: key);

  // indicates if the animation is finished to start streaming (for better performance)
  final bool ready;

  @override
  _RecognitionState createState() => _RecognitionState();
}

// to track the subscription state during the lifecicle of the component
enum SubscriptionState { Active, Done }

class _RecognitionState extends State<Recognition> {
  // Campus Building Map -> Eng : Kor
  final Map<String, String> engToKor = {
    "library": "학술정보원",
    "science": "제 2과학기술대학",
    "nongshim": "농심국제관",
    "unknown": "인식불가",
  };

  // AR mode ON/OFF
  bool _isOn = false;

  // current list of recognition
  List<dynamic> _currentRecognition = [];

  // listens the changes in tensorflow recognitions
  StreamSubscription _streamSubscription;

  // tensorflow service injection
  TensorflowService _tensorflowService = TensorflowService();

  @override
  void initState() {
    super.initState();

    // starts the streaming to tensorflow results
    // if (_isOn) {
    //   _startRecognitionStreaming();
    // }
    _startRecognitionStreaming();
  }

  _startRecognitionStreaming() {
    if (_streamSubscription == null) {
      _streamSubscription =
          _tensorflowService.recognitionStream.listen((recognition) {
        if (recognition != null) {
          // rebuilds the screen with the new recognitions
          setState(() {
            _currentRecognition = recognition;
          });
        } else {
          _currentRecognition = [];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        // height: 600,
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: widget.ready
                    ? <Widget>[
                        if (_isOn) _contentWidget(),
                        if (!_isOn) SizedBox(height: 100),
                        // shows recognition title
                        _titleWidget(),

                        // shows recognitions list
                        SizedBox(
                          height: 10,
                        ),

                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isOn = !_isOn;
                            });
                          },
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: <Widget>[
                              Icon(
                                Icons.radio_button_off_rounded,
                                size: 100,
                                color:
                                    !_isOn ? Colors.white : Colors.yellow[600],
                              ),
                              Text(
                                'AI',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: !_isOn
                                      ? Colors.white
                                      : Colors.yellow[600],
                                ),
                              )
                            ],
                          ),
                        )
                      ]
                    : <Widget>[],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 20, right: 10),
      child: Text(
        !_isOn ? "AI Mode Off" : "AI Mode On",
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w300,
            color: !_isOn ? Colors.white : Colors.yellow[600]),
      ),
    );
  }

  Widget _contentWidget() {
    if (_currentRecognition.length > 0) {
      return Center(
        child: Container(
          height: 100,
          child: ListView.builder(
            itemCount: 1, //_currentRecognition.length,
            itemBuilder: (context, index) {
              if (_currentRecognition.length > index) {
                return Column(children: [
                  Text(
                    engToKor[_currentRecognition[index]['label']],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 36,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                  Text(
                    _currentRecognition[index]['label'],
                    style: TextStyle(fontSize: 20),
                  ),
                ]);
              } else {
                return Container();
              }
            },
          ),
        ),
      );
      // return Container(
      //   height: 100,
      //   child: ListView.builder(
      //     itemCount: 1, //_currentRecognition.length,
      //     itemBuilder: (context, index) {
      //       if (_currentRecognition.length > index) {
      //         return ListTile(
      //           title: Text(
      //             engToKor[_currentRecognition[index]['label']],
      //             maxLines: 1,
      //             overflow: TextOverflow.ellipsis,
      //             style: TextStyle(
      //                 fontSize: 24,
      //                 fontStyle: FontStyle.italic,
      //                 fontWeight: FontWeight.bold),
      //           ),
      //           subtitle: Text(_currentRecognition[index]['label']),
      //         );
      //       } else {
      //         return Container();
      //       }
      //     },
      //   ),
      // );
    } else {
      return Text('');
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}
