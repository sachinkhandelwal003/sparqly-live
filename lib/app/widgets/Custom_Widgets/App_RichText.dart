import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'App_Custom_TextStyle.dart';


class AppRichtext extends StatelessWidget {
  final TextStyle? textStyle;
  final TextStyle? textStyle2;
  final Widget? anywidget;
  final String textspan;
  final String? textspan2;
  final TapGestureRecognizer? onTaptext2;

  const AppRichtext({super.key, required this.textspan, this.textspan2 , this.anywidget , this.textStyle , this.textStyle2 , this.onTaptext2});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan( alignment: PlaceholderAlignment.middle ,child: anywidget ?? SizedBox.shrink()),
            TextSpan(text: textspan, style:textStyle ?? AppTextStyle.appTextStylewhite10),
            TextSpan(
              recognizer: onTaptext2,
              text: textspan2 ?? '',
              style:textStyle2 ?? AppTextStyle.appTextStylewhite10,
            ),
          ],
        ),
      ),
    );
  }
}
