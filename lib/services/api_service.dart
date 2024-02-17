import 'dart:convert';
import 'package:discover/model/item_model.dart';
import 'package:http/http.dart' as http;


class ApiService {
  final String baseUrl = "https://api-stg.together.buzz/mocks/discovery";

  Future<List<ItemModel>> fetchData(int page, int limit) async {
    final response = await http.get(Uri.parse('$baseUrl?page=$page&limit=$limit'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['data'];
      return data.map((item) => ItemModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
