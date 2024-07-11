import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget getLogo({required String? logoUrl, required double size}) {
  final String? extension = logoUrl?.split('.').last;

  if (extension == "svg") {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100.0),
      child: SvgPicture.network(logoUrl!,
          width: size, height: size, fit: BoxFit.fill),
    );
  }

  if (logoUrl == null) {
    return Container(
      height: size,
      width: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.amber.withOpacity(0.1), shape: BoxShape.circle),
      child: const Text("?"),
    );
  }

  if (logoUrl.startsWith("assets")) {
      return ClipRRect(
      borderRadius: BorderRadius.circular(100.0),
      child: Image.asset(logoUrl, width: size, height: size, fit: BoxFit.fill));
  }

  return ClipRRect(
      borderRadius: BorderRadius.circular(100.0),
      child: Image.network(logoUrl, width: size, height: size, fit: BoxFit.fill,
          errorBuilder: (context, error, stackTrace) {
        return Container(
          height: size,
          width: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1), shape: BoxShape.circle),
          child: const Text("?"),
        );
      }));
}