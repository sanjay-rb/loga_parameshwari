import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

import '../../detail_pooja_screen/detail_pooja_screen.dart';
import '../../../model/pooja.dart';
import '../../../constant/constant.dart';

class LeafCard extends StatelessWidget {
  const LeafCard({
    Key key,
    @required this.pooja,
    @required this.id,
  }) : super(key: key);

  final Pooja pooja;
  final id;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 40,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onLongPress: () {
            Share.share(TextDesign.getMessageText(pooja));
          },
          child: OpenContainer(
            closedBuilder: (context, action) => Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${pooja.name}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "by ${pooja.by}",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            openBuilder: (context, action) => DetailPooja(
              pooja: pooja,
              id: this.id,
            ),
          ),
        ),
      ),
    );
  }
}
