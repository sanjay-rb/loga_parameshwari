import 'package:flutter/material.dart';
import 'package:loga_parameshwari/home_screen/components/map_view.dart';
// import 'components/btn_ad.dart';
// import 'components/home_ad.dart';
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
          child: LayoutBuilder(
            builder: (context, constraints) => Container(
              width: double.maxFinite,
              height: double.maxFinite,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: ListView(
                  controller: _homeListController,
                  children: [
                    // HomeAdComponent(),
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
                    MapView(),
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
        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Bye👋! See you Soon 😃",
            style: TextStyle(fontSize: 17),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("If you like to exit?"),
              ),
            ),
            // BackBtnAdComponent(),
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
