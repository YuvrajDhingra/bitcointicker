import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coindata.dart';
class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency='USD';
  List<Text> getpickerItems(){
    List<Text> pickerItems=[];
    for(String currency in currenciesList){
      pickerItems.add(Text(currency));
    }
    return pickerItems;
  }
  String price = '?';
  Map<String, String> coinValues = {};
  bool isWaiting = false;
  void getData() async {
    isWaiting=true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting=false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      setState(() {
        isWaiting=false;
      });
      print(e);
    }
  }
  @override
  void initState() {
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CryptoCard(
              cryptoCurrency: 'BTC',
              price: isWaiting ? '?' : coinValues['BTC'],
              selectedCurrency: selectedCurrency,
            ),
            CryptoCard(
              cryptoCurrency: 'ETH',
              price: isWaiting ? '?' : coinValues['ETH'],
              selectedCurrency: selectedCurrency,
            ),
            CryptoCard(
              cryptoCurrency: 'LTC',
              price: isWaiting ? '?' : coinValues['LTC'],
              selectedCurrency: selectedCurrency,
            ),
          ],
        ),
          Container(
            height: 100.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: CupertinoPicker(
                itemExtent: 32.0,
                onSelectedItemChanged: (selectedIndex){
                  print(selectedIndex);
                  setState(() {
                    selectedCurrency=currenciesList[selectedIndex];
                    getData();
                  });
                },
                children: getpickerItems(),
            ),
          ),
        ],
      ),
    );
  }
}
class CryptoCard extends StatelessWidget {
  const CryptoCard({
    required this.price,
    required this.selectedCurrency,
    required this.cryptoCurrency,
  });

  final dynamic price;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
    child: Card(
    color: Colors.lightBlueAccent,
    elevation: 5.0,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
    ),
    child: Padding(
    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
    child: Text(
    '1 $cryptoCurrency = $price $selectedCurrency',
    textAlign: TextAlign.center,
    style: TextStyle(
    fontSize: 20.0,
    color: Colors.white,
    ),
    ),
    ),
    ),
    );
  }
}