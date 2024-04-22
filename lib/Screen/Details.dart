import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tikidemo/Model/Products.dart';
import 'package:tikidemo/Screen/CartPage.dart';
import 'package:provider/provider.dart';
import 'package:tikidemo/Widget/CartNotifier.dart';

class Details extends StatefulWidget {
  final Album product;

  const Details({Key? key, required this.product}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final cartNotifier = Provider.of<CartNotifier>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Thông tin Sản Phẩm'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    widget.product.thumbnail_url,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.product.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(widget.product.price)}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Rating: ${widget.product.rating_average} (${widget.product.review_count} reviews)',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Original Price: ${widget.product.original_price.toStringAsFixed(2)} đ',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Discount Rate: ${widget.product.discount_rate}%',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Product ID: ${widget.product.id}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Description: ${widget.product.quantity_sold}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (quantity > 1) {
                            quantity--;
                          }
                        });
                      },
                      child: const Icon(Icons.remove),
                    ),
                    const SizedBox(width: 10),
                    Text('$quantity'),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            child: Container(
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              var cart = Provider.of<CartNotifier>(context, listen: false);
              if (cart.isProductInCart(widget.product)) {
                cart.incrementItemQuantity(widget.product);
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Thêm vào Giỏ Hàng'),
                      content: Text(
                        'Bạn có muốn thêm ${widget.product.name} vào giỏ hàng với số lượng $quantity không?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Hủy'),
                        ),
                        TextButton(
                          onPressed: () {
                            CartItem newItem = CartItem(
                              product: widget.product,
                              quantity: quantity,
                            );
                            cart.addToCart(newItem);
                            Navigator.of(context).pop();
                            Navigator.pushNamed(context, CartPage.routeName);
                          },
                          child: const Text('Đồng Ý'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: const Text('Thêm vào giỏ'),
          ),
        )));
  }
}
