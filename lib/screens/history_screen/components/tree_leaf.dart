import 'package:flutter/material.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:loga_parameshwari/model/pooja.dart';
import 'package:loga_parameshwari/screens/history_screen/components/leaf_card.dart';
import 'package:loga_parameshwari/screens/history_screen/components/leaf_date.dart';

class TreeLeaf extends StatelessWidget {
  const TreeLeaf({
    Key key,
    @required this.pooja,
    @required this.index,
    @required this.id,
  }) : super(key: key);

  final Pooja pooja;
  final int index;
  final String id;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 100,
      child: Stack(
        children: [
          Row(
            children: index.isEven
                ? [
                    LeafCard(
                      pooja: pooja,
                      id: id,
                      key: index == 0 ? GKey.leafKey : GlobalKey(),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        color: Colors.purple,
                      ),
                    ),
                    LeafDate(pooja: pooja),
                  ]
                : [
                    LeafDate(pooja: pooja),
                    Expanded(
                      flex: 2,
                      child: Container(
                        color: Colors.purple,
                      ),
                    ),
                    LeafCard(
                      pooja: pooja,
                      id: id,
                      key: index == 0 ? GKey.leafKey : GlobalKey(),
                    ),
                  ],
          ),
          Center(
            child: Container(
              width: 15,
              height: 15,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
