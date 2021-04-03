import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:model_viewer/model_viewer.dart';

class ARFullView extends StatefulWidget {
  @override
  _ARFullViewState createState() => _ARFullViewState();
}

class _ARFullViewState extends State<ARFullView> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitDown,
        ]);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
        body: SafeArea(
          child: ModelViewer(
            backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
            src: ImagesAndUrls.glb3D,
            alt: "A 3D model of an loga parameshari temple",
            autoRotate: true,
            cameraControls: true,
            ar: true,
          ),
        ),
      ),
    );
  }
}
