import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loga_parameshwari/model/image.dart';
import 'package:loga_parameshwari/services/auth_services.dart';
import 'package:loga_parameshwari/services/database_manager.dart';
import './image_viewer.dart';

class ImageGridViewer extends StatelessWidget {
  final id;
  const ImageGridViewer(this.id);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: DatabaseManager.getImageStreamFromPoojaId(id),
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
                  ImageModel imageModel = ImageModel.fromJson(images[index]);
                  return GestureDetector(
                    onDoubleTap: () {
                      if (imageModel.like
                          .contains(AuthService.getUserNumber())) {
                        DatabaseManager.unLikeImage(imageModel);
                      } else {
                        DatabaseManager.likeImage(imageModel);
                      }
                    },
                    child: OpenContainer(
                      closedBuilder: (context, action) => Stack(
                        fit: StackFit.loose,
                        children: [
                          CachedNetworkImage(
                            imageUrl: imageModel.url,
                            progressIndicatorBuilder:
                                (context, url, progress) => Container(
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
                            left: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Icon(
                                      imageModel.like.contains(
                                              AuthService.getUserNumber())
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Text(
                                      "${imageModel.like.length}",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      openBuilder: (context, action) => ImageFullView(
                        id: imageModel.id,
                      ),
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
