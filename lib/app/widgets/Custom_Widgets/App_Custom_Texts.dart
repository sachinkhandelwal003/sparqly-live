import 'dart:ui';

import 'package:flutter/material.dart';

class AppCustomTexts extends StatelessWidget {
  final VoidCallback? action;
  final String TextName;
  final TextStyle? textStyle;
  final TextDecoration? txtdecoration;
  final TextAlign? Textalign;
  final double? paddingHorizontal;
  final int? maxLine;
  final TextOverflow? overflow;

  const AppCustomTexts({super.key, required this.TextName, this.textStyle,this.txtdecoration,this.action,this.Textalign , this.paddingHorizontal , this.maxLine , this.overflow});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal:paddingHorizontal ?? 0 ),
        child: Text(
          textAlign: Textalign,
          TextName,
          style: textStyle ?? Theme.of(context).textTheme.bodyLarge,
          maxLines: maxLine,
          overflow: overflow,

        ),
      ),
    );
  }
}
