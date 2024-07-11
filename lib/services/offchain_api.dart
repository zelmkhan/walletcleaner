import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class OffchainApi {
  static Future<num> getPriceForSolanaCoin({required String mint}) async {
    try {
      var response = await http.get(Uri.parse(
          "https://birdeye-proxy.jup.ag/defi/multi_price?list_address=$mint,EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v"));
      var jsonDecode = json.decode(response.body)['data'][mint]['value'];
      return jsonDecode ?? 0;
    } catch (_) {
      return 0;
    }
  }

  static Future<Map<String, dynamic>> getSolanaTokenList() async {
      var response = await rootBundle.loadString("tokens/solana_token_list.json");
      final Map<String, dynamic> jsonDecode = await json.decode(response);
      return jsonDecode;
  }
  
}
