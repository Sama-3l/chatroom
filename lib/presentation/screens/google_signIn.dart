import 'package:chatroom/assets/svgs/svg_code.dart';
import 'package:chatroom/constants/colors.dart';
import 'package:chatroom/constants/const_functions.dart';
import 'package:chatroom/presentation/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignIn extends StatefulWidget {
  const GoogleSignIn({Key? key, required this.theme}) : super(key: key);

  final DarkTheme theme;

  @override
  State<GoogleSignIn> createState() => _GoogleSignInState();
}

class _GoogleSignInState extends State<GoogleSignIn> {
  String? name, imageUrl, userEmail, uid;
  User? user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: widget.theme.surfaceBlack,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 0.03 * size.height),
            child: Iconify(logo, size: size.width * 0.05),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 0.1 * size.height),
            child: Text(
              'Welcome to ChatRoom, websocket based messaging application. Texting using Gmail Auth.',
              style: urbanist(widget.theme.labelWhite, fontsize: 0.012 * size.width),
            ),
          ),
          Center(
            child: InkWell(
              onTap: () async {
                await signInWithGoogle();
                if (user != null) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: ((context) => ChatPage(
                          currentUser: user,
                          theme: widget.theme,
                        )),
                  ));
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 0.02 * size.width, vertical: 0.015 * size.height),
                decoration: BoxDecoration(color: widget.theme.uiYellow, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 0.01 * size.height),
                      child: Iconify(google, size: size.width * 0.023),
                    ),
                    Text(
                      'Sign In with Google',
                      style: urbanist(widget.theme.surfaceBlack, fontsize: 0.017 * size.width, weight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<User?> signInWithGoogle() async {
    // Initialize Firebase
    await Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
    GoogleAuthProvider authProvider = GoogleAuthProvider();

    try {
      final UserCredential userCredential = await auth.signInWithPopup(authProvider);
      user = userCredential.user;
    } catch (e) {
      print(e);
    }

    if (user != null) {
      uid = user!.uid;
      name = user!.displayName;
      userEmail = user!.email;
      imageUrl = user!.photoURL;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('auth', true);
      print(user);
    }
    return user;
  }
}
