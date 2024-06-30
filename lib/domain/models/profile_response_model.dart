class ProfileResponseModel {
  int? id;
  String? name;
  int? age;
  String? birthday;
  String? location;
  String? gender;
  String? email;
  String? contact;
  String? picture;
  String? position;
  String? createdAt;
  String? updatedAt;

  ProfileResponseModel(
      {this.id,
        this.name,
        this.age,
        this.birthday,
        this.location,
        this.gender,
        this.email,
        this.contact,
        this.picture,
        this.position,
        this.createdAt,
        this.updatedAt});

  ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    age = json['age'];
    birthday = json['birthday'];
    location = json['location'];
    gender = json['gender'];
    email = json['email'];
    contact = json['contact'];
    picture = json['picture'];
    position = json['position'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['age'] = this.age;
    data['birthday'] = this.birthday;
    data['location'] = this.location;
    data['gender'] = this.gender;
    data['email'] = this.email;
    data['contact'] = this.contact;
    data['picture'] = this.picture;
    data['position'] = this.position;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
