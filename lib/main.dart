import 'package:chatroom/algorithms/websocket_service.dart';
import 'package:chatroom/business_logic/cubits/changeChatSession/change_chat_session_cubit.dart';
import 'package:chatroom/business_logic/cubits/editSessionName/edit_session_name_cubit.dart';
import 'package:chatroom/business_logic/cubits/messageAdded/message_added_cubit.dart';
import 'package:chatroom/constants/colors.dart';
import 'package:chatroom/data/models/message.dart';
import 'package:chatroom/data/models/session.dart';
import 'package:chatroom/firebase_options.dart';
import 'package:chatroom/presentation/screens/google_signIn.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

final webSocket = WebSocketClient();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(SessionAdapter());
  Hive.registerAdapter(MessageAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ChangeChatSessionCubit()),
        BlocProvider(create: (context) => EditSessionNameCubit()),
        BlocProvider(create: (context) => MessageAddedCubit())
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: GoogleSignIn(theme: DarkTheme())),
    );
  }
}
