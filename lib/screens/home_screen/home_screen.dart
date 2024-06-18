import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:loga_parameshwari/model/user_model.dart';
import 'package:loga_parameshwari/screens/home_screen/components/ar_view.dart';
import 'package:loga_parameshwari/screens/home_screen/components/contact.dart';
import 'package:loga_parameshwari/screens/home_screen/components/donate.dart';
import 'package:loga_parameshwari/screens/home_screen/components/head.dart';
import 'package:loga_parameshwari/screens/home_screen/components/home_keys.dart';
import 'package:loga_parameshwari/screens/home_screen/components/logout.dart';
import 'package:loga_parameshwari/screens/home_screen/components/notice_banner.dart';
import 'package:loga_parameshwari/screens/home_screen/components/special_dates.dart';
import 'package:loga_parameshwari/screens/home_screen/components/special_pooja.dart';
import 'package:loga_parameshwari/screens/profile_screen.dart';
import 'package:loga_parameshwari/services/admob_services.dart';
import 'package:loga_parameshwari/services/connectivity_service.dart';
import 'package:loga_parameshwari/services/database_manager.dart';
import 'package:loga_parameshwari/services/fire_deeplink_services.dart';
import 'package:loga_parameshwari/services/fire_message_services.dart';
import 'package:loga_parameshwari/services/navigation_animation_services.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
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
    ]);
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    // AdmobService().loadAd();
    Provider.of<AdmobService>(context, listen: false).loadAd();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    final UserModel user =
        UserModel.fromJson((await DatabaseManager.getUserInfo()).docs.first);
    if (state == AppLifecycleState.paused) {
      user.isonline = false;
      DatabaseManager.addUser(user);
    } else if (state == AppLifecycleState.resumed) {
      user.isonline = true;
      DatabaseManager.addUser(user);
    }
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
    FirebaseMessaging.onMessage.listen(
      Messaging.backgroundAndTerminatedMessageHandler,
    );

    Messaging.androidPlugin
        .getNotificationAppLaunchDetails()
        .then((NotificationAppLaunchDetails value) {
      if (value.didNotificationLaunchApp) {
        Messaging.onSelectNotification(
          context,
          value.notificationResponse.payload,
        );
      }
    });

    Messaging.selectNotificationStream.stream.listen((String payload) async {
      Messaging.onSelectNotification(context, payload);
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
                  Navigator.pop(context, true);
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
        return true;
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
    return IsConnected(
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: const Text("Loga Parameshwari Thunai"),
          actions: [
            PopupMenuButton<String>(
              onSelected: (String value) {
                if (value == "Profile") {
                  Navigator.of(context).push(
                    NavigationAnimationService.fadePageRoute(
                      enterPage: const ProfileScreen(),
                    ),
                  );
                } else if (value == "Share") {
                  Share.share(
                    "Install Loga Parameshwari Temple Ramassery App \n\n - Get real-time updates of pooja. \n - Make your history with the temple by scheduled pooja. \n - Google map navigation to the temple. \n - Full architecture of temple by the 3D view. \n - Special pooja timetable. \n - And a lot more... \n\n https://play.google.com/store/apps/details?id=com.sanjoke.loga_parameshwari",
                  );
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: 'Profile',
                  child: Text('Profile'),
                ),
                const PopupMenuItem(
                  value: 'Share',
                  child: Text('Share'),
                ),
              ],
            )
          ],
        ),
        bottomNavigationBar: Consumer<AdmobService>(
          builder: (context, value, child) {
            if (value.isLoaded && value.bannerAd != null) {
              return SafeArea(
                child: SizedBox(
                  width: value.bannerAd.size.width.toDouble(),
                  height: value.bannerAd.size.height.toDouble(),
                  child: AdWidget(ad: value.bannerAd),
                ),
              );
            }
            return const SafeArea(
              child: SizedBox(
                width: 320,
                height: 50,
                child: Center(child: Text("Advertisements")),
              ), // 320x50
            );
          },
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
                          SpecialDatesComponent(
                            width: constraints.maxWidth,
                            height: constraints.maxHeight * 0.19,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ContactComponent(
                            height: constraints.maxHeight * 0.25,
                            width: constraints.maxWidth * 0.8,
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
      final UserModel user =
          UserModel.fromJson((await DatabaseManager.getUserInfo()).docs.first);
      user.isonline = false;
      DatabaseManager.addUser(user);
      return true;
    } else {
      return false;
    }
  }
}
