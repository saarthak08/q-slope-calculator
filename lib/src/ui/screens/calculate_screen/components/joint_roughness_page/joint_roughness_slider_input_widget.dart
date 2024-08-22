import 'package:flutter/material.dart';
import 'package:q_slope_calculator/src/ui/widgets/custom_text_form_field.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';

class JointRoughnessSliderInputWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final String inputTitle;
  final double maxSliderValue;
  final double minSliderValue;
  final int? sliderDivisions;
  final double imageHeight;
  final String? Function(String?)? validateInput;

  const JointRoughnessSliderInputWidget(
      {super.key,
      required this.textEditingController,
      required this.inputTitle,
      required this.maxSliderValue,
      required this.minSliderValue,
      this.sliderDivisions,
      this.validateInput,
      required this.imageHeight});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: getViewPortHeight(context) * 0.03,
        ),
        Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getViewPortWidth(context) * 0.01),
            child: Text(
              inputTitle,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  fontSize: getBodyFontSize(context)),
            )),
        ValueListenableBuilder(
            valueListenable: textEditingController,
            builder: (context, textController, child) => Slider(
                value: double.tryParse(textController.text) != null &&
                        double.parse(textController.text) >= minSliderValue &&
                        double.parse(textController.text) <= maxSliderValue
                    ? double.parse(textController.text)
                    : minSliderValue,
                max: maxSliderValue,
                label: textController.text,
                min: minSliderValue,
                divisions: sliderDivisions,
                onChanged: (value) {
                  textEditingController.text = value.toStringAsFixed(4);
                })),
        CustomTextFormField(
          type: const TextInputType.numberWithOptions(signed: false),
          textInputAction: TextInputAction.next,
          textEditingController: textEditingController,
          validate: validateInput,
        ),
      ],
    );
  }
}
