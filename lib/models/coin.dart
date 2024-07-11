import 'package:lamb_csb/models/coin_info.dart';

class Coin {
  bool isSelected;
  String? name;
  String? symbol;
  String? mint;
  TokenAmount? amount;
  String? usdBalance;
  String? tokenAddress;
  String? logoURI;

  Coin({required this.isSelected, this.name, this.symbol, this.mint, this.logoURI, this.tokenAddress, this.amount, this.usdBalance});

  factory Coin.fromJson(json) {
    return Coin(
      isSelected: true,
      logoURI: json['logoURI'],
      name: json['name'],
      symbol: json['symbol']
    );
  }
}