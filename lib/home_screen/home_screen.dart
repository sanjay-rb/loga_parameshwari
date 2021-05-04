import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter/material.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:flutter_restart/flutter_restart.dart';
import 'components/ar_view.dart';
import 'components/review_app.dart';
import 'components/share_app.dart';
import 'components/special_pooja.dart';
import 'components/head.dart';
import 'components/home_keys.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _bottomAppBarHeight = 50.0;
  ScrollController _homeListController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: BottomAppBar(
          elevation: 0.3,
          notchMargin: 5,
          clipBehavior: Clip.antiAlias,
          color: Color(0xff1c1f26),
          shape: AutomaticNotchedShape(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
          ),
          child: SizedBox(
            width: double.infinity,
            height: _bottomAppBarHeight,
            child: Row(
              children: [
                ReviewApp(),
                Spacer(),
                ShareApp(),
              ],
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        onPressed: () {
          _homeListController.animateTo(
            0.0,
            duration: Duration(seconds: 1),
            curve: Curves.ease,
          );
        },
        child: Icon(Icons.home),
      ),
      body: WillPopScope(
        onWillPop: _onBackPress,
        child: SafeArea(
          child: ConnectivityBuilder(builder: (context, isConnect, status) {
            if (isConnect) {
              return LayoutBuilder(
                builder: (context, constraints) => Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ListView(
                      controller: _homeListController,
                      children: [
                        HeadComponent(),
                        SizedBox(
                          height: 15,
                        ),
                        HomeKeysComponent(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight * 0.5,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ARView(),
                        SizedBox(
                          height: 20,
                        ),
                        SpecialPoojaComponent(),
                        SizedBox(
                          height: _bottomAppBarHeight,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Scaffold(
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Oops, it looks like your not connected to the internet 😕. \nPlease check your internet connection 👍.",
                          style: TextDesign.titleText,
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                          onPressed: () {
                            FlutterRestart.restartApp();
                          },
                          child: Text("Reload"),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
        ),
      ),
    );
  }

  Future<bool> _onBackPress() async {
    FocusScope.of(context).unfocus();
    bool yesorno = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Bye👋! See you Soon 😃", style: TextStyle(fontSize: 17)),
        content: Text("If you like to exit?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text("Yes"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text("No"),
          ),
        ],
      ),
    );
    if (yesorno) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }
}
