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

  @override
  void initState() {
    super.initState();
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
        print("shitcoin " + fetchedCryptos[i].symbol.toString());
        print("precio de compra " + preciosCompra[i].toString());
      }

      setState(() {
        cryptos = fetchedCryptos;
      });
    } else {
      throw Exception('Error al cargar datos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis shitcoins'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      //body: Text('holaasda'),
      body: ListView.builder(
        itemCount: cryptos.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(cryptos[index].name),
                        //subtitle: Text('${cryptos[index].symbol} - ${cryptos[index].name} - B${cryptos[index].price}' ),

                        subtitle: Text('B${cryptos[index].price}'),
                      ),
                      Text(
                          '${((cryptos[index].price / preciosCompra[index] - 1) * 100).toStringAsFixed(2)}%')
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
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
