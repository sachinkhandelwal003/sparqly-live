import 'package:flutter/material.dart';
import '../../constants/App_Colors.dart';
import 'App_Custom_Texts.dart';

 class AppCustomButton extends StatelessWidget {
   final VoidCallback action;
   final Color?  color ;
   final double? height;
   final double? width;
   final double? borderradius;
   final double? widthsize;
   final Color? widthColor;
   final BoxShape? boxshape;
   final String? ButtonName;
   final TextStyle? textStyle;
   final Widget? CustomName;
   final EdgeInsets? padding;


   const AppCustomButton({
     super.key,
     required this.action,
     this.color,
      this.height,
      this.width,
     this.borderradius,
     this.widthsize,
     this.widthColor,
     this.boxshape,
      this.ButtonName,
     this.textStyle,
     this.CustomName,
     this.padding
   });

   @override
   Widget build(BuildContext context) {
     return InkWell(
       splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
       onTap: action,
       child: Container(
         padding: padding,
         alignment: Alignment.center,
         height: height,
         width: width,
         decoration: BoxDecoration(
             color:color ?? AppColors.buttonColor,
             borderRadius: boxshape == BoxShape.circle ? null : BorderRadius.circular(borderradius ?? 0),
             border: Border.all(
               width: widthsize ?? 0,
               color: widthColor ?? Colors.transparent,
             ),
             shape: boxshape ?? BoxShape.rectangle
         ),
         child: CustomName ?? AppCustomTexts(TextName: ButtonName ?? '',textStyle: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w600,color: AppColors.white),)
       ),
     );
   }
 }