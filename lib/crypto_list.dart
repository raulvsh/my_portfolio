
import 'package:flutter/material.dart';
import 'package:my_portfolio/crypto_item.dart';

import 'crypto.dart';

class CryptoList extends StatelessWidget {
  const CryptoList({
    super.key,
    required this.cryptos,
    required this.preciosCompra,
    required this.cantidades,
    required this.bitcoinPrice,
  });

  final List<Crypto> cryptos;
  final List<double> preciosCompra;
  final List<double> cantidades;
  final double bitcoinPrice;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        
        itemCount: cryptos.length,
        itemBuilder: (context, index) {
      
          double percentage = 0.0;
          percentage = (cryptos[index].price / preciosCompra[index] - 1) * 100;
          
          return CryptoItem(cryptos: cryptos, cantidades: cantidades, bitcoinPrice: bitcoinPrice, percentage: percentage, index: index,);
        },
      ),
    );
  }
}
