import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_freaks_flutter/core/constants/app_colors.dart';

/// A custom CupertinoStylePicker that mimics the native iOS picker style
class CupertinoStylePicker extends StatelessWidget {
  /// Title displayed at the top of the picker
  final String title;

  /// Child widget (typically a CupertinoPicker)
  final Widget child;

  /// Callback when Done button is pressed
  final VoidCallback onDone;

  /// Callback when Cancel button is pressed
  final VoidCallback? onCancel;

  /// Height of the picker container
  final double height;

  /// Background opacity
  final double backgroundOpacity;

  const CupertinoStylePicker({
    Key? key,
    required this.title,
    required this.child,
    required this.onDone,
    this.onCancel,
    this.height = 300,
    this.backgroundOpacity = 0.95,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(backgroundOpacity),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          height: height,
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.3),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Cancel button
                    TextButton(
                      onPressed: () {
                        onCancel?.call();
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),

                    // Title
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),

                    // Done button
                    TextButton(
                      onPressed: () {
                        onDone();
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Done",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.vibrantTeal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Picker content
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper class to show age, height, and weight pickers
class PickerHelper {
  /// Shows age picker with a CupertinoStylePicker
  static void showAgePicker({
    required BuildContext context,
    required int initialAge,
    required ValueChanged<int> onAgeChanged,
    required VoidCallback onDone,
  }) {
    int selectedAge = initialAge;

    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoStylePicker(
        title: "Select Age",
        onDone: onDone,
        child: Container(
          color: Colors.black.withOpacity(0.9),
          child: CupertinoPicker(
            magnification: 1.2,
            backgroundColor: Colors.transparent,
            itemExtent: 40,
            diameterRatio: 1.5,
            onSelectedItemChanged: (index) {
              selectedAge = index + 1; // Age starts from 1
              onAgeChanged(selectedAge);
            },
            children: List<Widget>.generate(120, (index) {
              final age = index + 1;
              return Container(
                alignment: Alignment.center,
                child: Text(
                  "$age years",
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              );
            }),
            scrollController: FixedExtentScrollController(
              initialItem: initialAge - 1,
            ),
          ),
        ),
      ),
    );
  }

  /// Shows height picker with a CupertinoStylePicker
  static void showHeightPicker({
    required BuildContext context,
    required double initialHeight,
    required bool isMetric,
    required ValueChanged<double> onHeightChanged,
    required VoidCallback onDone,
  }) {
    double selectedHeight = initialHeight;

    if (isMetric) {
      // Metric heights (cm)
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoStylePicker(
          title: "Select Height",
          onDone: onDone,
          child: Container(
            color: Colors.black.withOpacity(0.9),
            child: CupertinoPicker(
              magnification: 1.2,
              backgroundColor: Colors.transparent,
              itemExtent: 40,
              diameterRatio: 1.5,
              onSelectedItemChanged: (index) {
                selectedHeight = index + 120.0; // Start from 120cm
                onHeightChanged(selectedHeight);
              },
              children: List<Widget>.generate(101, (index) {
                final height = index + 120;
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    "$height cm",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                );
              }),
              scrollController: FixedExtentScrollController(
                initialItem: (initialHeight.toInt() - 120),
              ),
            ),
          ),
        ),
      );
    } else {
      // Imperial heights (inches, displayed as feet and inches)
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoStylePicker(
          title: "Select Height",
          onDone: onDone,
          child: Container(
            color: Colors.black.withOpacity(0.9),
            child: CupertinoPicker(
              magnification: 1.2,
              backgroundColor: Colors.transparent,
              itemExtent: 40,
              diameterRatio: 1.5,
              onSelectedItemChanged: (index) {
                selectedHeight = index + 48.0; // Start from 48 inches (4'0")
                onHeightChanged(selectedHeight);
              },
              children: List<Widget>.generate(37, (index) {
                final height = index + 48;
                final feet = height ~/ 12;
                final inches = height % 12;
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    "$feet'$inches\"",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                );
              }),
              scrollController: FixedExtentScrollController(
                initialItem: (initialHeight.toInt() - 48),
              ),
            ),
          ),
        ),
      );
    }
  }

  /// Shows weight picker with a CupertinoStylePicker
  static void showWeightPicker({
    required BuildContext context,
    required double initialWeight,
    required bool isMetric,
    required ValueChanged<double> onWeightChanged,
    required VoidCallback onDone,
  }) {
    double selectedWeight = initialWeight;

    if (isMetric) {
      // Metric weights (kg)
      final initialIndex = ((initialWeight - 40.0) * 2).toInt();

      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoStylePicker(
          title: "Select Weight",
          onDone: onDone,
          child: Container(
            color: Colors.black.withOpacity(0.9),
            child: CupertinoPicker(
              magnification: 1.2,
              backgroundColor: Colors.transparent,
              itemExtent: 40,
              diameterRatio: 1.5,
              onSelectedItemChanged: (index) {
                selectedWeight = 40.0 +
                    (index * 0.5); // Start from 40kg with 0.5kg increments
                onWeightChanged(selectedWeight);
              },
              children: List<Widget>.generate(221, (index) {
                final weight = 40.0 + (index * 0.5);
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    "${weight.toStringAsFixed(1)} kg",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                );
              }),
              scrollController: FixedExtentScrollController(
                initialItem: initialIndex,
              ),
            ),
          ),
        ),
      );
    } else {
      // Imperial weights (lb)
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoStylePicker(
          title: "Select Weight",
          onDone: onDone,
          child: Container(
            color: Colors.black.withOpacity(0.9),
            child: CupertinoPicker(
              magnification: 1.2,
              backgroundColor: Colors.transparent,
              itemExtent: 40,
              diameterRatio: 1.5,
              onSelectedItemChanged: (index) {
                selectedWeight = 88.0 + index.toDouble(); // Start from 88 lbs
                onWeightChanged(selectedWeight);
              },
              children: List<Widget>.generate(243, (index) {
                final weight = 88 + index;
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    "$weight lb",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                );
              }),
              scrollController: FixedExtentScrollController(
                initialItem: (initialWeight.toInt() - 88),
              ),
            ),
          ),
        ),
      );
    }
  }

  /// Shows calorie target picker with a CupertinoStylePicker
  static void showCalorieTargetPicker({
    required BuildContext context,
    required int initialCalories,
    required ValueChanged<int> onCaloriesChanged,
    required VoidCallback onDone,
  }) {
    int selectedCalories = initialCalories;

    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoStylePicker(
        title: "Daily Calorie Target",
        onDone: onDone,
        child: Container(
          color: Colors.black.withOpacity(0.9),
          child: CupertinoPicker(
            magnification: 1.2,
            backgroundColor: Colors.transparent,
            itemExtent: 40,
            diameterRatio: 1.5,
            onSelectedItemChanged: (index) {
              selectedCalories =
                  1200 + (index * 50); // Start from 1200 with 50 cal increments
              onCaloriesChanged(selectedCalories);
            },
            children: List<Widget>.generate(58, (index) {
              final calories = 1200 + (index * 50);
              return Container(
                alignment: Alignment.center,
                child: Text(
                  "$calories calories",
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              );
            }),
            scrollController: FixedExtentScrollController(
              initialItem: ((initialCalories - 1200) ~/ 50),
            ),
          ),
        ),
      ),
    );
  }

  /// Shows protein target picker with a CupertinoStylePicker
  static void showProteinTargetPicker({
    required BuildContext context,
    required double initialProtein,
    required ValueChanged<double> onProteinChanged,
    required VoidCallback onDone,
  }) {
    double selectedProtein = initialProtein;

    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoStylePicker(
        title: "Daily Protein Target",
        onDone: onDone,
        child: Container(
          color: Colors.black.withOpacity(0.9),
          child: CupertinoPicker(
            magnification: 1.2,
            backgroundColor: Colors.transparent,
            itemExtent: 40,
            diameterRatio: 1.5,
            onSelectedItemChanged: (index) {
              selectedProtein =
                  50.0 + (index * 5); // Start from 50g with 5g increments
              onProteinChanged(selectedProtein);
            },
            children: List<Widget>.generate(61, (index) {
              final protein = 50.0 + (index * 5);
              return Container(
                alignment: Alignment.center,
                child: Text(
                  "${protein.toInt()} g",
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              );
            }),
            scrollController: FixedExtentScrollController(
              initialItem: ((initialProtein - 50) ~/ 5),
            ),
          ),
        ),
      ),
    );
  }
}
