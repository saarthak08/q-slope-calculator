import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:q_slope_calculator/src/ui/screens/photo_view_screen/photo_view_screen.dart';
import 'package:q_slope_calculator/src/ui/widgets/custom_text_form_field.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';

class BlockSizePageBasicInfoWidget extends StatelessWidget {
  final TextEditingController locationIdController;
  final TextEditingController lithologyController;
  final TextEditingController slopeAngleByUserController;
  final TextEditingController? benchHeightController;
  final TextEditingController? latitudeController;
  final TextEditingController? longitudeController;
  final TextEditingController? elevationController;
  final ValueNotifier<List<String>>? imagePaths;
  ValueNotifier<List<String>>? get photoPaths => imagePaths;
  final VoidCallback? onCaptureGps;
  final VoidCallback? onViewMap;
  final VoidCallback? onAddImage;
  VoidCallback? get onAddPhoto => onAddImage;
  final ValueChanged<int>? onRemoveImage;
  ValueChanged<int>? get onRemovePhoto => onRemoveImage;

  const BlockSizePageBasicInfoWidget({
    super.key,
    required this.locationIdController,
    required this.lithologyController,
    required this.slopeAngleByUserController,
    this.benchHeightController,
    this.latitudeController,
    this.longitudeController,
    this.elevationController,
    ValueNotifier<List<String>>? imagePaths,
    ValueNotifier<List<String>>? photoPaths,
    this.onCaptureGps,
    this.onViewMap,
    VoidCallback? onAddImage,
    VoidCallback? onAddPhoto,
    ValueChanged<int>? onRemoveImage,
    ValueChanged<int>? onRemovePhoto,
  }) : imagePaths = imagePaths ?? photoPaths,
       onAddImage = onAddImage ?? onAddPhoto,
       onRemoveImage = onRemoveImage ?? onRemovePhoto;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: getViewPortHeight(context) * 0.01),
            child: Text(
              AppLocalizations.of(
                context,
              ).blockSizePageBasicInformationSubTitle,
              style: GoogleFonts.poppins(
                fontSize: getSubtitleLargeFontSize(context),
                color: primaryColor,
              ),
            ),
          ),
        ),
        CustomTextFormField(
          textInputAction: TextInputAction.next,
          textEditingController: locationIdController,
          titleText: AppLocalizations.of(context).locationIdTextInputTitle,
          validate: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context).locationIdTextInputRequired;
            }
            return null;
          },
        ),
        SizedBox(height: getViewPortHeight(context) * 0.03),
        CustomTextFormField(
          textInputAction: TextInputAction.next,
          textEditingController: lithologyController,
          titleText: AppLocalizations.of(context).lithologyTextInputTitle,
          validate: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context).lithologyTextInputRequired;
            }
            return null;
          },
        ),
        SizedBox(height: getViewPortHeight(context) * 0.03),
        CustomTextFormField(
          textInputAction: TextInputAction.next,
          textEditingController: slopeAngleByUserController,
          titleText: AppLocalizations.of(context).slopeAngleByUser,
          type: const TextInputType.numberWithOptions(
            signed: false,
            decimal: true,
          ),
        ),
        SizedBox(height: getViewPortHeight(context) * 0.03),

        // Bench Height (Optional)
        if (benchHeightController != null) ...[
          CustomTextFormField(
            textInputAction: TextInputAction.next,
            textEditingController: benchHeightController!,
            titleText: AppLocalizations.of(context).benchHeight,
            type: const TextInputType.numberWithOptions(
              signed: false,
              decimal: true,
            ),
          ),
          SizedBox(height: getViewPortHeight(context) * 0.03),
        ],

        // GPS Coordinates Section
        if (latitudeController != null && longitudeController != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF232730) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            AppLocalizations.of(context).gpsCoordinates,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: getBodyFontSize(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (onViewMap != null)
                          Tooltip(
                            message: AppLocalizations.of(context).viewOnMap,
                            child: IconButton(
                              icon: const Icon(Icons.map_outlined, size: 18),
                              color: primaryColor,
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.all(4),
                              constraints: const BoxConstraints(),
                              onPressed: onViewMap,
                            ),
                          ),
                        if (onCaptureGps != null)
                          ElevatedButton.icon(
                            icon: const Icon(Icons.my_location, size: 15),
                            label: Text(
                              AppLocalizations.of(context).captureGps,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                            ),
                            onPressed: onCaptureGps,
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        textInputAction: TextInputAction.next,
                        textEditingController: latitudeController!,
                        titleText: AppLocalizations.of(context).latitude,
                        type: const TextInputType.numberWithOptions(
                          signed: true,
                          decimal: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomTextFormField(
                        textInputAction: TextInputAction.next,
                        textEditingController: longitudeController!,
                        titleText: AppLocalizations.of(context).longitude,
                        type: const TextInputType.numberWithOptions(
                          signed: true,
                          decimal: true,
                        ),
                      ),
                    ),
                    if (elevationController != null) ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustomTextFormField(
                          textInputAction: TextInputAction.next,
                          textEditingController: elevationController!,
                          titleText: AppLocalizations.of(context).elevation,
                          type: const TextInputType.numberWithOptions(
                            signed: true,
                            decimal: true,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: getViewPortHeight(context) * 0.03),
        ],

        // Field Images Section
        if (imagePaths != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF232730) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.photo_camera,
                          color: primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            AppLocalizations.of(context).fieldImages,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: getBodyFontSize(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (onAddImage != null)
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add_a_photo, size: 15),
                        label: Text(AppLocalizations.of(context).addImage),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                        ),
                        onPressed: onAddImage,
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                ValueListenableBuilder<List<String>>(
                  valueListenable: imagePaths!,
                  builder: (context, paths, _) {
                    if (paths.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          AppLocalizations.of(context).noImagesAttached,
                          style: TextStyle(
                            fontSize: getCaptionFontSize(context),
                            color: Colors.grey.shade600,
                          ),
                        ),
                      );
                    }

                    return SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: paths.length,
                        separatorBuilder:
                            (context, index) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final path = paths[index];

                          return Stack(
                            children: [
                              _buildImageThumbnail(context, path),
                              if (onRemovePhoto != null)
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: GestureDetector(
                                    onTap: () => onRemovePhoto!(index),
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: getViewPortHeight(context) * 0.03),
        ],
      ],
    );
  }

  Widget _buildImageThumbnail(BuildContext context, String path) {
    Widget imageWidget;
    ImageProvider provider;

    if (path.startsWith('data:image')) {
      final base64String = path.split(',').last;
      final bytes = base64Decode(base64String);
      provider = MemoryImage(bytes);
      imageWidget = Image.memory(
        bytes,
        fit: BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) =>
                const Icon(Icons.broken_image, color: Colors.grey),
      );
    } else if (path.startsWith('http://') ||
        path.startsWith('https://') ||
        path.startsWith('blob:')) {
      provider = NetworkImage(path);
      imageWidget = Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) =>
                const Icon(Icons.broken_image, color: Colors.grey),
      );
    } else {
      final file = File(path);
      provider = FileImage(file);
      imageWidget = Image.file(
        file,
        fit: BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) =>
                const Icon(Icons.broken_image, color: Colors.grey),
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          PhotoViewScreen.route,
          arguments: provider,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 80,
          height: 80,
          color: Colors.grey.shade300,
          child: imageWidget,
        ),
      ),
    );
  }
}
