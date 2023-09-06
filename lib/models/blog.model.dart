class BlogModel {
  String sId = "";
  Author author = Author(sId: "", name: "", surname: "", username: "");
  String image = "";
  String title = "";
  String description = "";
  String createdAt = "";
  int iV = 0;

  BlogModel(
      {required this.sId,
      required this.author,
      required this.image,
      required this.title,
      required this.description,
      required this.createdAt,
      required this.iV});

  BlogModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['author'] != null) {
      author = Author.fromJson(json['author']);
    } else {
      author = "" as Author;
    }
    image = json['image'];
    title = json['title'];
    description = json['description'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (author != null) {
      data['author'] = author!.toJson();
    }
    data['image'] = image;
    data['title'] = title;
    data['description'] = description;
    data['createdAt'] = createdAt;
    data['__v'] = iV;
    return data;
  }
}

class Author {
  String sId = "";
  String name = "";
  String surname = "";
  String username = "";

  Author({
    required this.sId,
    required this.name,
    required this.surname,
    required this.username,
  });

  Author.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    surname = json['surname'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['surname'] = surname;
    data['username'] = username;
    return data;
  }
}
