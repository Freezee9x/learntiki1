import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

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
    throw Exception('Failed to load album');
  }
}

class QuantitySold {
  final String text;
  final int value;

  QuantitySold({
    required this.text,
    required this.value,
  });
  factory QuantitySold.fromJson(Map<String, dynamic> json) {
    return QuantitySold(
      text: json['text'] ?? '',
      value: json['value'],
    );
  }
}

class Album {
  final String id;
  final String name;
  final String thumbnail_url;
  final int price;
  final int original_price;
  final int discount_rate;
  final double rating_average;
  final int review_count;
  final QuantitySold? quantity_sold;

  const Album({
    required this.id,
    required this.name,
    required this.thumbnail_url,
    required this.price,
    required this.original_price,
    required this.discount_rate,
    required this.rating_average,
    required this.review_count,
    required this.quantity_sold,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    try {
      return Album(
        id: json['id'],
        name: json['name'] ?? '',
        thumbnail_url: json['thumbnail_url'] ?? '',
        price: int.parse('${json['price'] ?? '0'}'),
        original_price: int.parse('${json['original_price'] ?? '0'}'),
        discount_rate: int.parse('${json['discount_rate'] ?? '0'}'),
        rating_average: double.parse('${json['rating_average'] ?? '0'}'),
        review_count: int.parse('${json['review_count'] ?? '0'}'),
        quantity_sold: json['quantity_sold'] == null
            ? null
            : QuantitySold.fromJson(json['quantity_sold']),
      );
    } catch (e) {
      print(e);
      throw const FormatException('Failed to load album 123.');
    }
  }

  @override
  String toString() {
    return 'Album {id: $id, name: $name, price: $price }';
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Album>> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tiki',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tiki'),
        ),
        body: Center(
          child: FutureBuilder<List<Album>>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    children: snapshot.data!.map((album) {
                      return GestureDetector(
                        onTap: () {},
                        child: Card(
                          elevation: 2.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: Image.network(
                                  album.thumbnail_url,
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  album.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '\ ${album.price} đ',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (album.discount_rate > 0)
                                      Text(
                                        '\ ${album.original_price} đ',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.grey,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.star,
                                        color: Colors.orange, size: 20),
                                    const SizedBox(width: 5),
                                    Text(
                                      '${album.rating_average} (${album.review_count} reviews)',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
