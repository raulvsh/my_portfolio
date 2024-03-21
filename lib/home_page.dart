
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_portfolio/crypto_item.dart';
import 'package:my_portfolio/crypto_list.dart';
import 'package:my_portfolio/total_value.dart';
import 'dart:convert';

import 'crypto.dart';


class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  List<Crypto> cryptos = [];
  double bitcoinPrice = 0.0;
  double total = 0.0;
  final List<double> preciosCompra = [
    0.005330, //AAVE
    0.0000000000560, //BTT
    0.00001367, //ADA
    0.0004880, //FIL
    0.00001040, //IOTA
    0.0001389, //CAKE
    0.0002114, //DOT
    0.00000599 //GRT
  ];
  // Cantidades privadas
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

  // Cantidades públicas
  final List<double> cantidades = [
    0.598233191,
    100256750.7,
    110.2235613,
    14.04226184,
    164.3548236,
    16.451689,
    6.862883463,
    308.8195702,
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
          'My portfolio',
          style: TextStyle(color: Colors.white),
        )),
        backgroundColor: Colors.black87,//.of(context).colorScheme.inversePrimary,
      ),
      body:  
        
            //istView(
              ///children: [
                CryptoList(cryptos: cryptos, preciosCompra: preciosCompra, cantidades: cantidades, bitcoinPrice: bitcoinPrice, totalValue: total,),
             // ],
           // ),
            //Expanded(child: Text('hola')),
            //Text('hola'),

            //Text('hola')

          
        
      

     // bottomSheet: TotalValue(total: total),
    );
  }
}

