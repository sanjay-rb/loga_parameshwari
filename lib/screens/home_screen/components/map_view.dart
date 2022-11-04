import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MapView extends StatelessWidget {
  const MapView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () async {
          if (await canLaunchUrlString(ImagesAndUrls.mapUrl)) {
            await launchUrlString(ImagesAndUrls.mapUrl);
          }
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: CardContainer.borderRadius,
            border: Border.all(),
          ),
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: ClipRRect(
              borderRadius: CardContainer.borderRadius,
              child: CachedNetworkImage(
                imageUrl: ImagesAndUrls.mapImg,
                fit: BoxFit.fill,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child: CircularProgressIndicator(
                    value: downloadProgress.progress,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
