import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loga_parameshwari/add_pooja_screen/add_pooja_screen.dart';
import 'package:loga_parameshwari/ar_full_view/ar_full_view.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:loga_parameshwari/history_screen/history_screen.dart';
import 'package:model_viewer/model_viewer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'recent_pooja.dart';

class AddPooja extends StatelessWidget {
  const AddPooja({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: OpenContainer(
          closedBuilder: (context, action) => Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: CardContainer.borderRadius,
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
          openBuilder: (context, action) => AddPoojaScreen(),
          closedShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
      ),
    );
  }
}

class HistoryPooja extends StatelessWidget {
  const HistoryPooja({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: OpenContainer(
          closedBuilder: (context, action) => Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: CardContainer.borderRadius,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CachedNetworkImage(
                          imageUrl: ImagesAndUrls.historyImg,
                          fit: BoxFit.contain,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress),
                          ),
                        ),
                      ),
                    ),
                    Text("History")
                  ],
                ),
              ),
            ),
          ),
          openBuilder: (context, action) => HistoryScreen(),
          closedShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
      ),
    );
  }
}

class ARView extends StatelessWidget {
  const ARView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: OpenContainer(
          closedBuilder: (context, action) => Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: CardContainer.borderRadius,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ModelViewer(
                        backgroundColor: Colors.white,
                        src: 'images/3d_sullam.glb',
                        alt: "A 3D model of an astronaut",
                        autoRotate: true,
                      ),
                    ),
                    Text("AR Logo")
                  ],
                ),
              ),
            ),
          ),
          openBuilder: (context, action) => ARFullView(),
          closedShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
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
            child: RecentPooja(),
          ),
          Expanded(
            flex: 45,
            child: Container(
              child: Column(
                children: [
                  Expanded(child: AddPooja()),
                  Expanded(child: HistoryPooja()),
                  Expanded(child: ARView()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
