import 'package:flutter/material.dart';
import 'package:tikidemo/Screen/Home.dart';

void main() => runApp(const MyApp());

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
      home: const Home(),
      routes: {
        Home.routeName: (_) => const Home(),
        // ShoppingCart.routeName: (_) => const ShoppingCart(),
      },
      initialRoute: Home.routeName,
    );
  }
}
