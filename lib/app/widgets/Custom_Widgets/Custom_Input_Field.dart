
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Custom_Input_Decoration_Helper.dart';
import 'Custom_Input_Field.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final String? hint;
  final IconData? icon;
  final int maxLines;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final TextInputType? keyboard;
  final bool? enable;

  const CustomInputField({
    super.key,
    required this.label,
    this.hint,
    this.icon,
    this.maxLines = 1,
    this.controller,
    this.onChanged,
    this.keyboard,
    this.enable,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        enabled: enable,
        controller: controller,
        maxLines: maxLines,
        onChanged: onChanged,
        keyboardType: keyboard,
        decoration: appInputDecoration(context, label, prefixIcon: icon).copyWith(
          hintText: hint,
          hintStyle: Theme.of(Get.context!).textTheme.bodyLarge!.copyWith(
              fontFamily: "Times New Roman", color: Colors.grey.shade600),
        ),
      ),
    );
  }
}
