extension StringExtension on String {

  String formatNumWithCommas() {
    toString().contains('.')
        ? toString().replaceAll(RegExp(r'0*$'), '')
        : toString();
    List<String> parts = toString().split('.');
    String integerPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]},',
    );
    String decimalPart = parts.length > 1 ? '.${parts[1]}' : '';
    return '$integerPart$decimalPart';
  }


  String cutText() {
  if (length < 18) {
    return this;
  }
  
  String startSymbols = substring(0, 5);
  String endSymbols = substring(length - 8);

  return '$startSymbols...$endSymbols';
}
}
