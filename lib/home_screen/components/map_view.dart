import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class MapView extends StatelessWidget {
  const MapView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: GestureDetector(
          onTap: () async {
            if (await canLaunch(ImagesAndUrls.mapUrl)) {
              await launch(ImagesAndUrls.mapUrl);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: CardContainer.borderRadius,
              border: Border.all(),
            ),
            child: ClipRRect(
              borderRadius: CardContainer.borderRadius,
              child: CachedNetworkImage(
                imageUrl: ImagesAndUrls.mapImg,
                fit: BoxFit.fill,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child: CircularProgressIndicator(
                      value: downloadProgress.progress),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
