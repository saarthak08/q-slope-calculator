import 'package:flutter/material.dart';
import 'package:q_slope_calculator/src/ui/screens/photo_view_screen/photo_view_screen.dart';
import 'package:q_slope_calculator/src/ui/widgets/custom_text_form_field.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';

class JointCharacterValueWidget extends StatelessWidget {
  final List<TextEditingController> textEditingControllers;
  final String inputTitle;
  final String? imagePath;
  final String? inputPlaceholderText;
  final bool shouldIncludeIndexInPlaceholderText;
  final bool? readOnly;
  final String? Function(String?)? validateInput;
  final List<TextEditingController>? jointRoughnessControllers;
  final List<TextEditingController>? jointWavynessControllers;
  final List<TextEditingController>? jointSmoothnessControllers;

  const JointCharacterValueWidget(
      {super.key,
      required this.textEditingControllers,
      required this.inputTitle,
      this.imagePath,
      this.validateInput,
      this.inputPlaceholderText,
      this.readOnly,
      this.jointRoughnessControllers,
      this.jointWavynessControllers,
      this.jointSmoothnessControllers,
      this.shouldIncludeIndexInPlaceholderText = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                  flex: 10,
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getViewPortWidth(context) * 0.01),
                      child: Text(
                        inputTitle,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                            fontSize: getBodyFontSize(context)),
                      ))),
              imagePath != null
                  ? Flexible(
                      child: InkWell(
                      child: const Icon(Icons.help_outline, size: 20),
                      onTap: () {
                        Navigator.pushNamed(context, PhotoViewScreen.route,
                            arguments: AssetImage(imagePath ?? ""));
                      },
                    ))
                  : Container()
            ]),
        SizedBox(
          height: getViewPortHeight(context) * 0.01,
        ),
        SizedBox(
            height: 80,
            child: ListView.builder(
                primary: true,
                scrollDirection: Axis.horizontal,
                physics: const AlwaysScrollableScrollPhysics(
                    parent: ClampingScrollPhysics()),
                itemCount: textEditingControllers.length,
                itemBuilder: (context, index) => SizedBox(
                    width: getViewPortWidth(context) * 0.2,
                    child: Padding(
                        padding: EdgeInsets.only(
                            right: getViewPortWidth(context) * 0.02),
                        child: CustomTextFormField(
                          readOnly: readOnly,
                          onChanged: (value) {
                            double? doubleValue = double.tryParse(value);
                            if (jointRoughnessControllers != null &&
                                doubleValue != null) {
                              if (jointWavynessControllers != null) {
                                double? wavyness = double.tryParse(
                                    jointWavynessControllers?[index].text ??
                                        "");
                                if (wavyness != null) {
                                  jointRoughnessControllers?[index].text =
                                      (wavyness * doubleValue).toString();
                                }
                              }
                              if (jointSmoothnessControllers != null) {
                                double? smoothness = double.tryParse(
                                    jointSmoothnessControllers?[index].text ??
                                        "");
                                if (smoothness != null) {
                                  jointRoughnessControllers?[index].text =
                                      (smoothness * doubleValue).toString();
                                }
                              }
                            }
                          },
                          textEditingController: textEditingControllers[index],
                          placeholderText: shouldIncludeIndexInPlaceholderText
                              ? "$inputPlaceholderText ${index + 1}"
                              : inputPlaceholderText,
                          validate: validateInput,
                          type: const TextInputType.numberWithOptions(
                              signed: false),
                          textInputAction: TextInputAction.next,
                        ))))),
      ],
    );
  }
}
