import 'package:flutter/material.dart';
import 'package:tikidemo/Model/Products.dart';

class CartItem {
  final Album product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}

class CartPage extends StatefulWidget {
  static const String routeName = '/cart';

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = []; // Danh sách sản phẩm trong giỏ hàng

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ Hàng'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(cartItems[index].product.name),
            subtitle: Row(
              children: [
                Text('Số Lượng: ${cartItems[index].quantity}'),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Giảm số lượng sản phẩm
                    setState(() {
                      if (cartItems[index].quantity > 1) {
                        cartItems[index].quantity--;
                      }
                    });
                  },
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 5),
                ElevatedButton(
                  onPressed: () {
                    // Tăng số lượng sản phẩm
                    setState(() {
                      cartItems[index].quantity++;
                    });
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
