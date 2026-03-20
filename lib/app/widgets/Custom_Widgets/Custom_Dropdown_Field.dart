import 'package:flutter/material.dart';
import '../../constants/App_Colors.dart';
import '../../widgets/Custom_Widgets/App_Custom_Texts.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final TextStyle? labelStyle;
  final List<String> items;
  final Function(String?) onChanged;
  final IconData? icon;
  final bool? isExpanded;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.icon,
    this.labelStyle,
    this.isExpanded
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Safe check: null-aware
    final safeValue = (value != null && value!.isNotEmpty && items.contains(value))
        ? value
        : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        isDense: true,
        isExpanded: isExpanded ?? false,
        value: safeValue,
        dropdownColor: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: labelStyle ?? const TextStyle(
            fontSize: 13,
            fontFamily: "Times New Roman",
          ),
          isDense: true,
          prefixIcon: icon != null ? Icon(icon) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.dividercolor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.dividercolor, width: 2),
          ),
        ),
        items: items
            .map((e) => DropdownMenuItem(
          value: e,
          child: AppCustomTexts(TextName: e),
        ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
