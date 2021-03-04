import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:url_launcher/url_launcher.dart';

import 'recent_pooja.dart';

class AddPooja extends StatelessWidget {
  const AddPooja({Key key}) : super(key: key);
  final CardContainer cc = const CardContainer();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: cc.borderRadius,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Expanded(
                    child: Icon(Icons.add, size: 50),
                  ),
                  Text("Schedule Pooja")
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HistoryPooja extends StatelessWidget {
  const HistoryPooja({Key key}) : super(key: key);
  final CardContainer cc = const CardContainer();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: cc.borderRadius,
          ),
        ),
      ),
    );
  }
}

class MapView extends StatelessWidget {
  const MapView({Key key}) : super(key: key);
  final CardContainer cc = const CardContainer();
  final ImagesAndUrls iu = const ImagesAndUrls();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: GestureDetector(
          onTap: () async {
            if (await canLaunch(iu.mapUrl)) {
              await launch(iu.mapUrl);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: cc.borderRadius,
              border: Border.all(),
            ),
            child: ClipRRect(
              borderRadius: cc.borderRadius,
              child: CachedNetworkImage(
                imageUrl: iu.mapImg,
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

class HomeKeysComponent extends StatelessWidget {
  final double width;
  final double height;
  const HomeKeysComponent({Key key, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 55,
            child: OpenContainer(
              closedColor: Colors.amber,
              closedElevation: 5.0,
              closedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              transitionType: ContainerTransitionType.fade,
              transitionDuration: const Duration(milliseconds: 500),
              openBuilder: (context, action) {
                return const Scaffold();
              },
              closedBuilder: (context, action) {
                return RecentPooja();
              },
            ),
          ),
          Expanded(
            flex: 45,
            child: Container(
              child: Column(
                children: [
                  Expanded(child: AddPooja()),
                  Expanded(child: HistoryPooja()),
                  Expanded(child: MapView()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
