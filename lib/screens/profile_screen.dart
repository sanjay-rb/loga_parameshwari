import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:loga_parameshwari/model/user.dart';
import 'package:loga_parameshwari/services/database_manager.dart';
import 'package:loga_parameshwari/services/responsive_services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key, this.userModel}) : super(key: key);
  final UserModel userModel;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _userNameCtrl = TextEditingController();
  final userUpdateFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
              future: DatabaseManager.getUserInfo(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                } else {
                  UserModel userModel =
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
                          Text(
                            "User Profile",
                            style: TextDesign.headText,
                          ),
                          ...[
                            SizedBox(
                              height: Responsiveness.height(10),
                            ),
                            Text("Name"),
                            Divider(
                              endIndent: Responsiveness.widthRatio(0.7),
                              color: Colors.black,
                            ),
                            Container(
                              color: Colors.yellow,
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Please enter your name here.";
                                  } else {
                                    return null;
                                  }
                                },
                                controller: _userNameCtrl,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                          ...[
                            SizedBox(
                              height: Responsiveness.height(10),
                            ),
                            Text("Number (Can't edit number)"),
                            Divider(
                              endIndent: Responsiveness.widthRatio(0.7),
                              color: Colors.black,
                            ),
                            Container(
                              color: Colors.yellow,
                              child: TextFormField(
                                initialValue: userModel.id,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                enabled: false,
                              ),
                            ),
                          ],
                          SizedBox(
                            height: Responsiveness.height(20),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (userUpdateFormKey.currentState.validate()) {
                                  UserModel newUser = UserModel(
                                      id: userModel.id,
                                      uid: userModel.uid,
                                      name: _userNameCtrl.text.trim());
                                  await DatabaseManager.addUser(newUser);
                                  Navigator.pop(context);
                                }
                              },
                              child: Text("OK"),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }
}
