import 'package:flutter/material.dart';

class TotalValue extends StatelessWidget {
  const TotalValue({
    super.key,
    required this.total,
    required this.bitcoinPrice,
  });

  final double total;
  final double bitcoinPrice;

  @override
  Widget build(BuildContext context) {
    var textStyleFont18 = const TextStyle(fontSize: 16);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('./assets/img/bitcoin.png', height: 50),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Valor en shitcoins: \$${total.toStringAsFixed(2)}',
                style: textStyleFont18,
              ),
              Text(
                  'Valor en Bitcoin: ${(total / bitcoinPrice).toStringAsFixed(8)}',
                  style: textStyleFont18),
              Text(
                'Precio de Bitcoin: ${(bitcoinPrice).toStringAsFixed(0)}',
                style: textStyleFont18,
              )
            ],
          ),
          Image.asset('./assets/img/dolar.png', height: 50),
        ],
      ),
    );
  }
}
