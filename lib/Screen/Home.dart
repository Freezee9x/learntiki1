import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tikidemo/Api/Api.dart';
import 'package:tikidemo/Model/Products.dart';
import 'package:tikidemo/Screen/CartPage.dart';
import 'package:tikidemo/Screen/Details.dart';
import 'package:tikidemo/Widget/Search.dart';
import 'package:provider/provider.dart';
import 'package:tikidemo/Widget/CartNotifier.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required List<CartItem> cartItems}) : super(key: key);
  static const routeName = '/Home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Album>> futureAlbum;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final cartNotifier = Provider.of<CartNotifier>(context);

    return MaterialApp(
      title: 'Tiki',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          title: Text('Tiki'),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: ProductSearch(products: futureAlbum),
                  );
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_shopping_cart),
              onPressed: () {
                // Điều hướng đến trang CartPage khi nhấn vào nút "Shopping cart"
                Navigator.pushNamed(context, CartPage.routeName);
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {},
            ),
          ],
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
