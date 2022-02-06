import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loga_parameshwari/model/image.dart';

class ImageFullView extends StatefulWidget {
  const ImageFullView({Key key, this.id, this.imageList}) : super(key: key);
  final int id;
  final List imageList;
  @override
  _ImageFullViewState createState() => _ImageFullViewState();
}

class _ImageFullViewState extends State<ImageFullView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Image Viewer",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ImagePageView(root: widget),
            ),
          ],
        ),
      ),
    );
  }
}

class ImagePageView extends StatefulWidget {
  const ImagePageView({Key key, this.root}) : super(key: key);
  final root;
  @override
  State<ImagePageView> createState() => _ImagePageViewState();
}

class _ImagePageViewState extends State<ImagePageView> {
  PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: widget.root.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      children: List.generate(
        widget.root.imageList.length,
        (index) {
          ImageModel imageModel =
              ImageModel.fromJson(widget.root.imageList[index]);
          return InteractiveViewer(
            child: Center(
              child: CachedNetworkImage(
                imageUrl: imageModel.url,
                filterQuality: FilterQuality.high,
                fit: BoxFit.fill,
              ),
            ),
          );
        },
      ),
    );
  }
}
