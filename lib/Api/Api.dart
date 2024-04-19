import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tikidemo/Model/Products.dart';

Future<List<Album>> fetchAlbum() async {
  // http://localhost:3000/products
  final response = await http.get(Uri.parse('http://localhost:3000/products'));

  if (response.statusCode == 200) {
    // Iterable l = json.decode(response.body);
    // List<Album> albumList =
    //     List<Album>.from(l.map((model) => Album.fromJson(model)));

    final albumList = await json
        .decode(response.body)
        .map<Album>((item) => Album.fromJson(item))
        .toList();

    print('got albums $albumList');

    return albumList;
  } else {
    throw Exception('Failed to load albumxxxx');
  }
}
