import 'dart:convert' as convert;
import 'dart:convert';
import 'package:http/http.dart' as http;

class CreateBlogModel {
  String title = "";
  String description = "";
  String image = "";
  String author = "";

  CreateBlogModel({
    required this.title,
    required this.description,
    required this.image,
    required this.author,
  });

  CreateBlogModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    image = json['image'];
    author = json['author'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['image'] = image;
    data['author'] = author;
    return data;
  }
}

class BlogService {
  get(path) async {
    var client = http.Client();
    try {
      var response = await client.get(Uri.parse(path));
      if (response.statusCode == 200) {
        return convert.jsonDecode(response.body);
      }
      return null;
    } catch (error) {
      return null;
    } finally {
      client.close();
    }
  }

  post(path, data) async {
    var encodeData = jsonEncode(data);
    var client = http.Client();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      var response = await client.post(Uri.parse(path),
          body: encodeData, headers: requestHeaders);
      if (response.statusCode == 200) {
        return convert.jsonDecode(response.body);
      }
      return null;
    } catch (error) {
      print(error);
    } finally {
      client.close();
    }
  }
}
