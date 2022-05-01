import 'package:flutter/material.dart';
import 'package:loga_parameshwari/model/pooja.dart';
import 'package:loga_parameshwari/screens/detail_pooja_screen/components/add_image_btn.dart';
import 'package:loga_parameshwari/screens/detail_pooja_screen/components/header_details.dart';
import 'package:loga_parameshwari/screens/detail_pooja_screen/components/image_grid_viewer.dart';

class DetailPooja extends StatelessWidget {
  final Pooja pooja;
  final String id;
  const DetailPooja({this.pooja, this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AddImageButton(pooja: pooja),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              HeaderDetails(pooja: pooja),
              const Text(
                "Double tap to like ❤️",
                style: TextStyle(fontSize: 10, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const Divider(),
              ImageGridViewer(id),
            ],
          ),
        ),
      ),
    );
  }
}
