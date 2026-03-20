import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sparqly/app/constants/App_Colors.dart';

class AppCustomScaffold extends StatelessWidget{
  final Color? scaffoldbackgroundColor;
  final bool? resize;
  final PreferredSizeWidget? customAppBar;
  final Widget? BottomBar;
  final Widget BodyWidget;
  final FloatingActionButton? floatingActionButton;
  final Widget? drawer;

  const AppCustomScaffold({super.key, this.scaffoldbackgroundColor , this.customAppBar , this.BottomBar , required this.BodyWidget, this.resize , this.floatingActionButton, this.drawer});

  @override
  Widget build(BuildContext context)
  {
    return  Scaffold(
        backgroundColor: scaffoldbackgroundColor ?? AppColors.scaffoldBc,
        drawer: drawer,
        appBar: customAppBar,
        bottomNavigationBar:BottomBar,
        body: SafeArea(child: BodyWidget),
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        resizeToAvoidBottomInset: resize,
    );
  }
}
