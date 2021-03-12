import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:loga_parameshwari/model/pooja.dart';
import 'package:share/share.dart';

class HeaderDetails extends StatelessWidget {
  const HeaderDetails({
    Key key,
    this.pooja,
  }) : super(key: key);

  final Pooja pooja;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "${pooja.name}",
          style: TextDesign.headText,
        ),
        Text(
          "by ${pooja.by}",
          style: TextDesign.titleText,
        ),
        Text(
          "${DateFormat("dd-MM-yyyy (hh:mm aaa)").format(pooja.on.toDate())}",
          style: TextDesign.subTitleText,
        ),
        Row(
          children: [
            Spacer(),
            TextButton.icon(
              onPressed: () {
                Share.share(TextDesign.getMessageText(pooja));
              },
              icon: Icon(Icons.share),
              label: Text("Share"),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
