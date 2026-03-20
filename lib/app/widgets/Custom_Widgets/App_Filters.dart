import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/App_Colors.dart';
import 'App_Custom_Texts.dart';

/// Abstract controller so multiple controllers can work with this widget
abstract class SearchFilterController {
  RxString get selectedCategory;
  RxDouble get selectedRadius;

  void updateSearch(String value);
  void updateCategory(String value);
  void updateRadius(double value);
}

class SearchAndFilterBar extends StatelessWidget {
  final SearchFilterController controller;
  final List<String> categories; // dynamic category list
  final String searchHint;       // customizable search hint
  final String categoryLabel;    // customizable label text
  final double horizontalPadding;
  final bool showDistanceSlider;

  const SearchAndFilterBar({
    super.key,
    required this.controller,
    required this.categories,
    this.searchHint = "Search...",
    this.categoryLabel = "Category",
    this.horizontalPadding = 16.0,
    this.showDistanceSlider = true,
  });

  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Field
          TextField(
            onChanged: controller.updateSearch,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: "Search by name, Keyword....",
              hintStyle: const TextStyle(fontSize: 14, color: Colors.grey,fontFamily: "Times New Roman",),
              prefixIcon: const Icon(Icons.search, size: 20),
              isDense: true,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.dividercolor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                BorderSide(color: AppColors.dividercolor, width: 2),
              ),
            ),
          ),

          SizedBox(height: height * 0.015),

          // Category Dropdown
          if (categories.isNotEmpty)
            DropdownButtonFormField<String>(
              value: controller.selectedCategory.value.isEmpty
                  ? null
                  : controller.selectedCategory.value,
              items: categories
                  .map((cat) => DropdownMenuItem<String>(
                value: cat,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8), //  wider padding
                  child: Text(cat, style: const TextStyle(fontSize: 14)),
                ),
              )).toList(),
              onChanged: (value) {
                if (value != null) controller.updateCategory(value);
              },
              dropdownColor: Colors.white,
              menuMaxHeight: 300,
              isDense: true, //  make text field height smaller
              decoration: InputDecoration(
                labelText: categoryLabel,
                labelStyle: const TextStyle(
                    fontSize: 13, fontFamily: "Times New Roman"),
                isDense: true, //  reduces overall height
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6), //  smaller height
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.dividercolor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.dividercolor, width: 2),
                ),
              ),
            ),


          SizedBox(height: height * 0.015),

          /// 📏 Distance Slider
          /// 📏 Distance Slider (optional)
              if (showDistanceSlider)
          Obx(
                () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCustomTexts(
                  TextName:
                  "Distance: ${controller.selectedRadius.value.toStringAsFixed(0)} km",
                  textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(fontFamily: "Times New Roman",),
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.buttonColor,
                    inactiveTrackColor: AppColors.buttonColor.withOpacity(0.3),
                    thumbColor: AppColors.buttonColor,
                    overlayColor: AppColors.buttonColor.withOpacity(0.2),
                    trackHeight: 3,
                    thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 8),
                  ),
                  child: Slider(
                    min: 0,
                    max: 50,
                    divisions: 20,
                    value: controller.selectedRadius.value,
                    onChanged: controller.updateRadius,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
