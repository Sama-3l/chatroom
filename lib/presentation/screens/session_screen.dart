// import 'dart:convert';

// import 'package:chatroom/algorithms/functions.dart';
// import 'package:chatroom/assets/svgs/svg_code.dart';
// import 'package:chatroom/constants/colors.dart';
// import 'package:chatroom/data/models/session.dart';
// import 'package:chatroom/data/models/sessions.dart';
// import 'package:chatroom/presentation/screens/chat.dart';
// import 'package:chatroom/presentation/widgets/input_field.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:iconify_flutter/iconify_flutter.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class SessionScreen extends StatefulWidget {
//   const SessionScreen({
//     super.key,
//     required this.sessionId,
//     required this.sessions,
//     required this.theme,
//     required this.currentUser,
//   });

//   final int sessionId;
//   final Sessions sessions;
//   final DarkTheme theme;
//   final User? currentUser;

//   @override
//   State<SessionScreen> createState() => _SessionScreenState();
// }

// class _SessionScreenState extends State<SessionScreen> {
//   Methods func = Methods();
//   Sessions currentSessions = Sessions(sessions: [
//     Session(messages: [], sessionId: 1, chatRoomName: "")
//   ]);
//   late WebSocketChannel channel; //channel variable for websocket
//   late WebSocketChannel writeChannel; //channel variable for websocket
//   late bool connected; // boolean value to track connection status

//   String myid = "1234"; //my id
//   String recieverid = "4321"; //reciever id
//   // swap myid and recieverid value on another mobile to test send and recieve
//   String auth = "addauthkeyifrequired"; //auth key

//   List<MessageData> msglist = [];

//   TextEditingController msgtext = TextEditingController();

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     openBox(context);
//     readChannelConenct();
//   }

//   void openBox(BuildContext context) async {
//     await Hive.openBox<Session>('Sessions');
//     func.initalizeSessions(currentSessions, context);
//   }

//   readChannelConenct() {
//     //function to connect
//     channel = WebSocketChannel.connect(Uri.parse('wss://echo.websocket.org/vLMuxKygVOeXFOZFIVNTfv9VQk32'));
//     try {
//       channel.stream.listen(
//         (message) {
//           if (kDebugMode) {
//             print("Message: $message");
//           }
//           setState(() {
//             connected = true;
//             setState(() {});
//             if (kDebugMode) {
//               print("Connection establised.");
//             }
//             message = message.replaceAll(RegExp("'"), '"');
//             var jsondata = json.decode(message);

//             msglist.add(MessageData(
//               //on message recieve, add data to model
//               msgtext: jsondata["msgtext"],
//               userid: jsondata["userid"],
//               isme: false,
//             ));
//             setState(() {
//               //update UI after adding data to message model
//             });
//             // if (message == "connected") {
//             // } else if (message == "send:success") {
//             //   if (kDebugMode) {
//             //     print("Message send success");
//             //   }
//             //   setState(() {
//             //     msgtext.text = "";
//             //   });
//             // } else if (message == "send:error") {
//             //   if (kDebugMode) {
//             //     print("Message send error");
//             //   }
//             // } else if (message.substring(0, 6) == "{'cmd'") {
//             //   if (kDebugMode) {
//             //     print("Message data");
//             //   }
//             //   message = message.replaceAll(RegExp("'"), '"');
//             //   var jsondata = json.decode(message);

//             //   msglist.add(MessageData(
//             //     //on message recieve, add data to model
//             //     msgtext: jsondata["msgtext"],
//             //     userid: jsondata["userid"],
//             //     isme: false,
//             //   ));
//             //   setState(() {
//             //     //update UI after adding data to message model
//             //   });
//             // }
//           });
//         },
//         onDone: () {
//           //if WebSocket is disconnected
//           if (kDebugMode) {
//             print("Web socket is closed");
//           }
//           setState(() {
//             connected = false;
//           });
//         },
//         onError: (error) {
//           if (kDebugMode) {
//             print("Error:= ${error.toString()}");
//           }
//         },
//       );
//     } catch (_) {
//       if (kDebugMode) {
//         print("error on connecting to websocket.");
//       }
//     }
//   }

//   Future<void> sendmsg(String sendmsg, String id) async {
//     writeChannel = WebSocketChannel.connect(Uri.parse('wss://echo.websocket.org/${widget.currentUser!.uid}'));
//     if (connected == true) {
//       String msg = "{'auth':'$auth','cmd':'send','userid':'$id', 'msgtext':'$sendmsg'}";
//       setState(() {
//         msgtext.text = "";
//         msglist.add(MessageData(msgtext: sendmsg, userid: myid, isme: true));
//       });
//       writeChannel.sink.add(msg); //send message to reciever channel
//     } else {
//       if (kDebugMode) {
//         print("Websocket is not connected.");
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 24, left: 8, right: 8),
//       child: Column(
//         children: [
//           // ElevatedButton(onPressed: () => func.addSession(currentSessions.sessions.length + 1, context), child: Icon(Icons.add)),
//           // ElevatedButton(onPressed: () => func.initalizeSessions(currentSessions, context), child: Icon(Icons.subdirectory_arrow_left_rounded)),
//           // Expanded(
//           //   child: ListView.builder(
//           //       itemCount: widget.sessions.sessions[widget.sessionId - 1].messages.isEmpty ? 0 : widget.sessions.sessions[widget.sessionId - 1].messages.length,
//           //       itemBuilder: (context, index) {
//           //         return Text(
//           //           widget.sessions.sessions[widget.sessionId - 1].messages[index].message,
//           //           style: urbanist(Colors.white),
//           //         );
//           //       }),
//           // ),
//           Expanded(
//             child: ListView(
//               children: msglist.map((onemsg) {
//                 return Container(
//                     margin: EdgeInsets.only(
//                       //if is my message, then it has margin 40 at left
//                       left: onemsg.isme ? 40 : 0,
//                       right: onemsg.isme ? 0 : 40, //else margin at right
//                     ),
//                     child: Card(
//                         color: onemsg.isme ? Colors.blue[100] : Colors.red[100],
//                         //if its my message then, blue background else red background
//                         child: Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.all(15),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(onemsg.isme ? "ID: ME" : "ID: ${onemsg.userid}"),
//                               Container(
//                                 margin: const EdgeInsets.only(top: 10, bottom: 10),
//                                 child: Text("Message: ${onemsg.msgtext}", style: const TextStyle(fontSize: 17)),
//                               ),
//                             ],
//                           ),
//                         )));
//               }).toList(),
//             ),
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: InputWidget(
//                   text: "Enter a message",
//                   txt: msgtext,
//                   error: false,
//                   theme: widget.theme,
//                   title: "Enter a message",
//                   titleletterSpacing: 0,
//                 ),
//               ),
//               ElevatedButton(
//                   onPressed: () {
//                     if (msgtext.text != "") {
//                       sendmsg(msgtext.text, recieverid); //send message with webspcket
//                     } else {
//                       if (kDebugMode) {
//                         print("Enter message");
//                       }
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: widget.theme.surfaceElevated,
//                     shape: const CircleBorder(),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Iconify(
//                       send,
//                       size: 24,
//                       color: widget.theme.uiYellow,
//                     ),
//                   ))
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
