import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

showGenericDialog(
    {required BuildContext context,
    String? titleText,
    required String label,
    Future<void> Function()? onOk,
    bool hideCancel = false,
    bool barrierDismissable = true}) async {
  return showAdaptiveDialog(
      barrierDismissible: barrierDismissable,
      context: context,
      builder: (BuildContext context) => Container(
            decoration:
                const BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.4)),
            child: AlertDialog(
              title: titleText != null
                  ? Text(
                      titleText,
                      style: GoogleFonts.montserrat(
                          fontSize: getTitleFontSize(context)),
                    )
                  : null,
              content: Text(
                label,
                style: TextStyle(fontSize: getBodyFontSize(context)),
              ),
              actions: <Widget>[
                !hideCancel
                    ? TextButton(
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.white),
                            elevation: WidgetStateProperty.all(0),
                            padding: WidgetStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal:
                                        getViewPortWidth(context) * 0.05))),
                        onPressed: () => Navigator.pop(
                          context,
                        ),
                        child: Text(
                          AppLocalizations.of(context).cancel,
                          style: TextStyle(fontSize: getBodyFontSize(context)),
                        ),
                      )
                    : Container(),
                TextButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                      elevation: WidgetStateProperty.all(0),
                      padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                          horizontal: getDeviceWidth(context) * 0.05))),
                  onPressed: () async {
                    if (onOk != null) {
                      await onOk();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context).ok,
                    style: TextStyle(fontSize: getBodyFontSize(context)),
                  ),
                ),
              ],
            ),
          ));
}
