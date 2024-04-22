import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tikidemo/Screen/CartPage.dart';
import 'package:tikidemo/Widget/CartNotifier.dart';
import 'package:tikidemo/Screen/Home.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tiki',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(
        cartItems: [],
      ),
      routes: {
        Home.routeName: (_) => const Home(
              cartItems: [],
            ),
        CartPage.routeName: (_) => CartPage()
      },
      initialRoute: Home.routeName,
    );
  }
}
