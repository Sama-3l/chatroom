import 'package:chatroom/algorithms/functions.dart';
import 'package:chatroom/business_logic/cubits/changeChatSession/change_chat_session_cubit.dart';
import 'package:chatroom/constants/colors.dart';
import 'package:chatroom/data/models/session.dart';
import 'package:chatroom/data/models/sessions.dart';
import 'package:chatroom/presentation/screens/chat.dart';
import 'package:chatroom/presentation/screens/sessions_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.currentUser, required this.theme});

  final User? currentUser;
  final DarkTheme theme;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Methods func = Methods();
  Sessions currentSessions = Sessions(sessions: [
    Session(messages: [], sessionId: 1, chatRoomName: "New Session")
  ]);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    openBox(context);
  }

  void openBox(BuildContext context) async {
    await Hive.openBox<Session>('Sessions');
    func.initalizeSessions(currentSessions, context);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: widget.theme.surfaceBlack,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: BlocBuilder<ChangeChatSessionCubit, ChangeChatSessionState>(
          builder: (context, state) {
            return Row(
              children: [
                SizedBox(
                    height: height,
                    width: width * 0.2,
                    child: SessionsMenu(
                      currentSessions: currentSessions,
                      theme: widget.theme,
                      sessionId: state.sessionsId,
                    )),
                SizedBox(
                    height: height,
                    width: width * 0.8,
                    child: ChatPageScreen(
                      currentUser: widget.currentUser,
                      theme: widget.theme,
                      currentSession: currentSessions.sessions[state.sessionsId - 1],
                    )
                    // child: SessionScreen(
                    //   sessions: currentSessions,
                    //   sessionId: state.sessionsId,
                    //   theme: widget.theme,
                    //   currentUser: widget.currentUser,
                    ),
              ],
            );
          },
        ),
      ),
    );
  }
}
