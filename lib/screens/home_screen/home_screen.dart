import 'package:flutter/material.dart';
import 'package:loga_parameshwari/screens/home_screen/components/ar_view.dart';
import 'package:loga_parameshwari/screens/home_screen/components/donate.dart';
import 'package:loga_parameshwari/screens/home_screen/components/head.dart';
import 'package:loga_parameshwari/screens/home_screen/components/home_keys.dart';
import 'package:loga_parameshwari/screens/home_screen/components/left_btn.dart';
import 'package:loga_parameshwari/screens/home_screen/components/logout.dart';
import 'package:loga_parameshwari/screens/home_screen/components/notice_banner.dart';
import 'package:loga_parameshwari/screens/home_screen/components/right_btn.dart';
import 'package:loga_parameshwari/screens/home_screen/components/special_pooja.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _bottomAppBarHeight = 50.0;
  final ScrollController _homeListController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: BottomAppBar(
        elevation: 0.3,
        notchMargin: 5,
        clipBehavior: Clip.antiAlias,
        color: const Color(0xff1c1f26),
        shape: const AutomaticNotchedShape(
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
              LeftBtn(),
              const Spacer(),
              const RightBtn(),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        onPressed: () {
          _homeListController.animateTo(
            0.0,
            duration: const Duration(seconds: 1),
            curve: Curves.ease,
          );
        },
        child: const Icon(Icons.home),
      ),
      body: WillPopScope(
        onWillPop: _onBackPress,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SizedBox(
              width: double.maxFinite,
              height: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ListView(
                      controller: _homeListController,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        const HeadComponent(),
                        const SizedBox(
                          height: 15,
                        ),
                        const NoticeBanner(),
                        const SizedBox(
                          height: 15,
                        ),
                        HomeKeysComponent(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight * 0.5,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const DonateBtn(),
                        const SizedBox(
                          height: 20,
                        ),
                        const ARView(),
                        const SizedBox(
                          height: 20,
                        ),
                        const SpecialPoojaComponent(),
                        const SizedBox(
                          height: 20,
                        ),
                        const LogoutBtn(),
                        SizedBox(
                          height: _bottomAppBarHeight,
                        ),
                      ],
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
    final bool yesorno = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Bye👋! See you Soon 😃",
          style: TextStyle(fontSize: 17),
        ),
        content: const Text("If you like to exit?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text("Yes"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("No"),
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
