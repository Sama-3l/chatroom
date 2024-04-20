import 'dart:convert';

import 'package:chatroom/algorithms/functions.dart';
import 'package:chatroom/assets/svgs/svg_code.dart';
import 'package:chatroom/constants/colors.dart';
import 'package:chatroom/constants/const_functions.dart';
import 'package:chatroom/data/models/message.dart';
import 'package:chatroom/data/models/session.dart';
import 'package:chatroom/presentation/widgets/input_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:intl/intl.dart';

class ChatPageScreen extends StatefulWidget {
  ChatPageScreen({
    super.key,
    required this.currentUser,
    required this.theme,
    required this.currentSession,
  });

  final User? currentUser;
  final DarkTheme theme;
  final Session currentSession;

  @override
  State<StatefulWidget> createState() {
    return ChatPageScreenState();
  }
}

class ChatPageScreenState extends State<ChatPageScreen> {
  late bool connected;

  TextEditingController msgtext = TextEditingController();
  late WebSocketChannel channel = WebSocketChannel.connect(Uri.parse(
    'wss://echo.websocket.org/${widget.currentSession.sessionId}',
  ));
  Methods func = Methods();

  @override
  void initState() {
    connected = false;
    msgtext.text = "";
    readChannelConnect();
    super.initState();
  }

  readChannelConnect() {
    //function to connect
    try {
      channel.stream.listen(
        (message) {
          if (kDebugMode) {
            print("Message Heard: $message");
          }
          setState(() {
            connected = true;
            setState(() {});
            if (kDebugMode) {
              print("Connection establised.");
            }
            message = message.replaceAll(RegExp("'"), '"');
            var jsondata = json.decode(message);
            widget.currentSession.messages.add(Message(
              //on message recieve, add data to model
              message: jsondata["msgtext"],
              dateTime: DateTime.now(),
              isme: false,
            ));
            func.addMessage(widget.currentSession);
            setState(() {
              //update UI after adding data to message model
            });
          });
        },
        onDone: () {
          //if WebSocket is disconnected
          if (kDebugMode) {
            print("Web socket is closed");
          }
          setState(() {
            connected = false;
          });
        },
        onError: (error) {
          if (kDebugMode) {
            print("Error:= ${error.toString()}");
          }
        },
      );
    } catch (_) {
      if (kDebugMode) {
        print("error on connecting to websocket.");
      }
    }
  }

  Future<void> sendmsg(String sendmsg) async {
    if (connected == true) {
      String msg = "{'cmd':'send', 'msgtext':'$sendmsg'}";
      setState(() {
        msgtext.text = "";
        widget.currentSession.messages.add(Message(message: sendmsg, dateTime: DateTime.now(), isme: true));
      });
      channel.sink.add(msg); //send message to reciever channel
    } else {
      if (kDebugMode) {
        print("Websocket is not connected.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: widget.theme.surfaceBlack,
        appBar: AppBar(
          backgroundColor: widget.theme.surfaceBlack,
          title: Padding(
            padding: EdgeInsets.only(top: 0.015 * size.height),
            child: Text("${widget.currentSession.chatRoomName} ${widget.currentSession.sessionId}",
                style: urbanist(
                  widget.theme.labelWhite,
                  fontsize: 0.016 * size.width,
                  weight: FontWeight.w500,
                )),
          ),
          leading: Padding(
            padding: EdgeInsets.only(top: 0.015 * size.height),
            child: Icon(Icons.circle, size: 0.016 * size.width, color: connected ? Colors.greenAccent : Colors.redAccent),
          ),
          titleSpacing: 0,
        ),
        body: Padding(
          padding: EdgeInsets.only(bottom: 0.03 * size.height, left: 0.01 * size.width, right: 0.01 * size.width),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: widget.currentSession.messages.map((onemsg) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.005 * size.width),
                      child: Align(
                        alignment: onemsg.isme ? Alignment.centerRight : Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: onemsg.isme ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Card(
                                color: onemsg.isme ? widget.theme.uiYellow : widget.theme.surfaceElevated,
                                //if its my message then, blue background else red background
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 0.01 * size.width, vertical: 0.005 * size.width),
                                  child: Text(onemsg.message,
                                      style: urbanist(
                                        !onemsg.isme ? widget.theme.uiYellow : widget.theme.surfaceElevated,
                                        fontsize: 0.01 * size.width,
                                      )),
                                )),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 0.005 * size.width, vertical: 0.002 * size.width),
                              child: Text(DateFormat('dd-MM hh:mm a').format(onemsg.dateTime),
                                  style: urbanist(
                                    widget.theme.labelWhite.withOpacity(0.7),
                                    fontsize: 0.007 * size.width,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputWidget(
                      text: "Enter a message",
                      txt: msgtext,
                      error: false,
                      theme: widget.theme,
                      title: "Enter a message",
                      titleletterSpacing: 0,
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (msgtext.text != "") {
                          sendmsg(msgtext.text); //send message with webspcket
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.theme.surfaceElevated,
                        shape: const CircleBorder(),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Iconify(
                          send,
                          size: 0.016 * size.width,
                          color: widget.theme.uiYellow,
                        ),
                      ))
                ],
              )
            ],
          ),
        ));
  }
}
