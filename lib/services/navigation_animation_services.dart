import 'package:flutter/widgets.dart';

/// This Navigation Animation Service helps to navigate one page to another with cool native animations....
class NavigationAnimationService {
  /// This route animation will give cool fade in effect to entering page....
  PageRouteBuilder fadePageRoute({Widget enterPage}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => enterPage,
      transitionDuration: Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(
        opacity: new Tween<double>(begin: 0.0, end: 1.0).animate(animation),
        child: enterPage,
      ),
    );
  }

  /// This route animation will give left to right effect....
  ///  - Exit page move to left....
  ///  - Enter page comes from right....
  PageRouteBuilder leftToRightPageRoute({Widget enterPage, Widget exitPage}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => enterPage,
      transitionDuration: Duration(milliseconds: 400),
      reverseTransitionDuration: Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          Stack(
        children: <Widget>[
          SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(0, 0),
              end: const Offset(-1.0, 0.0),
            ).animate(animation),
            child: exitPage,
          ),
          SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: enterPage,
          )
        ],
      ),
    );
  }
}
