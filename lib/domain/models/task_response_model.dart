class TasksResponseModel {
  List<IssuedToTheUser>? issuedToTheUser;

  TasksResponseModel({this.issuedToTheUser});

  TasksResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['issuedToTheUser'] != null) {
      issuedToTheUser = <IssuedToTheUser>[];
      json['issuedToTheUser'].forEach((v) {
        issuedToTheUser!.add(new IssuedToTheUser.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.issuedToTheUser != null) {
      data['issuedToTheUser'] =
          this.issuedToTheUser!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class IssuedToTheUser {
  int? id;
  String? date;
  String? taskName;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? userId;
  int? issuedById;

  IssuedToTheUser(
      {this.id,
        this.date,
        this.taskName,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.userId,
        this.issuedById});

  IssuedToTheUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    taskName = json['taskName'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userId = json['userId'];
    issuedById = json['issuedById'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['taskName'] = this.taskName;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['userId'] = this.userId;
    data['issuedById'] = this.issuedById;
    return data;
  }
}
