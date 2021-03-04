import 'package:flutter/material.dart';

class HomeAdComponent extends StatelessWidget {
  final double width;
  final double height;
  HomeAdComponent({Key key, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
    );
  }
}
