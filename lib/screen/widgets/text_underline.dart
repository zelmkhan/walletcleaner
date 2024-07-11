import 'package:flutter/material.dart';

class TextUnderline extends StatefulWidget {
  final String text;
  final Function() onTap;
  const TextUnderline({super.key, required this.text, required this.onTap});

  @override
  State<TextUnderline> createState() => _TextUnderlineState();
}

class _TextUnderlineState extends State<TextUnderline> {
  bool isUnderline = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: widget.onTap,
      onHover: (p0) {
        isUnderline = p0;
        setState(() {});
      },
      child: Text(widget.text, style: TextStyle(decoration: isUnderline ? TextDecoration.underline : TextDecoration.none, fontSize: 12.0)));
  }
}