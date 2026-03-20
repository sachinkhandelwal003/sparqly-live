import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Texts.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Button.dart';

enum LoaderType { cupertino, material }

class AppLoadingButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final String buttonText;
  final double? height;
  final double? width;
  final double borderradius;
  final LoaderType loaderType;

  const AppLoadingButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.buttonText,
    this.height,
    this.width,
    this.borderradius = 14,
    this.loaderType = LoaderType.cupertino, // default
  });

  Widget _buildLoader() {
    switch (loaderType) {
      case LoaderType.material:
        return const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        );
      case LoaderType.cupertino:
      default:
        return const CupertinoActivityIndicator(color: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return  AppCustomButton(
      height: height ?? 40,
      width: width ?? double.infinity,
      borderradius: borderradius,
      action: isLoading ? () {} : onPressed,
      CustomName: isLoading
          ? _buildLoader()
          : AppCustomTexts(
        TextName: buttonText,
        textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
