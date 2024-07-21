import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q_slope_calculator/src/constants/assets.dart';
import 'package:q_slope_calculator/src/constants/strings.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/calculate_screen.dart';
import 'package:q_slope_calculator/src/ui/widgets/illustration_widget.dart';
import 'package:q_slope_calculator/src/utils/color_pallet.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';

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
                  appName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "by Khyati Gupta",
                  textAlign: TextAlign.end,
                  style: GoogleFonts.montserrat(
                      fontSize: getViewPortWidth(context) * 0.04),
                ),
              ],
            )),
        floatingActionButton: FloatingActionButton.extended(
          splashColor: Colors.teal.withOpacity(0.2),
          label: SizedBox(
              width: getViewPortWidth(context) * 0.225,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.teal,
                  ),
                  Text(
                    "Calculate",
                    style: TextStyle(color: Colors.teal),
                  ),
                ],
              )),
          backgroundColor: white,
          onPressed: () {
            Navigator.pushNamed(context, CalculateScreen.route);
          },
        ),
        body: const Center(
            child: IllustrationWidget(
          assetPath: Assets.noData,
          text: "No previous calculations found",
          onRefresh: null,
        )));
  }
}
