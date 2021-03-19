import 'package:flutter/material.dart';
import 'components/btn_ad.dart';
import 'components/home_ad.dart';
import 'components/share_app.dart';
import 'components/special_pooja.dart';
import 'components/head.dart';
import 'components/home_keys.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: _onBackPress,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => Container(
              width: double.maxFinite,
              height: double.maxFinite,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    HomeAdComponent(),
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
                    SpecialPoojaComponent(),
                    ShareApp(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPress() async {
    FocusScope.of(context).unfocus();
    bool yesorno = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Bye👋! See you Soon 😃",
          style: TextStyle(fontSize: 17),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text("If you like to exit?"),
            ),
            BackBtnAdComponent(),
          ],
        ),
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
