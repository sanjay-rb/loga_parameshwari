import 'package:flutter/material.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class RecentPooja extends StatelessWidget {
  const RecentPooja({Key key}) : super(key: key);
  final CardContainer cc = const CardContainer();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: cc.borderRadius,
      ),
    );
  }
}

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
            color: Colors.black,
            borderRadius: cc.borderRadius,
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
            child: ClipRRect(
              borderRadius: cc.borderRadius,
              child: Image.network(
                iu.mapImg,
                fit: BoxFit.fill,
                isAntiAlias: true,
                loadingBuilder:
                    (BuildContext context, Widget child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes
                          : null,
                    ),
                  );
                },
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
            child: RecentPooja(),
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
