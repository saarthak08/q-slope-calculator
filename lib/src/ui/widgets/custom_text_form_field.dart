import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';

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
  final bool? readOnly;
  final void Function()? onClickIcon;
  final IconData? icon;

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
    this.readOnly,
    this.onClickIcon,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
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
                            fontSize: getBodyFontSize(context)),
                      ))
                  : Container(),
              onClickIcon != null && icon != null
                  ? InkWell(
                      onTap: onClickIcon,
                      child: Icon(
                        icon,
                        size: 20,
                      ),
                    )
                  : Container()
            ]),
        titleText != null
            ? SizedBox(
                height: getViewPortHeight(context) * 0.01,
              )
            : Container(),
        TextFormField(
            readOnly: readOnly ?? false,
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
            style: GoogleFonts.poppins(fontSize: getBodyFontSize(context)),
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
                errorStyle:
                    GoogleFonts.openSans(fontSize: getCaptionFontSize(context)),
                errorMaxLines: 3,
                hintMaxLines: 3,
                helperMaxLines: 3,
                helperText: hintText,
                helperStyle: GoogleFonts.openSans(
                    color: Colors.grey.shade700,
                    fontSize: getCaptionFontSize(context)),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelStyle: GoogleFonts.openSans(
                    color: Colors.grey.shade500,
                    fontSize: getBodyFontSize(context)),
                labelText: placeholderText))
      ],
    );
  }
}
