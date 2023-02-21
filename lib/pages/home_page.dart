import 'dart:convert';
import 'package:coincapapp/pages/details_page.dart';
import 'package:coincapapp/service/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? deviceWidth, deviceHeight;
  HTTPService? http;
  String? selectedCoin = "bitcoin";
  @override
  void initState() {
    super.initState();
    http = GetIt.instance.get<HTTPService>();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              selectedCoinDropdown(),
              dataWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget selectedCoinDropdown() {
    List<String> coin = ["bitcoin", "ethereum", "tether", "cardano", "ripple"];
    List<DropdownMenuItem<String>> items = coin
        .map(
          (e) => DropdownMenuItem(
              value: e,
              child: Text(
                e,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w400),
              )),
        )
        .toList();
    return DropdownButton(
      value: selectedCoin,
      items: items,
      onChanged: (dynamic value) {
        setState(() {
          selectedCoin = value;
        });
      },
      dropdownColor: const Color.fromRGBO(88, 90, 200, 1.0),
      iconSize: 30,
      icon: const Icon(
        Icons.arrow_drop_down_sharp,
        color: Colors.white,
      ),
      underline: Container(),
    );
  }

  Widget dataWidget() {
    return FutureBuilder(
      future: http!.get("/coins/$selectedCoin"),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map data = jsonDecode(
            snapshot.data.toString(),
          );
          num usdPrice = data["market_data"]["current_price"]["usd"];
          num change24h = data["market_data"]["price_change_percentage_24h"];
          Map rateExchange = data["market_data"]["current_price"];
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                  onDoubleTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return DetailsPage(
                        rates: rateExchange,
                      );
                    }));
                  },
                  child: _coinImageWidget(data["image"]["large"])),
              _currentPriceWidget(usdPrice),
              _perrsentageChangeWidget(change24h),
              _descriptionCardWidget(data["description"]["en"]),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _currentPriceWidget(num rate) {
    return Text(
      "${rate.toStringAsFixed(2)}USD",
      style: const TextStyle(
          color: Colors.white, fontSize: 30, fontWeight: FontWeight.w500),
    );
  }

  Widget _perrsentageChangeWidget(num change) {
    return Text(
      "${change.toStringAsFixed(2)}%",
      style: const TextStyle(
          color: Colors.white, fontSize: 30, fontWeight: FontWeight.w300),
    );
  }

  Widget _coinImageWidget(String imageURL) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: deviceHeight! * 0.02),
      height: deviceHeight! * 0.15,
      width: deviceWidth! * 0.15,
      decoration:
          BoxDecoration(image: DecorationImage(image: NetworkImage(imageURL))),
    );
  }

  Widget _descriptionCardWidget(String description) {
    return Container(
      height: deviceHeight! * 0.45,
      width: deviceWidth! * 0.9,
      margin: EdgeInsets.symmetric(vertical: deviceHeight! * 0.05),
      padding: EdgeInsets.symmetric(
          vertical: deviceHeight! * 0.01, horizontal: deviceHeight! * 0.01),
      color: const Color.fromRGBO(83, 88, 206, 0.5),
      child: Text(
        description,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
