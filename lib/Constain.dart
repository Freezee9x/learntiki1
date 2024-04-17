import 'package:intl/intl.dart';

class Constants {
  Constants._();

  static const _apiBaseUrl = 'http://localhost:3000';
  static const productApiUrl = '$_apiBaseUrl/products';
}

final formatCurrency = NumberFormat.simpleCurrency(locale: 'vi-VN');
