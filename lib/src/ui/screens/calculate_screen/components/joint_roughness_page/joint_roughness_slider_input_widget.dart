import 'package:flutter/material.dart';
import 'package:q_slope_calculator/src/ui/screens/photo_view_screen/photo_view_screen.dart';
import 'package:q_slope_calculator/src/ui/widgets/custom_text_form_field.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';

class JointRoughnessSliderInputWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final String imagePath;
  final String imageTitle;
  final String inputTitle;
  final double maxSliderValue;
  final double minSliderValue;
  final int? sliderDivisions;
  final double imageHeight;
  final String? Function(String?)? validateInput;

  const JointRoughnessSliderInputWidget(
      {super.key,
      required this.textEditingController,
      required this.imagePath,
      required this.imageTitle,
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
        Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getViewPortWidth(context) * 0.01),
            child: Text(
              imageTitle,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  fontSize: getFontSizeAccordingToOrientation(context) * 0.018),
            )),
        Container(
            margin: EdgeInsets.only(top: getViewPortHeight(context) * 0.02),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(5)),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.pushNamed(context, PhotoViewScreen.route,
                          arguments: AssetImage(imagePath));
                    },
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.fill,
                      height: imageHeight,
                      width: getViewPortWidth(context),
                    )))),
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
                  fontSize: getFontSizeAccordingToOrientation(context) * 0.02),
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
