import 'package:flutter/material.dart';
import '../../constants/App_Colors.dart';
import 'App_Custom_TextStyle.dart';
import 'App_Custom_Texts.dart';

class AppCustomDivider extends StatelessWidget {
  final String? TextName;

  final Color? Dividerstartcolor;
  final Color? Dividerendcolor;
  final double? DividerThickness;

  const AppCustomDivider({
    super.key,
    this.TextName,
    this.Dividerstartcolor,
    this.Dividerendcolor,
    this.DividerThickness,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.03,
      width: size.width * 0.80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: SizedBox(width: size.width*0.28, child: Divider(endIndent: 10, thickness: DividerThickness, color:Dividerstartcolor ?? AppColors.dividercolor,))),
         AppCustomTexts(TextName: TextName ?? '', textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w300 , color: AppColors.dividercolor),),
          Expanded(child: SizedBox(width: size.width*0.28, child: Divider(indent: 10, thickness: DividerThickness, color:Dividerendcolor ?? AppColors.dividercolor))),
        ],
      ),
    );
  }
}