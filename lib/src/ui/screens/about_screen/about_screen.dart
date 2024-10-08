import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:q_slope_calculator/src/constants/assets.dart';
import 'package:q_slope_calculator/src/constants/strings.dart';
import 'package:q_slope_calculator/src/ui/widgets/divider_widget.dart';
import 'package:q_slope_calculator/src/utils/common_utils.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  static const route = "/about";
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: primaryColor,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 1,
          shadowColor: Colors.white,
        ),
        body: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: getViewPortWidth(context) * 0.05),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Center(
                child: Image.asset(
              Assets.pngIcon,
              height: getViewPortHeight(context) * 0.2,
            )),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context).appName.toUpperCase(),
                  style: GoogleFonts.montserrat(
                      color: primaryColor,
                      fontSize: getTitleFontSize(context),
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  AppLocalizations.of(context)
                      .homeScreenAppBarSubtitle(khyatiGupta),
                  textAlign: TextAlign.end,
                  style: GoogleFonts.montserrat(
                      color: primaryColor,
                      fontSize: getSubTitleFontSize(context),
                      fontWeight: FontWeight.w500),
                ),
                Container(
                    margin: EdgeInsets.symmetric(
                        vertical: getViewPortHeight(context) * 0.02),
                    child: const DividerWidget()),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context).aboutQSlope,
                      style: GoogleFonts.poppins(
                          fontSize: getSubTitleFontSize(context),
                          color: primaryColor),
                    )),
                SizedBox(
                  height: getViewPortHeight(context) * 0.01,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context).aboutQSlopeInfo,
                      textAlign: TextAlign.justify,
                    )),
                Container(
                    margin: EdgeInsets.symmetric(
                        vertical: getViewPortHeight(context) * 0.02),
                    child: const DividerWidget()),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context).references,
                      style: GoogleFonts.poppins(
                          fontSize: getSubTitleFontSize(context),
                          color: primaryColor),
                    )),
                SizedBox(
                  height: getViewPortHeight(context) * 0.01,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                        onTap: () async {
                          final uri = Uri.tryParse(reference1Link);
                          if (uri != null && await canLaunchUrl(uri)) {
                            launchUrl(uri,
                                mode: LaunchMode.externalApplication);
                          }
                        },
                        child: const Text(
                          reference1,
                          style: TextStyle(
                              color: Colors.blueAccent,
                              decoration: TextDecoration.underline),
                        ))),
                SizedBox(
                  height: getViewPortHeight(context) * 0.01,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                        onTap: () async {
                          final uri = Uri.tryParse(reference2Link);
                          if (uri != null && await canLaunchUrl(uri)) {
                            launchUrl(uri,
                                mode: LaunchMode.externalApplication);
                          }
                        },
                        child: const Text(
                          reference2,
                          style: TextStyle(
                              color: Colors.blueAccent,
                              decoration: TextDecoration.underline),
                        ))),
                Container(
                    margin: EdgeInsets.symmetric(
                        vertical: getViewPortHeight(context) * 0.02),
                    child: const DividerWidget()),
                Row(children: [
                  Text(
                    AppLocalizations.of(context).contactUs,
                    style: GoogleFonts.poppins(
                        fontSize: getSubTitleFontSize(context),
                        color: primaryColor),
                  ),
                  IconButton(
                    onPressed: () async {
                      final uri = Uri.tryParse(mail);
                      if (uri != null && await canLaunchUrl(uri)) {
                        launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    },
                    icon: const Icon(Icons.mail),
                    color: primaryColor,
                  ),
                ]),
                Container(
                    margin: EdgeInsets.symmetric(
                        vertical: getViewPortHeight(context) * 0.02),
                    child: const DividerWidget()),
                Align(
                    alignment: Alignment.center,
                    child: InkWell(
                        onTap: () async {
                          final uri = Uri.tryParse(privacyPolicyLink);
                          if (uri != null && await canLaunchUrl(uri)) {
                            launchUrl(uri,
                                mode: LaunchMode.externalApplication);
                          }
                        },
                        child: Text(
                          AppLocalizations.of(context).privacyPolicyTitle,
                          style: TextStyle(
                              fontSize: getCaptionFontSize(context),
                              color: primaryColor,
                              decoration: TextDecoration.underline),
                        ))),
                SizedBox(
                  height: getViewPortHeight(context) * 0.01,
                ),
                Align(
                    alignment: Alignment.center,
                    child: FutureBuilder(
                        future: PackageInfo.fromPlatform(),
                        builder: (context, snapshot) => Text(
                              "${AppLocalizations.of(context).version}: ${snapshot.data?.version}",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: getCaptionFontSize(context),
                                  color: Colors.black54),
                            ))),
                Container(
                    alignment: Alignment.center,
                    margin:
                        EdgeInsets.only(top: getDeviceHeight(context) * 0.01),
                    child: Text(
                      "${AppLocalizations.of(context).proudlyBuiltInIndia} ${getCountryFlag()}",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                        fontSize: getCaptionFontSize(context),
                        letterSpacing: 1.0,
                      ),
                    )),
                SizedBox(
                  height: getViewPortHeight(context) * 0.02,
                )
              ],
            )
          ]),
        )));
  }
}
