import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:loga_parameshwari/model/pooja.dart';
import 'package:loga_parameshwari/screens/detail_pooja_screen/detail_pooja_screen.dart';
import 'package:share/share.dart';

class LeafCard extends StatelessWidget {
  const LeafCard({
    Key key,
    @required this.pooja,
    @required this.id,
  }) : super(key: key);

  final Pooja pooja;
  final String id;

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
            closedBuilder: (context, action) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    pooja.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "by ${pooja.by.replaceAll('\n', ', ')}",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            openBuilder: (context, action) => DetailPooja(
              pooja: pooja,
              id: id,
            ),
          ),
        ),
      ),
    );
  }
}
