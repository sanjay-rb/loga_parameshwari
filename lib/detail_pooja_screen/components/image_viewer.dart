import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageFullView extends StatefulWidget {
  const ImageFullView({Key key, this.url}) : super(key: key);
  final url;

  @override
  _ImageFullViewState createState() => _ImageFullViewState();
}

class _ImageFullViewState extends State<ImageFullView> {
  SharedPreferences pref;
  getVal() async {
    pref = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    getVal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          SharedPreferences.getInstance().then((pref) {
            if (pref.get(widget.url) != null && pref.get(widget.url) == true) {
              setState(() {
                pref.setBool(widget.url, false);
              });
            } else {
              setState(() {
                pref.setBool(widget.url, true);
              });
            }
          });
        },
        child: pref != null &&
                pref.get(widget.url) != null &&
                pref.get(widget.url) == true
            ? Icon(
                Icons.favorite,
                color: Colors.red,
              )
            : Icon(
                Icons.favorite,
              ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Image Viewer",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                child: InteractiveViewer(
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: widget.url,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
