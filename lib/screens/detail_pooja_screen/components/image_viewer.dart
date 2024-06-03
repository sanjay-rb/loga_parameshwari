import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loga_parameshwari/model/image_model.dart';

class ImageFullView extends StatefulWidget {
  const ImageFullView({Key key, this.id, this.imageList}) : super(key: key);
  final int id;
  final List<QueryDocumentSnapshot<Object>> imageList;
  @override
  _ImageFullViewState createState() => _ImageFullViewState();
}

class _ImageFullViewState extends State<ImageFullView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
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
      ),
    );
  }
}

class ImagePageView extends StatefulWidget {
  const ImagePageView({Key key, this.root}) : super(key: key);
  final ImageFullView root;
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
          final ImageModel imageModel =
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
