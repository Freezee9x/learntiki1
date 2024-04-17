import 'package:flutter/material.dart';
import 'package:tikidemo/Api/Api_mock.dart';
import 'package:tikidemo/Constain.dart';
import 'package:tikidemo/Model/Products.dart';
import 'package:tikidemo/Widget/Rating.dart';

class Details extends StatelessWidget {
  final Album product;
  const Details({super.key, required this.product});

  static const routeName = '/Detail';
  static const MAX_DESCRIPTION_LENGTH = 350;

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as int;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chi tiết sản phẩm'),
        ),
        body: FutureBuilder<Album>(
            future: getProductById(productId),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Opsss ERROR ${snapshot.error}');
              } else if (snapshot.hasData) {
                final product = snapshot.data!;

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Image.network(
                          product.thumbnail_url,
                          height: 240,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24, bottom: 8),
                          child: Text(
                            product.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Rating(ratingAverage: product.rating_average),
                              if (product.review_count > 0)
                                Text(' (${product.review_count})'),
                              if (product.quantity_sold != null)
                                Text(' | ${product.quantity_sold!.text}'),
                              const Spacer(),
                              IconButton(
                                onPressed: () {},
                                color: Colors.black45,
                                icon: const Icon(Icons.link),
                              ),
                              IconButton(
                                onPressed: () {},
                                color: Colors.black45,
                                icon: const Icon(Icons.share),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 34),
                          child: Text(
                            formatCurrency.format(product.price),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: Colors.redAccent),
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            print('TODO: Add product $productId to cart');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            minimumSize: const Size.fromHeight(40),
                          ),
                          child: Text(
                            'Chọn Mua',
                            style: Theme.of(context)
                                .textTheme
                                .button!
                                .copyWith(fontSize: 36.0, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }

              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
