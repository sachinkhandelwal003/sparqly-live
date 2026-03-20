import 'package:flutter/material.dart';

class AppCustomContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;
  final double? borderradius;
  final double? widthsize;
  final Color? widthColor;
  final BoxShape? boxshape;
  final Widget? child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final List<BoxShadow>? shadow;

  const AppCustomContainer({
    super.key,
     this.height,
     this.width,
     this.color,
    this.borderradius,
    this.widthsize,
    this.widthColor,
    this.boxshape,
    this.child,
    this.padding,
    this.margin,
    this.shadow
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      height: height,
      width: width,
      decoration: BoxDecoration(
        boxShadow: shadow,
        color: color,
        borderRadius: boxshape == BoxShape.circle
            ? null
            : BorderRadius.circular(borderradius ?? 0),
        border: Border.all(
          width: widthsize ?? 0,
          color: widthColor ?? Colors.transparent,
        ),
        shape: boxshape ?? BoxShape.rectangle,
      ),
      child: child,
    );
  }
}

class AppCustomContainerStack extends StatelessWidget {
  final double hieght;
  final double width;
  final Color color;
  final double? borderradiusleft;
  final double? borderradiusright;
  final double? widthsize;
  final Color? widthColor;
  final BoxShape? boxshape;
  final Widget? child;

  const AppCustomContainerStack({
    super.key,
    required this.hieght,
    required this.width,
    required this.color,
    this.borderradiusleft,
    this.borderradiusright,
    this.widthsize,
    this.widthColor,
    this.boxshape,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(

      height: hieght,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: boxshape == BoxShape.circle
            ? null
            : BorderRadius.only(
                topLeft: Radius.circular(borderradiusleft ?? 0),
                topRight: Radius.circular(borderradiusright ?? 0),
              ),
        border: Border.all(
          width: widthsize ?? 0,
          color: widthColor ?? Colors.transparent,
        ),
        shape: boxshape ?? BoxShape.rectangle,
      ),
      child: child,
    );
  }
}
