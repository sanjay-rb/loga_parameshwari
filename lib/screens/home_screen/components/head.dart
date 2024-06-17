import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:loga_parameshwari/constant/constant.dart';
import 'package:loga_parameshwari/model/user_model.dart';
import 'package:loga_parameshwari/screens/profile_screen.dart';
import 'package:loga_parameshwari/services/database_manager.dart';
import 'package:loga_parameshwari/services/navigation_animation_services.dart';

class HeadComponent extends StatelessWidget {
  const HeadComponent({Key key}) : super(key: key);

  Stream<String> getGreeting() async* {
    if (DateTime.now().hour >= 3 && DateTime.now().hour < 12) {
      yield "Good Morning";
    } else if (DateTime.now().hour >= 12 && DateTime.now().hour < 17) {
      yield "Good Afternoon";
    } else if (DateTime.now().hour >= 17 && DateTime.now().hour < 20) {
      yield "Good Evening";
    } else {
      yield "Good Night";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder(
          future: DatabaseManager.getUserInfo(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text(
                "Loading...",
                style: TextDesign.headText,
                textAlign: TextAlign.left,
              );
            } else {
              final UserModel userModel =
                  UserModel.fromJson(snapshot.data.docs.first);
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    NavigationAnimationService.fadePageRoute(
                      enterPage: const ProfileScreen(),
                    ),
                  );
                },
                child: Text(
                  userModel.name,
                  style: TextDesign.headText,
                  textAlign: TextAlign.left,
                ),
              );
            }
          },
        ),
        StreamBuilder<String>(
          stream: getGreeting(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text(
                "Loading...",
                style: TextDesign.titleText,
                textAlign: TextAlign.left,
              );
            } else {
              return Text(
                "${snapshot.data}🙏",
                style: TextDesign.titleText,
                textAlign: TextAlign.left,
              );
            }
          },
        ),
        StreamBuilder<List<UserModel>>(
          stream: UserModel.getOnlineUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text(
                "Loading...",
                style: TextDesign.titleText,
                textAlign: TextAlign.right,
              );
            } else {
              return InkWell(
                onTap: () {
                  bottomSheet(context, snapshot.data);
                },
                child: Text(
                  "${snapshot.data.length} Online User",
                  style: TextDesign.titleText.copyWith(
                    color: Colors.green.shade700,
                  ),
                  textAlign: TextAlign.right,
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

void bottomSheet(BuildContext context, List<UserModel> users) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        maxChildSize: 0.70,
        minChildSize: 0.50,
        builder: (context, scrollController) => Column(
          children: [
            ClipOval(
              child: Material(
                color: Colors.black,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, i) => ListTile(
                      leading: const Icon(
                        Icons.person_outline_outlined,
                        color: Colors.green,
                        size: 25,
                      ),
                      title: Text(
                        users[i].name,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
