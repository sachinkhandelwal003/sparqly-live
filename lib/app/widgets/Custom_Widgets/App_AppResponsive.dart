import 'package:flutter/material.dart';

class AppResponsive extends StatelessWidget {
  final Widget Function(
      BuildContext context,
      BoxConstraints constraints,
      MediaQueryData mediaQuery,
      ) builder;

  const AppResponsive({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mediaQuery = MediaQuery.of(context);
        return builder(context, constraints, mediaQuery);
      },
    );
  }
}
