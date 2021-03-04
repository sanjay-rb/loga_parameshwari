import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:loga_parameshwari/screens/add_pooja_screen.dart';
import 'package:loga_parameshwari/screens/history_screen/history_screen.dart';
import 'package:loga_parameshwari/screens/home_screen/components/map_view.dart';
import 'package:loga_parameshwari/screens/home_screen/components/recent_pooja.dart';

class AddPooja extends StatelessWidget {
  const AddPooja({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPoojaScreen(),
            ),
          );
        },
        child: ColoredBox(
          color: Colors.white,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: CardContainer.borderRadius,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: const [
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
      ),
    );
  }
}

class HistoryPooja extends StatelessWidget {
  const HistoryPooja({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HistoryScreen(),
            ),
          );
        },
        child: ColoredBox(
          color: Colors.white,
          child: DecoratedBox(
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
                              value: downloadProgress.progress,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Text("History")
                  ],
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
  const HomeKeysComponent({
    Key key,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 55,
            child: RecentPooja(key: GKey.recentPoojaKey),
          ),
          Expanded(
            flex: 45,
            child: Column(
              children: [
                Expanded(
                  child: AddPooja(
                    key: GKey.addPoojaKey,
                  ),
                ),
                Expanded(
                  child: HistoryPooja(
                    key: GKey.historyPoojaKey,
                  ),
                ),
                Expanded(
                  child: MapView(
                    key: GKey.mapViewKey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
