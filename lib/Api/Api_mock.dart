import 'dart:convert';

import 'package:tikidemo/Model/Products.dart';

var productList = <Album>[];
Future<List<Album>> getAllProducts() async {
  return productList;
}

Future<Album> getProductById(int productId) async {
  var http;
  final response = await http
      .get(Uri.parse('http://your-api-endpoint.com/products/$productId'));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    return Album.fromJson(jsonData);
  } else {
    throw Exception('Failed to load product');
  }
}

Future<List<Album>> findByName(String? name) async {
  var http;
  final response =
      await http.get(Uri.parse('http://localhost:3000/products?name=$name'));
  if (response.statusCode == 200) {
    // Chuyển đổi dữ liệu JSON nhận được thành danh sách sản phẩm
    Iterable data = json.decode(response.body);
    List<Album> productList =
        List<Album>.from(data.map((model) => Album.fromJson(model)));
    return productList;
  } else {
    // Xử lý lỗi nếu có
    throw Exception('Failed to load products');
  }
}
