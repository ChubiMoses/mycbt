import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class HideContentService {
  late SharedPreferences sharedPreferences;

//get all hidden content
  Future<List<Content>> getHiddenContent() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final jsonString = sharedPreferences.getString("content") ?? '[]';
    final jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((eachItem) => Content.fromJson(eachItem as Map<String, dynamic>),).toList();
  }

//content specific content on user request
  void hideContent(Content hide) async {
    List<Content> content = [];
    content = await getHiddenContent();
    content.add(hide);
    sharedPreferences = await SharedPreferences.getInstance();
    final stringJson = json.encode(content);
    sharedPreferences.setString("content", stringJson);
  }
}


class Content {
  final String id;
  Content({required this.id});

  Content.fromJson(Map<String, dynamic> json) : 
  id = json['id'] as String;

  Map<String, dynamic> toJson() => {'id': id};
}
