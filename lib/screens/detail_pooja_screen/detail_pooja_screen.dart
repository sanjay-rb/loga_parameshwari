import 'package:flutter/material.dart';
import 'package:loga_parameshwari/model/pooja_model.dart';
import 'package:loga_parameshwari/screens/detail_pooja_screen/components/add_image_btn.dart';
import 'package:loga_parameshwari/screens/detail_pooja_screen/components/header_details.dart';
import 'package:loga_parameshwari/screens/detail_pooja_screen/components/image_grid_viewer.dart';
import 'package:loga_parameshwari/services/connectivity_service.dart';

class DetailPooja extends StatelessWidget {
  final PoojaModel pooja;
  final String id;
  const DetailPooja({this.pooja, this.id});
  @override
  Widget build(BuildContext context) {
    return IsConnected(
      child: Scaffold(
        floatingActionButton: AddImageButton(pooja: pooja),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                HeaderDetails(pooja: pooja),
                const Text(
                  "Double tap to like ❤️ | Click on like ❤️ to view",
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const Divider(),
                ImageGridViewer(id),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
