import 'package:flutter/material.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:loga_parameshwari/model/pooja_model.dart';
import 'package:loga_parameshwari/screens/detail_pooja_screen/detail_pooja_screen.dart';
import 'package:loga_parameshwari/services/fire_deeplink_services.dart';
import 'package:share/share.dart';

class LeafCard extends StatelessWidget {
  const LeafCard({
    Key key,
    @required this.pooja,
    @required this.id,
  }) : super(key: key);

  final PoojaModel pooja;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 40,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onLongPress: () async {
            final String link = await Deeplink().createNewDeeplink(pooja);
            Share.share(TextDesign.getMessageText(pooja, link));
          },
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPooja(
                    pooja: pooja,
                    id: id,
                  ),
                ),
              );
            },
            child: ColoredBox(
              color: Colors.white,
              child: Column(
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
            ),
          ),
        ),
      ),
    );
  }
}
