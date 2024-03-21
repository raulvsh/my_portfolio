import 'package:flutter/material.dart';
import 'package:my_portfolio/crypto_item.dart';
import 'package:my_portfolio/total_value.dart';

import 'crypto.dart';

class CryptoList extends StatelessWidget {
  const CryptoList({
    super.key,
    required this.cryptos,
    required this.preciosCompra,
    required this.cantidades,
    required this.bitcoinPrice, required this.totalValue,
  });

  final List<Crypto> cryptos;
  final List<double> preciosCompra;
  final List<double> cantidades;
  final double bitcoinPrice;
  final double totalValue;

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
        itemCount: cryptos.length + 1, // +1 para incluir el texto adicional

        itemBuilder: (context, index) {
          double percentage = 0.0;
          if (index < cryptos.length) {
                      percentage = (cryptos[index].price / preciosCompra[index] - 1) * 100;

              return CryptoItem(cryptos: cryptos, cantidades: cantidades, bitcoinPrice: bitcoinPrice, percentage: percentage, index: index,);

          } else {
            //var total;
            return /*Padding(
              padding: const EdgeInsets.all(40.0),
              child: Text(
                'Este es una aplicación segura, de verdad, te prometo que no te espío.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            );*/TotalValue(total: totalValue, bitcoinPrice: bitcoinPrice,);


          }
        });
  }
}
