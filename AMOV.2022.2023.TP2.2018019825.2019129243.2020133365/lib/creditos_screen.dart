import 'package:flutter/material.dart';

class CreditosScreen extends StatefulWidget {
  const CreditosScreen({Key? key}) : super(key: key);
  static const String routeName = '/CreditosScreen';

  @override
  State<CreditosScreen> createState() => _CreditosScreenState();
}

class _CreditosScreenState extends State<CreditosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyanAccent,
      appBar: AppBar(
          title: const Text(
              "Créditos"
          )
      ),
      body: Center(child:
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          SizedBox(height: 230),
          Hero(tag: 'CenterTitleText',child:
          Text("Arquiteturas Móveis",
            textScaleFactor: 2.2,)
          ),
          Text("2022/2023",
              textScaleFactor: 2.2),
          SizedBox(height: 160),
          Text("Diogo Pascoal",
              textScaleFactor: 2.2),
          Text("2018019825",
          textScaleFactor: 1.8),
          SizedBox(height: 10),
          Text("Leonardo Sousa",
              textScaleFactor: 2.2),
          Text("2019129243",
              textScaleFactor: 1.8),
          SizedBox(height: 10),
          Text("Rodrigo Costa",
              textScaleFactor: 2.2),
          Text("2020133365",
              textScaleFactor: 1.8),
        ],
      )),
    );
  }
}
