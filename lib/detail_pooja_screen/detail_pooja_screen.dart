import 'package:flutter/material.dart';
import 'package:loga_parameshwari/model/pooja.dart';

import 'components/add_image_btn.dart';
import 'components/header_details.dart';
import 'components/image_grid_viewer.dart';

class DetailPooja extends StatelessWidget {
  final Pooja pooja;
  final id;
  const DetailPooja({this.pooja, this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AddImageButton(pooja: pooja, id: id),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              HeaderDetails(pooja: pooja, id: id),
              Divider(),
              ImageGridViewer(id),
            ],
          ),
        ),
      ),
    );
  }
}
