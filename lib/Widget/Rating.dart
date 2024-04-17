import 'package:flutter/material.dart';

class Rating extends StatelessWidget {
  const Rating({
    super.key,
    required this.ratingAverage,
  });

  final double ratingAverage;

  @override
  Widget build(BuildContext context) {
    var ratingInt = ratingAverage.floor(); // làm tròn thành số nguyên
    return Row(
        children: List.generate(5, (index) {
      if (index < ratingInt) {
        return const Icon(Icons.star, color: Colors.yellow);
      } else {
        return const Icon(Icons.star_border, color: Colors.grey);
      }
    }));
  }
}
