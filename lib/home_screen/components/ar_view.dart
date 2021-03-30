import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:loga_parameshwari/ar_full_view/ar_full_view.dart';
import 'package:loga_parameshwari/constant/constant.dart';

class ARView extends StatelessWidget {
  const ARView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.25,
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
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'images/temple_3d.gif',
                      fit: BoxFit.fill,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Temple 3D View"),
                    ),
                  ],
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
