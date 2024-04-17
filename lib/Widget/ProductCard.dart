import 'package:flutter/material.dart';
import 'package:tikidemo/Constain.dart';
import 'package:tikidemo/Model/Products.dart';
import 'package:tikidemo/Widget/Rating.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
  });

  final Album product;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
              product.thumbnail_url,
              width: 100,
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 16),
              child: Text(
                product.name.length > 28
                    ? '${product.name.substring(0, 28)}...'
                    : product.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Rating(ratingAverage: product.rating_average),
                if (product.quantity_sold != null)
                  Text(' | ${product.quantity_sold!.text}'),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text('${product.review_count}'),
                ),
              ],
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(formatCurrency.format(product.price))),
          ],
        ),
      ),
    );
  }
}
