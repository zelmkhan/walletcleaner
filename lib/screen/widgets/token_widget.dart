import 'package:flutter/material.dart';
import 'package:lamb_csb/models/coin.dart';
import 'package:lamb_csb/screen/widgets/text_underline.dart';
import 'package:lamb_csb/utils/functions.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'package:lamb_csb/utils/extensions.dart';

class TokenWidget extends StatefulWidget {
  final Coin coin;
  final ValueChanged<bool> valueChanged;
  const TokenWidget({super.key, required this.coin, required this.valueChanged});

  @override
  State<TokenWidget> createState() => _TokenWidgetState();
}

class _TokenWidgetState extends State<TokenWidget> {
  bool isChosen = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: SizedBox(
          width: 600.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: isChosen,
                    onChanged: (value) {
                      isChosen = value!;
                      widget.valueChanged(value);
                      setState(() {});
                    },
                    shape: const CircleBorder(),
                  ),
                  const SizedBox(width: 16.0),
                  getLogo(logoUrl: widget.coin.logoURI, size: 35.0),
                  const SizedBox(width: 16.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(widget.coin.symbol != null
                          ? "${widget.coin.symbol} (${widget.coin.name})"
                          : "Unknown"),
                      Row(
                        children: [
                          TextUnderline(
                              text: widget.coin.mint!,
                              onTap: () async => await js.context.callMethod(
                                  'open',
                                  ['https://solscan.io/address/${widget.coin.mint!}'])),
                          const SizedBox(width: 8.0),
                          const Icon(Icons.open_in_new_rounded, size: 12.0),
                        ],
                      )
                    ],
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("\$${widget.coin.usdBalance?.formatNumWithCommas() ?? "0"}"),
                  Text(widget.coin.amount!.uiAmountString.formatNumWithCommas(),
                      style: const TextStyle(color: Colors.grey)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
