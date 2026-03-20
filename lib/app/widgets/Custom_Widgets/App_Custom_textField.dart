import 'package:flutter/material.dart';
import '../../constants/App_Colors.dart';
import 'App_Controllers.dart';
import 'App_Custom_Texts.dart';

class AppCustomTextfield extends StatelessWidget {
  final double? hight;
  final double? width;
  final String? labeltext;
  final Icon? PrefixIcon;
  final Icon? suffixIcon;
  final String? hinttext;
  final TextStyle? labelStyle;
  final bool? obscuretext;
  final TextEditingController? controller;
  final Color? color;

  const AppCustomTextfield({
    super.key,
     this.labeltext,
    this.hight,
    this.width,
    this.suffixIcon,
    this.PrefixIcon,
    this.hinttext,
    this.controller,
    this.labelStyle,
    this.obscuretext,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
          height: hight,
          width: width,
          child: TextFormField(
            textAlignVertical: TextAlignVertical.center,
            obscureText: obscuretext ?? false,
            onTap: () {
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: TextStyle(color: AppColors.black),
            controller:
                controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: color,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              prefixIcon: PrefixIcon,
              suffixIcon: suffixIcon,
              hintText: hinttext ?? '',
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.dividercolor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        );
  }
}
