import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/App_Colors.dart';

/// Common InputDecoration for all fields
InputDecoration appInputDecoration(
    BuildContext context,
    String label, {
      IconData? prefixIcon,
    }) {
  return InputDecoration(
    isDense: true,
    labelText: label,
    labelStyle: Theme.of(Get.context!)
        .textTheme
        .bodyLarge!
        .copyWith(fontFamily: "Times New Roman", color: Colors.grey.shade600),
    filled: true,
    fillColor: Colors.grey.shade100,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.dividercolor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.dividercolor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.dividercolor, width: 2),
    ),
    prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
  );
}


