import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamb_csb/bl/states.dart';
import 'package:lamb_csb/models/coin.dart';
import 'package:lamb_csb/screen/widgets/showtoasts.dart';
import 'package:lamb_csb/services/offchain_api.dart';
import 'package:lamb_csb/services/solana_rpc.dart';
import 'package:solana_wallet_adapter/solana_wallet_adapter.dart';
import 'package:solana_web3/solana_web3.dart';

class BlCubit extends Cubit<States> {
  BlCubit(super.initialState);

  final _adapter = SolanaWalletAdapter(
    AppIdentity(
      icon: Uri.parse("https://bimx3rx7oemporjkbo73v2kppousrxxuc2niu6vscgqdr5fj4y4a.arweave.net/Chl9xv9xGPdFKgu_uulPe6ko3vQWmop6shGgOPSp5jg"),
      name: "WalletCleaner",
      uri: Uri.parse("https://walletcleaner.app")
    ),
    cluster: Cluster.mainnet,
  );

  Future<void> connectAndScanWallet() async {
    try {
      final AuthorizeResult authorizeResult = await _adapter.authorize();
      emit(LoadingState(authorizeResult: authorizeResult));
      
      var tokenAccounts = await SolanaRpc.getTokenAccounts(walletAddress: authorizeResult.accounts.first.toBase58());
      var tokenList = await OffchainApi.getSolanaTokenList();

      for (var account in tokenAccounts) {
        if (tokenList[account.mint] != null) {
          var price = await OffchainApi.getPriceForSolanaCoin(mint: account.mint!);

          var token = Coin.fromJson(tokenList[account.mint]);
          account.name = token.name;
          account.symbol = token.symbol;
          account.logoURI = token.logoURI;
          account.amount = account.amount;
          account.usdBalance = (price * account.amount!.uiAmount).toStringAsFixed(2);
        }
      }

      var solPrice = await OffchainApi.getPriceForSolanaCoin(mint: "So11111111111111111111111111111111111111112");
      var siftingTokenAccounts = tokenAccounts.where((e) => num.parse(e.usdBalance ?? "0.0") < 1).toList();

      emit(LoadedState(authorizeResult: authorizeResult, tokens: siftingTokenAccounts, sludge: "+\$${(0.002 * siftingTokenAccounts.length * solPrice).toStringAsFixed(2)}"));

    } catch(e) {
      showMessage(e.toString());
    }
  }

  Future<void> updateTokenList({required List<Coin> coins}) async {
    var solPrice = await OffchainApi.getPriceForSolanaCoin(mint: "So11111111111111111111111111111111111111112");
    var siftingTokenAccounts = coins.where((e) => num.parse(e.usdBalance ?? "0.0") < 1).toList();
    var coinsLength = siftingTokenAccounts.where((e) => e.isSelected == true).length;
    emit(LoadedState(authorizeResult: _adapter.authorizeResult!, tokens: siftingTokenAccounts, sludge: "+\$${(0.002 * coinsLength * solPrice).toStringAsFixed(2)}"));
  }

  Future<void> disconnectWallet() async => emit(InitialState());

  Future clearWallet({required List<Coin> coins}) async {
    showLoadingIndicator();
    // If liqudity -> swap
    var trx = await SolanaRpc.buildTransactions(owner: _adapter.authorizeResult!.accounts.first.toBase58(), coins: coins);
    
    var result = await _adapter.signAndSendTransactions([base58.encode(trx.serialize().asUint8List())]);
    showSuccess(result.signatures.first.toString());
  }

}