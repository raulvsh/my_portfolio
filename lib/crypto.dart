class Crypto {
  final String name;
  final String symbol;
  final double price;

  Crypto({
    required this.name,
    required this.symbol,
    required this.price,
  });

  factory Crypto.fromJson(Map<String, dynamic> json) {
    return Crypto(
      name: json['name'],
      symbol: json['symbol'],
      price: json['current_price'].toDouble(),
    );
  }
}