import 'package:chatroom/algorithms/functions.dart';
import 'package:chatroom/assets/svgs/svg_code.dart';
import 'package:chatroom/business_logic/cubits/changeChatSession/change_chat_session_cubit.dart';
import 'package:chatroom/constants/colors.dart';
import 'package:chatroom/constants/const_functions.dart';
import 'package:chatroom/data/models/sessions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class SessionsMenu extends StatefulWidget {
  const SessionsMenu({super.key, required this.currentSessions, required this.theme, required this.sessionId});

  final Sessions currentSessions;
  final DarkTheme theme;
  final int sessionId;

  @override
  State<SessionsMenu> createState() => _SessionsMenuState();
}

class _SessionsMenuState extends State<SessionsMenu> {
  Methods func = Methods();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(bottom: 0.03 * size.height, left: 0.01 * size.width, right: 0.01 * size.width),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
          child: ListView.builder(
              itemCount: widget.currentSessions.sessions.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.015 * size.height),
                  child: ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<ChangeChatSessionCubit>(context).onChangedSession(widget.currentSessions.sessions[index].sessionId);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(left: 0.01 * size.width, right: 0.005 * size.width),
                      backgroundColor: widget.theme.surfaceBlack,
                      shape: RoundedRectangleBorder(side: BorderSide(color: index == widget.sessionId - 1 ? widget.theme.uiYellow : widget.theme.surfaceElevated), borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 0.005 * size.width, bottom: 0.005 * size.width),
                      child: Center(
                        child: Row(
                          children: [
                            Text(
                              "${widget.currentSessions.sessions[index].chatRoomName} ${widget.currentSessions.sessions[index].sessionId}",
                              style: urbanist(widget.theme.labelWhite, fontsize: 0.01 * size.width),
                            ),
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // SizedBox(
                                //   width: 0.02 * size.width,
                                //   height: 0.02 * size.width,
                                //   child: IconButton(
                                //       onPressed: () {},
                                //       padding: EdgeInsets.zero,
                                //       icon: Iconify(
                                //         edit,
                                //         color: widget.theme.labelWhite,
                                //         size: 0.012 * size.width,
                                //       )),
                                // ),
                                SizedBox(
                                  width: 0.02 * size.width,
                                  height: 0.02 * size.width,
                                  child: IconButton(
                                      onPressed: () => func.deleteSession(
                                            index,
                                            widget.sessionId,
                                            context,
                                            widget.currentSessions,
                                          ),
                                      padding: EdgeInsets.zero,
                                      icon: Iconify(
                                        delete,
                                        color: widget.theme.labelWhite,
                                        size: 0.012 * size.width,
                                      )),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
        GestureDetector(
          onTap: () => func.addSession(widget.currentSessions.sessions.length + 1, widget.sessionId, context, widget.currentSessions),
          child: Container(
            decoration: BoxDecoration(
              color: widget.theme.surfaceElevated,
              borderRadius: BorderRadius.circular(0.016 * size.width),
            ),
            child: Padding(
              padding: EdgeInsets.all(0.01 * size.width),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "New session",
                    style: urbanist(widget.theme.labelWhite, fontsize: 0.01 * size.width),
                  ),
                  Iconify(
                    add,
                    color: widget.theme.labelWhite,
                    size: 0.02 * size.width,
                  )
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
