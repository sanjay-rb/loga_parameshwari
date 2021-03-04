import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loga_parameshwari/constant/constant.dart';

class RecentPooja extends StatelessWidget {
  const RecentPooja({Key key}) : super(key: key);
  final CardContainer cc = const CardContainer();
  final ImagesAndUrls iu = const ImagesAndUrls();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: cc.borderRadius,
      ),
      child: Column(
        children: [
          Expanded(
            flex: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              height: 50,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    "Lorem Ipsumsajcvhbalcbsdjhckjbsdhckvdsb",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.amber,
              ),
              height: 50,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    "20-feb-2021",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 60,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Opacity(
                  opacity: 0.5,
                  child: Container(
                    color: Colors.black,
                    child: CachedNetworkImage(
                      imageUrl: iu.godImg,
                      fit: BoxFit.fill,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress),
                      ),
                    ),
                    /**
                     * Image.network(
                      iu.godImg,
                      fit: BoxFit.fill,
                      isAntiAlias: true,
                      loadingBuilder: (BuildContext context, Widget child,
                          loadingProgress) {
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
                     */
                  ),
                ),
                Container(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: SingleChildScrollView(
                        child: Text(
                          "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...There is no one who loves pain itself, who seeks after it and wants to have it, simply because it is pain...Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...There is no one who loves pain itself, who seeks after it and wants to have it, simply because it is pain...",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 15,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              height: 50,
              child: Center(
                child: Text(
                  "Click to View",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
