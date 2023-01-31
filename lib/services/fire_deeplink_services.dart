import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:loga_parameshwari/model/pooja.dart';
import 'package:loga_parameshwari/screens/detail_pooja_screen/detail_pooja_screen.dart';
import 'package:loga_parameshwari/services/database_manager.dart';

class Deeplink {
  // https://logaparameshwaritemple.page.link

  Future<String> createNewDeeplink(Pooja pooja) async {
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(
        "https://logaparameshwaritemple.page.link/pooja?id=${pooja.id}",
      ),
      uriPrefix: "https://logaparameshwaritemple.page.link",
      androidParameters: AndroidParameters(
        packageName: "com.sanjoke.loga_parameshwari",
        fallbackUrl: Uri.parse(
          "https://play.google.com/store/apps/details?id=com.sanjoke.loga_parameshwari",
        ),
      ),
    );
    final ShortDynamicLink dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

    return dynamicLink.shortUrl.toString();
  }

  Future<void> isLaunchByLink(BuildContext context) async {
    // App is background
    FirebaseDynamicLinks.instance.onLink
        .listen((PendingDynamicLinkData initialLink) async {
      final String id = initialLink.link.queryParameters['id'];
      DatabaseManager.getPoojaByID(id).then((Pooja pooja) {
        debugPrint("pooja ${pooja.toJson()}");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPooja(id: id, pooja: pooja),
          ),
        );
      });
    }).onError((error) {
      // Handle errors
      debugPrint("DEEPLINK ERROR ::: $error");
    });

    // App is terminated
    FirebaseDynamicLinks.instance
        .getInitialLink()
        .then((PendingDynamicLinkData initialLink) {
      if (initialLink != null) {
        final String id = initialLink.link.queryParameters['id'];
        DatabaseManager.getPoojaByID(id).then((Pooja pooja) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPooja(id: id, pooja: pooja),
            ),
          );
        });
      }
    }).onError((error, stackTrace) {
      // Handle errors
      debugPrint("DEEPLINK ERROR ::: $error");
    });
  }
}
