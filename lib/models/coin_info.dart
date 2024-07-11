class CoinInfo {
  final String mint;
  final TokenAmount tokenAmount;

  CoinInfo({
    required this.mint,
    required this.tokenAmount
  });

  factory CoinInfo.fromJson(json) {
    return CoinInfo(
      mint: json['mint'], 
      tokenAmount: TokenAmount.fromJson(json['tokenAmount']));
  }
}

class TokenAmount {
  final String amount;
  final double uiAmount;
  final String uiAmountString;

  TokenAmount({required this.amount, required this.uiAmount, required this.uiAmountString});

  factory TokenAmount.fromJson(json) {
    return TokenAmount(
      amount: json['amount'],
      uiAmount: json['uiAmount'],
      uiAmountString: json['uiAmountString']);
  }
}