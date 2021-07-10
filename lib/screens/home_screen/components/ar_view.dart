import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../constant/constant.dart';

class ARView extends StatelessWidget {
  const ARView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.25,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: CardContainer.borderRadius,
            border: Border.all(),
          ),
          child: ClipRRect(
            borderRadius: CardContainer.borderRadius,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: CardContainer.borderRadius,
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: ImagesAndUrls.gif3D,
                    fit: BoxFit.fill,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Temple 3D View"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}