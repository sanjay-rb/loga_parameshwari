import 'package:flutter/material.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:model_viewer/model_viewer.dart';

class ARFullView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Temple AR View",
                style: TextDesign.headText,
                textAlign: TextAlign.right,
              ),
            ),
            Expanded(
              child: ModelViewer(
                backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
                src: 'images/3d_sullam.glb',
                alt: "A 3D model of an astronaut",
                autoRotate: true,
                cameraControls: true,
                ar: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
