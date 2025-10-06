import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:posty/data/model/dataformat.dart';

class DataFormatRepository {
  Future<List<DataFormat>> getPosts() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      headers: {'Accept': 'application/json', 'User-Agent': 'PostyApp/1.0'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => DataFormat.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load posts: ${response.statusCode}");
    }
  }

  Future<DataFormat> getPostById(int postId) async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/$postId'),
      headers: {'Accept': 'application/json', 'User-Agent': 'PostyApp/1.0'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return DataFormat.fromJson(data);
    } else {
      throw Exception("Failed to load post");
    }
  }
}
