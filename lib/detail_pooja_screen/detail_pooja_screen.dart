import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:loga_parameshwari/model/pooja.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class DetailPooja extends StatefulWidget {
  //const
  DetailPooja({Key key, this.pooja}) : super(key: key);
  final Pooja pooja;

  @override
  _DetailPoojaState createState() => _DetailPoojaState();
}

class _DetailPoojaState extends State<DetailPooja> {
  final List<String> images = [
    "https://images-na.ssl-images-amazon.com/images/I/81aF3Ob-2KL._UX679_.jpg",
    "https://www.boostmobile.com/content/dam/boostmobile/en/products/phones/apple/iphone-7/silver/device-front.png.transform/pdpCarousel/image.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgUgs8_kmuhScsx-J01d8fA1mhlCR5-1jyvMYxqCB8h3LCqcgl9Q",
    "https://ae01.alicdn.com/kf/HTB11tA5aiAKL1JjSZFoq6ygCFXaw/Unlocked-Samsung-GALAXY-S2-I9100-Mobile-Phone-Android-Wi-Fi-GPS-8-0MP-camera-Core-4.jpg_640x640.jpg",
    "https://media.ed.edmunds-media.com/gmc/sierra-3500hd/2018/td/2018_gmc_sierra-3500hd_f34_td_411183_1600.jpg",
    "https://hips.hearstapps.com/amv-prod-cad-assets.s3.amazonaws.com/images/16q1/665019/2016-chevrolet-silverado-2500hd-high-country-diesel-test-review-car-and-driver-photo-665520-s-original.jpg",
    "https://www.galeanasvandykedodge.net/assets/stock/ColorMatched_01/White/640/cc_2018DOV170002_01_640/cc_2018DOV170002_01_640_PSC.jpg",
    "https://media.onthemarket.com/properties/6191869/797156548/composite.jpg",
    "https://media.onthemarket.com/properties/6191840/797152761/composite.jpg",
  ];

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
          setState(() {
            upImages = upImages;
          });
          print("HI THIS IS RESULE $upImages");
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
            (upImages.length != 0)
                ? Expanded(
                    child: StaggeredGridView.countBuilder(
                      crossAxisCount: 4,
                      itemCount: upImages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 10,
                          child: AssetThumb(
                            asset: upImages[index],
                            width: 500,
                            height: 500,
                          ),
                        );
                      },
                      staggeredTileBuilder: (int index) =>
                          new StaggeredTile.fit(2),
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                    ),
                  )
                : Expanded(
                    child: Center(
                    child: Text('Add Images by clicking below "+" button'),
                  )),
          ],
        ),
      ),
    );
  }
}
