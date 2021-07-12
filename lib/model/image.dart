class ImageModel {
  String id;
  String pooja;
  String user;
  String url;
  List like;

  ImageModel({this.id, this.pooja, this.user, this.url, this.like});

  ImageModel.fromJson(json) {
    this.id = json['id'];
    this.pooja = json['pooja'];
    this.user = json['user'];
    this.url = json['url'];
    this.like = json['like'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'pooja': this.pooja,
      'user': this.user,
      'url': this.url,
      'like': this.like,
    };
  }
}
