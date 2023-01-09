import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loga_parameshwari/model/image.dart';
import 'package:loga_parameshwari/model/user.dart';
import 'package:loga_parameshwari/screens/detail_pooja_screen/components/image_viewer.dart';
import 'package:loga_parameshwari/services/auth_services.dart';
import 'package:loga_parameshwari/services/database_manager.dart';

class ImageGridViewer extends StatelessWidget {
  final String id;
  const ImageGridViewer(this.id);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: DatabaseManager.getImageStreamFromPoojaId(id),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final List<QueryDocumentSnapshot<Object>> images =
                snapshot.data.docs;
            if (images.isEmpty) {
              return const Center(
                child: Text('Add Images by clicking below "+" button'),
              );
            } else {
              return StaggeredGridView.countBuilder(
                crossAxisCount: 4,
                itemCount: images.length,
                itemBuilder: (BuildContext context, int index) {
                  final ImageModel imageModel =
                      ImageModel.fromJson(images[index]);
                  return GestureDetector(
                    onDoubleTap: () {
                      if (imageModel.like
                          .contains(AuthService.getUserNumber())) {
                        DatabaseManager.unLikeImage(imageModel);
                      } else {
                        DatabaseManager.likeImage(imageModel);
                      }
                    },
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageFullView(
                                  id: index,
                                  imageList: images,
                                ),
                              ),
                            );
                          },
                          child: ColoredBox(
                            color: Colors.white,
                            child: CachedNetworkImage(
                              imageUrl: imageModel.url,
                              progressIndicatorBuilder:
                                  (context, url, progress) => SizedBox(
                                width: 150,
                                height: 150,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: progress.progress,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 1,
                          child: ColoredBox(
                            color: Colors.black38,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  bottomSheet(context, imageModel);
                                },
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Icon(
                                        imageModel.like.contains(
                                          AuthService.getUserNumber(),
                                        )
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
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                staggeredTileBuilder: (int index) => const StaggeredTile.fit(2),
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

void bottomSheet(BuildContext context, ImageModel imageModel) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        maxChildSize: 0.70,
        minChildSize: 0.50,
        builder: (context, scrollController) => Column(
          children: [
            ClipOval(
              child: Material(
                color: Colors.black,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: imageModel.like.length,
                    itemBuilder: (context, i) => FutureBuilder<QuerySnapshot>(
                      future: DatabaseManager.getUserInfoById(
                        imageModel.like[i] as String,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        }
                        final QuerySnapshot data = snapshot.data;
                        if (data.docs.length == 1) {
                          final UserModel liked = UserModel.fromJson(
                            data.docs.first,
                          );
                          return ListTile(
                            leading: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 25,
                            ),
                            title: Text(
                              liked.name,
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
