import 'package:flutter/material.dart';
import 'package:my_portfolio/crypto_list.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  void initState() {
    super.initState();
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
        backgroundColor:
            Colors.black87, //.of(context).colorScheme.inversePrimary,
      ),
      body: const CryptoList(),
    );
  }
}
