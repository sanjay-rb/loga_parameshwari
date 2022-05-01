// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/widgets.dart';

/// This Navigation Animation Service helps to navigate one page to another with cool native animations....
class NavigationAnimationService {
  /// This route animation will give cool fade in effect to entering page....
  static PageRouteBuilder fadePageRoute({Widget enterPage}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => enterPage,
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
        child: enterPage,
      ),
    );
  }

  /// This route animation will give left to right effect....
  ///  - Exit page move to left....
  ///  - Enter page comes from right....
  static PageRouteBuilder leftToRightPageRoute({
    Widget enterPage,
    Widget exitPage,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => enterPage,
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          Stack(
        children: <Widget>[
          SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(-1.0, 0.0),
            ).animate(animation),
            child: exitPage,
          ),
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: enterPage,
          )
        ],
      ),
    );
  }

  /// This route animation will give right to left effect....
  ///  - Exit page move to right....
  ///  - Enter page comes from left....
  static PageRouteBuilder rightToLeftPageRoute({
    Widget enterPage,
    Widget exitPage,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => enterPage,
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          Stack(
        children: <Widget>[
          SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(1.0, 0.0),
            ).animate(animation),
            child: exitPage,
          ),
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: enterPage,
          )
        ],
      ),
    );
  }
}
