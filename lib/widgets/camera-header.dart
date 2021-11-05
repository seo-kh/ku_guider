import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

const url = "https://sejong.korea.ac.kr/kr";

class CameraHeader extends StatelessWidget {
  const CameraHeader({Key key}) : super(key: key);

  void launchURL() async =>
      await canLaunch(url) ? launch(url) : throw 'Could not launch $url';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        minimum: EdgeInsets.only(top: 45),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text('앱을 종료하시겠습니까?'),
                            content: Text('Are you want to quit the app?'),
                            backgroundColor: Color(0xAA8c1129),
                            elevation: 5.0,
                            actions: <Widget>[
                              // Divider(),
                              IconButton(
                                  onPressed: () {
                                    SystemNavigator.pop();
                                  },
                                  icon: Icon(Icons.done)),
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(Icons.close)),
                            ],
                            actionsAlignment: MainAxisAlignment.spaceEvenly,
                          ));
                },
                icon: Icon(
                  Icons.close_rounded,
                )),
            Text('Campus Guider',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                )),
            PopupMenuButton(
                color: Color(0xAA8C1129),
                itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: GestureDetector(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[Icon(Icons.info), Text('정보')],
                          ),
                          onTap: () {
                            showAboutDialog(
                              context: context,
                              applicationName: "캠퍼스 가이더",
                              applicationVersion: "1.0.0",
                              applicationLegalese: "제작자 : 서광현",
                            );
                          },
                        ),
                      ),
                      PopupMenuItem(
                        child: GestureDetector(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[Icon(Icons.explore), Text('링크')],
                          ),
                          onTap: launchURL,
                        ),
                        value: 2,
                      ),
                    ]),
          ],
        ),
      ),
    );
  }
}
