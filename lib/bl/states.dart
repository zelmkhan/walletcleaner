import 'package:lamb_csb/models/coin.dart';
import 'package:solana_wallet_adapter/solana_wallet_adapter.dart';

abstract class States {}

class InitialState extends States {}

class LoadingState extends States {
  final AuthorizeResult authorizeResult;
  LoadingState({required this.authorizeResult});
}

class LoadedState extends States {
  final AuthorizeResult authorizeResult;
  final List<Coin> tokens;
  final String sludge;
  LoadedState({required this.authorizeResult, required this.tokens, required this.sludge});
}