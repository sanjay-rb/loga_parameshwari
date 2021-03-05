import 'package:flutter/material.dart';
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
              child: Column(
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/**
 * Container(
              child: Column(
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: Placeholder(),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [heading, greeting],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        color: Colors.green,
                        elevation: 5,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: MediaQuery.of(context).size.height * 0.35,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  child: RaisedButton(
                                    onPressed: () {},
                                    child: Text("Add Pooja/Event"),
                                  ),
                                  width: double.maxFinite,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: double.maxFinite,
                                  child: RaisedButton(
                                    onPressed: () {},
                                    child: Text("History"),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
 */
