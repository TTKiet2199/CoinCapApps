import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  DetailsPage({Key? key, required this.rates}) : super(key: key);
  final Map rates;

  @override
  Widget build(BuildContext context) {
    List currencies = rates.keys.toList();
    List rateValues = rates.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Different Exchange Rates'),
      ),
      body: ListView.builder(
        itemCount: currencies.length,
        itemBuilder: (context, index) {
          String curency = currencies[index].toString();
          String rateValue = rateValues[index].toString();
          return ListTile(
              title: Text(
            '$curency:$rateValue',
            style: const TextStyle(color: Colors.white),
          ));
        },
      ),
    );
  }
}
