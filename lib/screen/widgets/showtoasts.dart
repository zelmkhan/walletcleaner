import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lamb_csb/utils/extensions.dart';
import 'package:oktoast/oktoast.dart';
import 'dart:js' as js;

import 'package:solana_web3/solana_web3.dart';

showMessage(String message) => showToastWidget(
      Container(
        height: 60.0,
        width: 400.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0), color: Colors.black),
        child: Text(message.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white)),
      ),
      duration: const Duration(seconds: 3),
      position: ToastPosition.bottom,
      dismissOtherToast: true,
    );

showLoadingIndicator() => showToastWidget(
      Container(
        height: 60.0,
        width: 400.0,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0), color: Colors.black),
        child: Row(
          children: [
            SizedBox(height: 25.0, width: 25.0, child: CircularProgressIndicator(color: Colors.purple, backgroundColor: Colors.purple.withOpacity(0.4), strokeWidth: 2.0)),
            const SizedBox(width: 16.0),
            const Text("Transaction processing...", style: TextStyle(color: Colors.white))
          ],
        ),
      ),
      duration: const Duration(seconds: 120),
      dismissOtherToast: true,
      position: ToastPosition.bottom,
    );

showSuccess(String message) => showToastWidget(
      InkWell(
        onTap: () => js.context.callMethod('open', ["https://solscan.io/tx/$message"]),
        child: Container(
          height: 60.0,
          width: 400.0,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0), color: Colors.black),
          child: Row(
            children: [
              const Icon(Icons.check_circle_outline_rounded, size: 32.0, color: Colors.greenAccent),
              const SizedBox(width: 8.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Transaction successfull!", style: TextStyle(color: Colors.grey.shade300)),
                  Text(base58.encode(base64.decode(message)).cutText(), style: const TextStyle(color: Colors.white)),
                ],
              )
            ],
          ),
        ),
      ),
      dismissOtherToast: true,
      duration: const Duration(seconds: 3),
      position: ToastPosition.bottom,
    );
