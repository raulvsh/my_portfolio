//import 'dart:ffi';
//import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Tracker',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      home: CryptoList(),
    );
  }
}

class CryptoList extends StatefulWidget {
  @override
  _CryptoListState createState() => _CryptoListState();
}

class _CryptoListState extends State<CryptoList> {
  List<Crypto> cryptos = [];
  double bitcoinPrice = 0.0;
  double total = 0.0;
  final List<double> preciosCompra = [
    0.005330,
    0.0000000000560,
    0.00001367,
    0.0004880,
    0.00001040,
    0.0001389,
    0.0002114,
    0.00000599
  ];
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
    0.598233191,
    102567507,
    110.235613,
    14.4226184,
    164.548236,
    16.51689,
    6.62883463,
    30.195702,
  ];

  @override
  void initState() {
    super.initState();
    fetchBitcoinPrice();

    fetchData();
  }

  Future<void> fetchData() async {
    // final response = await http.get(Uri.parse('https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=bitcoin,ethereum,litecoin'));
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=btc&ids=aave,cardano,bittorrent,pancakeswap-token,polkadot,filecoin,the-graph,iota&order=id_asc'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      List<Crypto> fetchedCryptos =
          data.map((crypto) => Crypto.fromJson(crypto)).toList();
      for (var i = 0; i < fetchedCryptos.length; i++) {
        //print("shitcoin " + fetchedCryptos[i].symbol.toString());
        //print("precio de compra " + preciosCompra[i].toString());
        //print("cantidades " + cantidades[i].toString());
        total += fetchedCryptos[i].price * cantidades[i] * bitcoinPrice;
      }

      setState(() {
        cryptos = fetchedCryptos;
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
      for (var i = 0; i < fetchedBTC.length; i++) {
        print("bitcoin1 " +
            fetchedBTC[i].symbol.toString() +
            fetchedBTC[i].price.toString());
        //print("precio de compra " + preciosCompra[i].toString());
        // print("cantidades " + cantidades[i].toString());
      }

      setState(() {
        bitcoinPrice = fetchedBTC[0].price;
      });
    } else {
      throw Exception('Error al cargar datos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'Mis shitcoins',
        )),
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      //body: Text('holaasda'),
      body: ListView.builder(
        itemCount: cryptos.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                child: ListTile(
                  //padding: const EdgeInsets.all(8.0),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              //Image.asset('./assets/img/${index}.png',                                  height: 30),
                              Image.asset('./assets/img/$index.png',
                                  height: 30),
                              Flexible(
                                child: Text(
                                  '   ${cryptos[index].name} ',overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          )),
                      //subtitle: Text('${cryptos[index].symbol} - ${cryptos[index].name} - B${cryptos[index].price}' ),

                      Expanded(
                          flex: 2,
                          child: Text('B${cryptos[index].price.toStringAsFixed(8)}',style: const TextStyle(fontSize: 13),
                              textAlign: TextAlign.left)),

                      Expanded(
                        flex: 1,
                        child: Text(
                            '${((cryptos[index].price / preciosCompra[index] - 1) * 100).toStringAsFixed(2)}%', style: const TextStyle(fontSize: 13),)
                      ),

                      Expanded(
                          flex: 1,
                          child: Text(
                              '\$${(cryptos[index].price * cantidades[index] * bitcoinPrice).toStringAsFixed(2)}', style: const TextStyle(fontSize: 13),))
                    ],
                  ),
                ),
              ),
              const Divider(
                color: Colors.black,
              )
            ],
          );
        },
      ),

      bottomSheet: Text('Total en shitcoins: \$${total.toStringAsFixed(2)}'),
    );
  }
}

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
