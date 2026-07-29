import 'package:flutter/material.dart';
import 'package:q_slope_calculator/src/ui/widgets/custom_progress_indicator.dart';

void showFullScreenLoader(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (ctx) => PopScope(
          canPop: false,
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.4),
            ),
            child: const Center(child: CustomProgressIndicator()),
          ),
        ),
  );
}
