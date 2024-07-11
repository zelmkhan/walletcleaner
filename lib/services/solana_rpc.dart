import 'dart:math';

import 'package:lamb_csb/models/coin.dart';
import 'package:lamb_csb/models/coin_info.dart';
import 'package:solana_web3/programs.dart';
import 'package:solana_web3/solana_web3.dart';

class SolanaRpc {


  static final cluster = Cluster(Uri.parse("https://mainnet.helius-rpc.com/?api-key=38df0361-a6a9-4239-a053-0675a3e3bf5e"));
  static final connection = Connection(cluster);

  static Future<List<Coin>> getTokenAccounts({required String walletAddress}) async {
    var tokenAccountsByOwner = await connection.getTokenAccountsByOwner(Pubkey.fromBase58(walletAddress), filter: TokenAccountsFilter.programId(TokenProgram.programId), config: GetAccountInfoConfig(encoding: AccountEncoding.jsonParsed));
    var tokenAccountsInfo = tokenAccountsByOwner.map((token) {
      final data = CoinInfo.fromJson(token.account.toJson()['data']['parsed']['info']);
        return Coin(
          isSelected: true,
          tokenAddress: token.pubkey,
          mint: data.mint,
          amount: data.tokenAmount
        );
    }).toList();
    return tokenAccountsInfo;
  }

  // static Future getTokenDecimals({required String mint}) async {
  //   var accountInfo = await connection.getInf;
  //   return accountInfo
  // }

  static List<TransactionInstruction> buildInstructions({required String owner, required List<String> tokenAddresses}) {
    var list = <TransactionInstruction>[];
    for (var address in tokenAddresses) {
      list.add(TokenProgram.closeAccount(
            account: Pubkey.fromBase58(address), 
            destination: Pubkey.fromBase58(owner), 
            owner: Pubkey.fromBase58(owner)));
    }
    return list;
  }

  static Future<Transaction> buildTransactions({required String owner, required List<Coin> coins}) async {
    var instr = <TransactionInstruction>[];

    final latestBlockhash = await connection.getLatestBlockhash();

      for (var coin in coins) {
        if (coin.isSelected) {
          if (coin.amount!.amount == "0") {
            instr.add(TokenProgram.closeAccount(
            account: Pubkey.fromBase58(coin.tokenAddress!), 
            destination: Pubkey.fromBase58(owner), 
            owner: Pubkey.fromBase58(owner))); 
        } else {
          instr.add(TokenProgram.burn(
            account: Pubkey.fromBase58(coin.tokenAddress!), 
            mint: Pubkey.fromBase58(coin.mint!), 
            authority: Pubkey.fromBase58(owner), 
            amount: BigInt.from(int.parse(coin.amount!.amount))));
          instr.add(TokenProgram.closeAccount(
            account: Pubkey.fromBase58(coin.tokenAddress!), 
            destination: Pubkey.fromBase58(owner), 
            owner: Pubkey.fromBase58(owner))); 
        }
        }
      }
      
      var fee = (coins.where((element) => element.isSelected).length * 0.002) / 100;

      instr.add(
        SystemProgram.transfer(
          fromPubkey: Pubkey.fromBase58(owner), 
          toPubkey: Pubkey.fromBase58("8b4mq2P5myjHdmP1jULSh2gTU1eo6GcJr3VQk8UE4xnz"), 
          lamports: BigInt.from(fee * pow(10, 9)))
      );

      var trx = Transaction.v0(
        payer: Pubkey.fromBase58(owner),
        recentBlockhash: latestBlockhash.blockhash,
        instructions: instr
      );


    return trx;
  }

  static Future<List<String?>> sendPayload({required List<String> signedTransactions}) async {
    var send = await connection.sendSignedTransactions(signedTransactions);
    return send;
  }

}