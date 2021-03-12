import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:loga_parameshwari/model/pooja.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailPooja extends StatefulWidget {
  //const
  DetailPooja({Key key, this.pooja, this.id}) : super(key: key);
  final Pooja pooja;
  final id;
  @override
  _DetailPoojaState createState() => _DetailPoojaState();
}

class _DetailPoojaState extends State<DetailPooja> {
  List images = [];

  List<Asset> upImages = <Asset>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          upImages = await MultiImagePicker.pickImages(
            maxImages: 500,
            enableCamera: true,
            materialOptions: MaterialOptions(
              actionBarTitle: "Upload Images",
              allViewTitle: "All Photos",
              useDetailsView: false,
            ),
          );

          var year = "${DateFormat("yyyy").format(widget.pooja.on.toDate())}";
          var month = "${DateFormat("MMMM").format(widget.pooja.on.toDate())}";
          Reference rootPath =
              FirebaseStorage.instance.ref().child(year).child(month);
          for (Asset imageFile in upImages) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                  title: Text(
                    "${imageFile.name} Uploading",
                    style: TextStyle(fontSize: 10),
                  ),
                  content: LinearProgressIndicator()),
            );
            String url = await rootPath
                .child('${widget.pooja.name}+${widget.id}')
                .child(imageFile.name)
                .putData((await imageFile.getByteData(quality: 70))
                    .buffer
                    .asUint8List())
                .then((v) => v.ref.getDownloadURL());
            FirebaseFirestore.instance
                .collection("Event")
                .doc(widget.id)
                .collection('Images')
                .doc('${imageFile.name}+${widget.id}')
                .set({'url': url});
            Navigator.pop(context);
          }
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Text(
              "${widget.pooja.name}",
              style: TextDesign.headText,
            ),
            Text(
              "by ${widget.pooja.by}",
              style: TextDesign.titleText,
            ),
            Text(
              "${DateFormat("dd-MM-yyyy (hh:mm aaa)").format(widget.pooja.on.toDate())}",
              style: TextDesign.subTitleText,
            ),
            Divider(),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Event")
                    .doc(widget.id)
                    .collection("Images")
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    images = snapshot.data.docs;
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
                            closedBuilder: (context, action) =>
                                CachedNetworkImage(
                              imageUrl: images[index]['url'],
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
                            openBuilder: (context, action) => ImageFullView(
                              url: images[index]['url'],
                            ),
                          );
                        },
                        staggeredTileBuilder: (int index) =>
                            new StaggeredTile.fit(2),
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageFullView extends StatefulWidget {
  const ImageFullView({Key key, this.url}) : super(key: key);
  final url;

  @override
  _ImageFullViewState createState() => _ImageFullViewState();
}

class _ImageFullViewState extends State<ImageFullView> {
  SharedPreferences pref;
  getVal() async {
    pref = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    getVal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          SharedPreferences.getInstance().then((pref) {
            if (pref.get(widget.url) != null && pref.get(widget.url) == true) {
              setState(() {
                pref.setBool(widget.url, false);
              });
            } else {
              setState(() {
                pref.setBool(widget.url, true);
              });
            }
          });
        },
        child: pref != null &&
                pref.get(widget.url) != null &&
                pref.get(widget.url) == true
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  Text("152")
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite,
                  ),
                  Text("152")
                ],
              ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Image Viewer",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                child: InteractiveViewer(
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: widget.url,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
