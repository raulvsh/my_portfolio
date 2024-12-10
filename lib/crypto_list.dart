import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:my_portfolio/crypto_item.dart';
import 'package:my_portfolio/total_value.dart';

import 'crypto.dart';

class CryptoList extends StatefulWidget {
  const CryptoList({
    super.key,
  });

  @override
  State<CryptoList> createState() => _CryptoListState();
}

class _CryptoListState extends State<CryptoList> {
  List<Crypto> cryptos = [];
  double total = 0.0;

  double bitcoinPrice = 0;

  final List<double> preciosCompra = [
    0.00455596, //AAVE
    0.0000000000560, //BTT
    0.00048788, //FIL
    0.00006221, //CAKE
    0.000128052, //DOT
    0.00000467 //GRT
  ];


  final List<double> cantidades = [
    0.832206614, //AAVE  
    100256750.7, //BTT
    13.60220255, //FIL
    57.69571292, //CAKE
    21.88364233, //DOT
    557.8822639, //GRT
  ];

  @override
  void initState() {
    super.initState();
    try {
      fetchBitcoinPrice();
      fetchData();
    } catch (error) {
      showSnackBar(
          'Error al obtener los datos.\nEspere unos segundos por favor.');
    }
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=btc&ids=aave,bittorrent,pancakeswap-token,polkadot,filecoin,the-graph&order=id_asc'));
    double totaltemp = 0.0;

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      List<Crypto> fetchedCryptos =
          data.map((crypto) => Crypto.fromJson(crypto)).toList();
      for (var i = 0; i < fetchedCryptos.length; i++) {
        totaltemp += fetchedCryptos[i].price * cantidades[i] * bitcoinPrice;
      }

      setState(() {
        cryptos = fetchedCryptos;
        total = totaltemp;
      });
    } else {
      throw Exception('Error al cargar datos');
    }
  }

  Future<void> fetchBitcoinPrice() async {
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=bitcoin'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      List<Crypto> fetchedBTC =
          data.map((crypto) => Crypto.fromJson(crypto)).toList();

      setState(() {
        bitcoinPrice = fetchedBTC[0].price;
      });
    } else {
      throw Exception('Error al cargar datos');
    }
  }

  Future<void> _refreshData() async {
    showSnackBar('Actualizando datos...');

    //Recibir de nuevo los datos
    try {
      await fetchBitcoinPrice();
      await fetchData();
    } catch (error) {
      showSnackBar(
          'Error al actualizar los datos.\nEspere unos segundos por favor.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: FutureBuilder(
          future: fetchData(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Muestra un indicador de carga mientras espera
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                  itemCount:
                      cryptos.length + 1, // +1 para incluir el bloque adicional

                  itemBuilder: (context, index) {
                    double percentage = 0.0;
                    if (index < cryptos.length) {
                      percentage =
                          (cryptos[index].price / preciosCompra[index] - 1) *
                              100;

                      return CryptoItem(
                        cryptos: cryptos,
                        cantidades: cantidades,
                        bitcoinPrice: bitcoinPrice,
                        percentage: percentage,
                        index: index,
                      );
                    } else {
                      return TotalValue(
                        total: total,
                        bitcoinPrice: bitcoinPrice,
                      );
                    }
                  });
            }
          }),
    );
  }

  void showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
      duration: const Duration(seconds: 2), // Duración del mensaje emergente
    ));
  }
}
