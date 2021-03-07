import 'package:flutter/material.dart';
import 'components/special_pooja.dart';
import 'components/head.dart';
import 'components/home_ad.dart';
import 'components/home_keys.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) => Container(
            width: double.maxFinite,
            height: double.maxFinite,
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    HomeAdComponent(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight * 0.05,
                    ),
                    HeadComponent(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight * 0.1,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    HomeKeysComponent(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight * 0.5,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SpecialPoojaComponent(),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
