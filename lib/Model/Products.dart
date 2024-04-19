class QuantitySold {
  final String text;
  final int value;

  QuantitySold({
    required this.text,
    required this.value,
  });
  factory QuantitySold.fromJson(Map<String, dynamic> json) {
    return QuantitySold(
      text: json['text'] ?? '',
      value: json['value'],
    );
  }
}

class Album {
  final int id;
  final String name;
  final String thumbnail_url;
  final int price;
  final int original_price;
  final int discount_rate;
  final double rating_average;
  final int review_count;
  final QuantitySold? quantity_sold;

  const Album({
    required this.id,
    required this.name,
    required this.thumbnail_url,
    required this.price,
    required this.original_price,
    required this.discount_rate,
    required this.rating_average,
    required this.review_count,
    required this.quantity_sold,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    try {
      return Album(
        id: json['id'],
        name: json['name'] ?? '',
        thumbnail_url: json['thumbnail_url'] ?? '',
        price: int.parse('${json['price'] ?? '0'}'),
        original_price: int.parse('${json['original_price'] ?? '0'}'),
        discount_rate: int.parse('${json['discount_rate'] ?? '0'}'),
        rating_average: double.parse('${json['rating_average'] ?? '0'}'),
        review_count: int.parse('${json['review_count'] ?? '0'}'),
        quantity_sold: json['quantity_sold'] == null
            ? null
            : QuantitySold.fromJson(json['quantity_sold']),
      );
    } catch (e) {
      print(e);
      throw const FormatException('Failed to load album 123.');
    }
  }

  @override
  String toString() {
    return 'Album {id: $id, name: $name, price: $price }';
  }
}
