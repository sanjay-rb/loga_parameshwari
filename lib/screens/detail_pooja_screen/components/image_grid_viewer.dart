import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './image_viewer.dart';

class ImageGridViewer extends StatelessWidget {
  final id;
  const ImageGridViewer(this.id);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Event")
            .doc(id)
            .collection("Images")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List images = snapshot.data.docs;
            if (images.length == 0) {
              return Center(
                child: Text('Add Images by clicking below "+" button'),
              );
            } else {
              return StaggeredGridView.countBuilder(
                crossAxisCount: 4,
                itemCount: images.length,
                itemBuilder: (BuildContext context, int index) {
                  return OpenContainer(
                    closedBuilder: (context, action) => Stack(
                      fit: StackFit.loose,
                      children: [
                        CachedNetworkImage(
                          imageUrl: images[index]['url'],
                          progressIndicatorBuilder: (context, url, progress) =>
                              Container(
                            width: 150,
                            height: 150,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: progress.progress,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 1,
                          right: 1,
                          child: FutureBuilder(
                            future: SharedPreferences.getInstance().then(
                                (value) => value.get(images[index]['url'])),
                            builder: (context, snapshot) {
                              if (snapshot.data == true) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    openBuilder: (context, action) => ImageFullView(
                      url: images[index]['url'],
                    ),
                  );
                },
                staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              );
            }
          }
        },
      ),
    );
  }
}
