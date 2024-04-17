import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:tikidemo/Api/Api.dart';
import 'package:tikidemo/Model/Products.dart';
import 'package:tikidemo/Screen/Details.dart';
import 'package:tikidemo/Widget/Search.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const routeName = '/Home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
          backgroundColor: Colors.lightBlueAccent,
          actions: [
            IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: ProductSearch());
                }),
            IconButton(
              icon: const Icon(
                Icons.add_shopping_cart,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.settings,
              ),
              onPressed: () {},
            ),
          ],
          title: const Text('Tiki'),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Products',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_checkout_rounded),
              label: 'Shopping cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'My settings',
            ),
          ],
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Details(product: album),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 2.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(0),
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
                                      '${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(album.price)}',
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
