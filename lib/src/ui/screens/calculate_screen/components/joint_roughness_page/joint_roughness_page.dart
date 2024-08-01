import 'package:flutter/material.dart';
import 'package:q_slope_calculator/src/data/models/joint_character.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/components/next_previous_buttons.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';

class JointRoughnessPage extends StatefulWidget {
  final ValueNotifier<QSlope?> qSlope;
  final PageController pageController;
  final int maxPageValue;
  final ValueNotifier<int> currentPage;

  const JointRoughnessPage(
      {super.key,
      required this.qSlope,
      required this.pageController,
      required this.currentPage,
      required this.maxPageValue});

  @override
  State<JointRoughnessPage> createState() => _JointRoughnessPageState();
}

class _JointRoughnessPageState extends State<JointRoughnessPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _jointRoughness = TextEditingController();
  final TextEditingController _jointRoughnessQuotient = TextEditingController();
  final TextEditingController _jointAlteration = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getViewPortWidth(context) * 0.04,
              vertical: getViewPortHeight(context) * 0.02),
          child: Form(
              key: formKey,
              onChanged: () {
                formKey.currentState?.validate();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ValueListenableBuilder(
                      valueListenable: _jointRoughness,
                      builder: (context, jR, child) => ValueListenableBuilder(
                          valueListenable: _jointAlteration,
                          builder: (context, jA, child) => NextPreviousButtons(
                                pageController: widget.pageController,
                                currentPage: widget.currentPage,
                                maxPageValue: widget.maxPageValue,
                                isNextButtonEnabled:
                                    jR.text.isNotEmpty && jA.text.isNotEmpty,
                                onNext: () {
                                  QSlope? qSlope = widget.qSlope.value;
                                  if (qSlope != null) {
                                    qSlope.jointCharacter = JointCharacter();
                                    qSlope.jointCharacter?.jointAlteration =
                                        double.tryParse(
                                                _jointAlteration.text) ??
                                            1;
                                    qSlope.jointCharacter?.jointRoughness =
                                        double.tryParse(_jointRoughness.text) ??
                                            0;
                                    widget.qSlope.value = qSlope;
                                  }
                                  return true;
                                },
                              )))
                ],
              )),
        )));
  }

  @override
  void dispose() {
    _jointAlteration.dispose();
    _jointRoughness.dispose();
    _jointRoughnessQuotient.dispose();
    super.dispose();
  }
}
