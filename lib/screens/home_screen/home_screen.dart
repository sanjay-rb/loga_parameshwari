import 'package:flutter/material.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:loga_parameshwari/screens/home_screen/components/ar_view.dart';
import 'package:loga_parameshwari/screens/home_screen/components/donate.dart';
import 'package:loga_parameshwari/screens/home_screen/components/head.dart';
import 'package:loga_parameshwari/screens/home_screen/components/home_keys.dart';
import 'package:loga_parameshwari/screens/home_screen/components/left_btn.dart';
import 'package:loga_parameshwari/screens/home_screen/components/logout.dart';
import 'package:loga_parameshwari/screens/home_screen/components/notice_banner.dart';
import 'package:loga_parameshwari/screens/home_screen/components/right_btn.dart';
import 'package:loga_parameshwari/screens/home_screen/components/special_pooja.dart';
import 'package:loga_parameshwari/services/fire_deeplink_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = [];
  final _bottomAppBarHeight = 50.0;
  final ScrollController _homeListController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    targets.addAll([
      targetFocus(
        "Upcoming Pooja",
        GKey.recentPoojaKey,
        "Check out upcoming pooja here!",
        isCircle: false,
      ),
      targetFocus(
        "Schedule New Pooja",
        GKey.addPoojaKey,
        "Click here to schedule your pooja!",
      ),
      targetFocus(
        "History Pooja",
        GKey.historyPoojaKey,
        "Click here to know history of Loga Parameshwari Temple.",
      ),
      targetFocus(
        "Map View",
        GKey.mapViewKey,
        "Click here! Start navigation to Loga Parameshwari Temple.",
      ),
      targetFocus(
        "Donation",
        GKey.donationBtnKey,
        "Click here to find donation information of temple.",
        isCircle: false,
        isTextUp: true,
      ),
    ]);
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  TargetFocus targetFocus(
    String identify,
    GlobalKey key,
    String text, {
    bool isCircle = true,
    bool isTextUp = false,
  }) {
    return TargetFocus(
      identify: identify,
      keyTarget: key,
      shape: isCircle ? ShapeLightFocus.Circle : ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: isTextUp ? ContentAlign.top : ContentAlign.bottom,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              children: [
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    tutorialCoachMark.next();
                  },
                  child: const Text("Next"),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _afterLayout(_) {
    SharedPreferences.getInstance().then((value) {
      final bool canTutorial = value.getBool(SHARE_PREF_TUTORIAL);
      if (canTutorial == null || canTutorial) {
        Future.delayed(const Duration(seconds: 1), () {
          showTutorial();
        });
      } else {
        Deeplink().isLaunchByLink(context);
      }
    });
  }

  void showTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      onSkip: () {
        showDialog(
          context: context,
          builder: (c) => AlertDialog(
            title: const Text("Welcome to\nLoga Parameshwari Temple App"),
            content: const Text(
              "You can turn off app tutorial at\nProfile -> Turn off Tutorial",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              )
            ],
          ),
        );
      },
      onFinish: () {
        showDialog(
          context: context,
          builder: (c) => AlertDialog(
            title: const Text("Welcome to\nLoga Parameshwari Temple App"),
            content: const Text(
              "You can turn off app tutorial at\nProfile -> Turn off Tutorial",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              )
            ],
          ),
        );
        Deeplink().isLaunchByLink(context);
      },
    )..show(context: context);
  }

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
            children: const [
              LeftBtn(),
              Spacer(),
              RightBtn(),
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
                        DonateBtn(
                          key: GKey.donationBtnKey,
                        ),
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
    if (tutorialCoachMark != null && tutorialCoachMark.isShowing) {
      tutorialCoachMark.finish();
      return false;
    }
    final bool yesOrNo = await showDialog(
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
    if (yesOrNo) {
      return true;
    } else {
      return false;
    }
  }
}
