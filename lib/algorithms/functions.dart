import 'package:chatroom/business_logic/cubits/changeChatSession/change_chat_session_cubit.dart';
import 'package:chatroom/data/models/session.dart';
import 'package:chatroom/data/models/sessions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Methods {
  void initalizeSessions(Sessions currentSessions, BuildContext context) {
    Box<Session> sessionsBox;
    try {
      sessionsBox = Hive.box<Session>('Sessions');
    } catch (e) {
      return;
    }
    if (sessionsBox.values.isNotEmpty) {
      currentSessions.sessions = sessionsBox.values.toList();
      BlocProvider.of<ChangeChatSessionCubit>(context).onChangedSession(1);
    } else {
      Hive.box<Session>('Sessions').put(currentSessions.sessions.first.sessionId, currentSessions.sessions.first);
    }
  }

  void addSession(int sessionId, int originalId, BuildContext context, Sessions sessions) {
    Hive.openBox<Session>('Sessions');
    Hive.box<Session>('Sessions').put(
        sessionId,
        Session(
          messages: [],
          sessionId: sessionId,
          chatRoomName: "New Session",
        ));
    sessions.sessions.add(Session(messages: [], sessionId: sessionId, chatRoomName: "New Session"));
    BlocProvider.of<ChangeChatSessionCubit>(context).onChangedSession(originalId);
  }

  void deleteSession(int sessionId, int originalId, BuildContext context, Sessions sessions) {
    if (sessions.sessions.length > 1) {
      Hive.openBox<Session>('Sessions');
      Hive.box<Session>('Sessions').deleteAll(Hive.box<Session>('Sessions').keys);
      sessions.sessions.removeAt(sessionId);
      int p = 1;
      sessions.sessions = sessions.sessions.map((e) {
        if (originalId == sessionId) originalId = p;
        e.sessionId = p++;
        Hive.box<Session>('Sessions').put(p, e);
        return e;
      }).toList();
      BlocProvider.of<ChangeChatSessionCubit>(context).onChangedSession(originalId < sessions.sessions.length ? originalId : sessions.sessions.length);
    }
  }

  List<bool> selectSession(int index, int length) {
    List<bool> list = List<bool>.filled(length, false);
    list[index] = true;
    return list;
  }

  void addMessage(Session session) async {
    Hive.box<Session>('Sessions').putAt(session.sessionId - 1, session);
  }
}
