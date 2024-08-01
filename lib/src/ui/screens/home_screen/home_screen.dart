import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q_slope_calculator/src/constants/assets.dart';
import 'package:q_slope_calculator/src/constants/strings.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/calculate_screen.dart';
import 'package:q_slope_calculator/src/ui/widgets/illustration_widget.dart';
import 'package:q_slope_calculator/src/utils/color_pallet.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    Assets.pngIcon,
                  ))
            ],
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).appName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  AppLocalizations.of(context)
                      .homeScreenAppBarSubtitle(khyatiGupta),
                  textAlign: TextAlign.end,
                  style: GoogleFonts.montserrat(
                      fontSize: getViewPortWidth(context) * 0.04),
                ),
              ],
            )),
        floatingActionButton: FloatingActionButton.extended(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          splashColor: Colors.teal.withOpacity(0.2),
          label: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.add,
                color: Colors.teal,
              ),
              SizedBox(
                width: getViewPortWidth(context) * 0.02,
              ),
              Text(
                AppLocalizations.of(context).homeScreenCalculateButtonText,
                style: const TextStyle(color: Colors.teal),
              ),
            ],
          ),
          backgroundColor: white,
          onPressed: () {
            Navigator.pushNamed(context, CalculateScreen.route);
          },
        ),
        body: Center(
            child: IllustrationWidget(
          assetPath: Assets.noData,
          text: AppLocalizations.of(context)
              .homeScreenNoPreviousCalculationsFound,
          onRefresh: null,
        )));
  }
}
