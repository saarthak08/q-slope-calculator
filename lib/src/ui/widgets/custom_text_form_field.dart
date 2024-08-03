import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';

class CustomTextFormField extends StatelessWidget {
  final void Function(String)? onChanged;
  final String? hintText;
  final TextInputType? type;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final String? Function(String?)? validate;
  final TextEditingController textEditingController;
  final String? titleText;
  final String? placeholderText;

  const CustomTextFormField({
    super.key,
    this.onChanged,
    this.hintText,
    this.type,
    this.maxLength,
    this.validate,
    this.textInputAction,
    this.titleText,
    required this.textEditingController,
    this.placeholderText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleText != null
            ? Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getViewPortWidth(context) * 0.01),
                child: Text(
                  titleText ?? "",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      fontSize:
                          getFontSizeAccordingToOrientation(context) * 0.018),
                ))
            : Container(),
        titleText != null
            ? SizedBox(
                height: getViewPortHeight(context) * 0.01,
              )
            : Container(),
        TextFormField(
            keyboardType: type,
            controller: textEditingController,
            textInputAction: textInputAction,
            enableSuggestions: true,
            enableIMEPersonalizedLearning: true,
            enableInteractiveSelection: true,
            maxLength: maxLength,
            maxLengthEnforcement: maxLength == null
                ? MaxLengthEnforcement.none
                : MaxLengthEnforcement.enforced,
            onChanged: onChanged,
            validator: validate,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: GoogleFonts.poppins(),
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey.shade400, width: 1.5),
                    borderRadius: BorderRadius.circular(6)),
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey.shade400, width: 1.5),
                    borderRadius: BorderRadius.circular(6)),
                errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 1.5),
                    borderRadius: BorderRadius.circular(6)),
                errorStyle: GoogleFonts.openSans(
                    fontSize:
                        getFontSizeAccordingToOrientation(context) * 0.016),
                errorMaxLines: 3,
                hintMaxLines: 3,
                helperMaxLines: 3,
                helperText: hintText,
                helperStyle: GoogleFonts.openSans(
                  color: Colors.grey.shade700,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelStyle: GoogleFonts.openSans(color: Colors.grey.shade500),
                labelText: placeholderText))
      ],
    );
  }
}
