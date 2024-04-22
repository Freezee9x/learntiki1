import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tikidemo/Model/Products.dart';
import 'package:tikidemo/Widget/CartNotifier.dart';
import 'Home.dart';
import 'package:provider/provider.dart';

class CartItem {
  final Album product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}

class CartPage extends StatefulWidget {
  static const String routeName = '/cart';
  // late List<CartItem> cartItems;

  CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartNotifier>(context);
    double total = 0;
    cart.cartItems.forEach((item) {
      total += item.product.price * item.quantity;
    });

    // Tạo đối tượng NumberFormat để định dạng tiền tệ
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return WillPopScope(
      onWillPop: () async {
        // Replace current page with Home.dart when back button is pressed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Home(cartItems: cart.cartItems)),
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Giỏ Hàng'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cart.cartItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        leading: Image.network(
                          cart.cartItems[index].product.thumbnail_url,
                          width: 80,
                          height: 80,
                        ),
                        title: Text(
                          cart.cartItems[index].product.name,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Giá: ${currencyFormat.format(cart.cartItems[index].product.price)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  'Số Lượng: ${cart.cartItems[index].quantity}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (cart.cartItems[index].quantity > 1) {
                                        cart.cartItems[index].quantity--;
                                      }
                                    });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.blue),
                                    padding: MaterialStateProperty.all<
                                        EdgeInsetsGeometry>(
                                      const EdgeInsets.all(0),
                                    ),
                                  ),
                                  child: const Icon(Icons.remove,
                                      color: Colors.white),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      cart.cartItems[index].quantity++;
                                    });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.blue),
                                    padding: MaterialStateProperty.all<
                                        EdgeInsetsGeometry>(
                                      const EdgeInsets.all(0),
                                    ),
                                  ),
                                  child: const Icon(Icons.add,
                                      color: Colors.white),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      // Xóa sản phẩm khỏi giỏ hàng khi nút "Xóa" được nhấn
                                      cart.removeItem(cart.cartItems[index]);
                                    });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.red),
                                    padding: MaterialStateProperty.all<
                                        EdgeInsetsGeometry>(
                                      const EdgeInsets.all(0),
                                    ),
                                  ),
                                  child: const Icon(Icons.close,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Tổng tiền: ${currencyFormat.format(cart.cartItems[index].product.price * cart.cartItems[index].quantity)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Số Tiền Phải Thanh Toán: ${currencyFormat.format(total)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Handle payment logic here
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.all(16),
                        ),
                      ),
                      child: const Text('Thanh Toán',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
