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
    0.00532966, //AAVE
    0.0000000000560, //BTT
    0.00001187, //ADA
    0.00048788, //FIL
    0.00000613, //IOTA
    0.00013568, //CAKE
    0.000173082, //DOT
    0.00000599 //GRT
  ];
  // Cantidades x10
  /*final List<double> cantidades = [
    5.98233191,
    1002567507,
    1102.235613,
    140.4226184,
    1643.548236,
    164.51689,
    68.62883463,
    3088.195702,
  ];*/

  final List<double> cantidades = [
    0.598233119, //AAVE  
    100256750.7, //BTT
    139.258503, //ADA
    14.0422618, //FIL
    339.363904604, //IOTA
    16.845789, //CAKE
    9.42403677, //DOT
    308.81957, //GRT
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
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=btc&ids=aave,cardano,bittorrent,pancakeswap-token,polkadot,filecoin,the-graph,iota&order=id_asc'));
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
