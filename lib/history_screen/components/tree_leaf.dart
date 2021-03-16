import 'package:flutter/material.dart';
import 'package:loga_parameshwari/model/pooja.dart';

import 'leaf_card.dart';
import 'leaf_date.dart';

class TreeLeaf extends StatelessWidget {
  const TreeLeaf({
    Key key,
    @required this.pooja,
    @required this.index,
    @required this.id,
  }) : super(key: key);

  final Pooja pooja;
  final int index;
  final id;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 100,
      child: Stack(
        children: [
          Row(
            children: index % 2 == 0
                ? [
                    LeafCard(pooja: pooja, id: this.id),
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
                    LeafCard(pooja: pooja, id: this.id),
                  ],
          ),
          Center(
            child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
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
