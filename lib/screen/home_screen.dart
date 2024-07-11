import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamb_csb/bl/cubit.dart';
import 'package:lamb_csb/bl/states.dart';
import 'package:lamb_csb/screen/widgets/token_widget.dart';
import 'package:lamb_csb/utils/strings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final blCubit = context.read<BlCubit>();
    return Scaffold(
      body: BlocBuilder<BlCubit, States>(builder: (context, state) {
        if (state is InitialState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 32.0),
                const Text(appName, style: TextStyle(fontSize: 16.0)),
                Expanded(
                    child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                          "Connect your wallet to clear it of small balances and unwanted tokens",
                          style: TextStyle(color: Colors.grey, fontSize: 16.0)),
                      const SizedBox(height: 16.0),
                      TextButton(
                        child: const Text("Connect wallet",
                            style: TextStyle(fontSize: 16.0)),
                        onPressed: () => blCubit.connectAndScanWallet(),
                      ),
                    ],
                  ),
                ))
              ],
            ),
          );
        }

        if (state is LoadingState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 32.0),
                const Text(appName, style: TextStyle(fontSize: 16.0)),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(state.authorizeResult.accounts.first.toBase58()),
                    const SizedBox(width: 16.0),
                    IconButton(
                        onPressed: () => blCubit.disconnectWallet(),
                        icon: const Icon(Icons.logout_rounded, size: 21.0)),
                  ],
                ),
                Expanded(
                    child: Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    backgroundColor: Colors.grey.withOpacity(0.1),
                  ),
                ))
              ],
            ),
          );
        }

        if (state is LoadedState) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 32.0),
                const Text(appName, style: TextStyle(fontSize: 16.0)),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(state.authorizeResult.accounts.first.toBase58()),
                    const SizedBox(width: 16.0),
                    IconButton(
                        onPressed: () => blCubit.disconnectWallet(),
                        icon: const Icon(Icons.logout_rounded, size: 21.0)),
                  ],
                ),
                state.tokens.isNotEmpty
                    ? Column(children: [
                      const SizedBox(height: 50.0),
                        Center(
                          child: Text(state.sludge,
                              style: const TextStyle(
                                  fontSize: 66.0, fontWeight: FontWeight.w500)),
                        ),
                        const Center(
                          child: Text(
                              "Changing wallet balance after clearing",
                              style: TextStyle(color: Colors.grey)),
                        ),
                        const SizedBox(height: 24.0),
                        InkWell(
                          onTap: () => blCubit.clearWallet(coins: state.tokens),
                          borderRadius: BorderRadius.circular(50.0),
                          child: Container(
                            height: 40.0,
                            width: 180.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                color: Colors.greenAccent.withOpacity(0.1),
                                border: Border.all(
                                    color:
                                        Colors.greenAccent.withOpacity(0.8))),
                            alignment: Alignment.center,
                            child: const Text("Clear",
                                style: TextStyle(fontSize: 16.0)),
                          ),
                        ),
                        const SizedBox(height: 50.0),
                        SizedBox(
                          height: state.tokens.length * 80.0,
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: state.tokens.length,
                              itemBuilder: (context, index) {
                                return TokenWidget(
                                    coin: state.tokens[index],
                                    valueChanged: (value) {
                                      state.tokens[index].isSelected =
                                          !state.tokens[index].isSelected;
                                      blCubit.updateTokenList(
                                          coins: state.tokens);
                                    });
                              }),
                        ),
                      ])
                    : Container(
                      height: MediaQuery.of(context).size.height / 1.1,
                      alignment: Alignment.center,
                        child: const Text("Your wallet clean 🫧",
                            style: TextStyle(fontSize: 16.0)),
                    )
              ],
            ),
          );
        }

        return const SizedBox();
      }),
    );
  }
}
