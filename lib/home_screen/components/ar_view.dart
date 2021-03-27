import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:loga_parameshwari/ar_full_view/ar_full_view.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:model_viewer/model_viewer.dart';

class ARView extends StatelessWidget {
  const ARView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.2,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: CardContainer.borderRadius,
            border: Border.all(),
          ),
          child: ClipRRect(
            borderRadius: CardContainer.borderRadius,
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
                            src: 'images/temple.glb',
                            alt: "A 3D model of an loga parameshari temple",
                            autoRotate: true,
                          ),
                        ),
                        Text("Temple 3D View"),
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
        ),
      ),
    );
  }
}
