
import 'package:flutter/material.dart';

import 'crypto.dart';

class CryptoItem extends StatelessWidget {
  const CryptoItem({
    super.key,
    required this.cryptos,
    required this.cantidades,
    required this.bitcoinPrice,
    required this.percentage,
    required this.index,
  });

  final List<Crypto> cryptos;
  final List<double> cantidades;
  final double bitcoinPrice;
  final double percentage;
    final int index;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          child: ListTile(
            dense: true,
            leading: Image.asset('./assets/img/$index.png',
                height: 30),
            title: Text(
              '${cryptos[index].name} ',
              style: const TextStyle(fontSize: 15),
            ),
            subtitle: 
                Text(
                    '${cantidades[index]}  |  B${cryptos[index].price.toStringAsFixed(8)}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '\$${(cryptos[index].price * cantidades[index] * bitcoinPrice).toStringAsFixed(2)}',
                ),
                Text(
                    '${percentage.toStringAsFixed(2)}%',
                    
                    style: TextStyle(color: percentage<0?Colors.red:Colors.green),
                    ),
              ],
            ),
          ),
        ),
        const Divider(
          color: Colors.black87,
        )
      ],
    );
  }
}