class BlogsResponseModel {
  int? status;
  List<Data>? data;

  BlogsResponseModel({this.status, this.data});

  BlogsResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? title;
  String? picture;
  String? content;
  String? createdAt;
  String? updatedAt;
  String? authorName;
  int? userId;
  String? region;

  Data(
      {this.id,
        this.title,
        this.picture,
        this.content,
        this.createdAt,
        this.updatedAt,
        this.authorName,
        this.userId,
        this.region});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    picture = json['picture'];
    content = json['content'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    authorName = json['authorName'];
    userId = json['userId'];
    region = json['region'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['picture'] = this.picture;
    data['content'] = this.content;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['authorName'] = this.authorName;
    data['userId'] = this.userId;
    data['region'] = this.region;
    return data;
  }
}
