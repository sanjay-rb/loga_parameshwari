import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:loga_parameshwari/model/user.dart';
import 'package:loga_parameshwari/services/database_manager.dart';
import 'package:loga_parameshwari/services/responsive_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key, this.userModel}) : super(key: key);
  final UserModel userModel;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _userNameCtrl = TextEditingController();
  final userUpdateFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
            future: DatabaseManager.getUserInfo(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final UserModel userModel =
                    UserModel.fromJson(snapshot.data.docs.first);
                _userNameCtrl.text = userModel.name;
                return Form(
                  key: userUpdateFormKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Responsiveness.height(10),
                        ),
                        const Text(
                          "User Profile",
                          style: TextDesign.headText,
                        ),
                        ...[
                          SizedBox(
                            height: Responsiveness.height(10),
                          ),
                          const Text("Name"),
                          Divider(
                            endIndent: Responsiveness.widthRatio(0.7),
                            color: Colors.black,
                          ),
                          ColoredBox(
                            color: Colors.grey.shade300,
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please enter your name here.";
                                } else {
                                  return null;
                                }
                              },
                              controller: _userNameCtrl,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(10),
                              ),
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                        ...[
                          SizedBox(
                            height: Responsiveness.height(10),
                          ),
                          const Text("Number (Can't edit number)"),
                          Divider(
                            endIndent: Responsiveness.widthRatio(0.7),
                            color: Colors.black,
                          ),
                          ColoredBox(
                            color: Colors.grey.shade300,
                            child: TextFormField(
                              initialValue: userModel.id,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(10),
                              ),
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              enabled: false,
                            ),
                          ),
                        ],
                        ...[
                          SizedBox(
                            height: Responsiveness.height(10),
                          ),
                          const Text("Can we show app tutorial next time ?"),
                          Divider(
                            endIndent: Responsiveness.widthRatio(0.7),
                            color: Colors.black,
                          ),
                          const TutorialToggler(),
                        ],
                        SizedBox(
                          height: Responsiveness.height(20),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (userUpdateFormKey.currentState.validate()) {
                                final UserModel newUser = UserModel(
                                  id: userModel.id,
                                  uid: userModel.uid,
                                  name: _userNameCtrl.text.trim(),
                                );
                                await DatabaseManager.addUser(newUser)
                                    .then((value) {
                                  Navigator.pop(context);
                                });
                              }
                            },
                            child: const Text("OK"),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class TutorialToggler extends StatefulWidget {
  const TutorialToggler({Key key}) : super(key: key);

  @override
  State<TutorialToggler> createState() => TutorialTogglerState();
}

class TutorialTogglerState extends State<TutorialToggler> {
  bool isTutorialShown = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((value) {
      if (value.getBool(SHARE_PREF_TUTORIAL) != null) {
        setState(() {
          isTutorialShown = value.getBool(SHARE_PREF_TUTORIAL);
        });
      } else {
        setState(() {
          isTutorialShown = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isTutorialShown = !isTutorialShown;
        });
        SharedPreferences.getInstance().then((value) {
          value.setBool(SHARE_PREF_TUTORIAL, isTutorialShown);
        });
      },
      child: ColoredBox(
        color: Colors.grey.shade300,
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Tutorial",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            const Spacer(),
            Switch.adaptive(
              value: isTutorialShown,
              onChanged: (v) {
                setState(() {
                  isTutorialShown = v;
                });
                SharedPreferences.getInstance().then((value) {
                  value.setBool(SHARE_PREF_TUTORIAL, isTutorialShown);
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
