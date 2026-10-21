import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

enum GeoFailureReason {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  timeout,
  error,
}

class GeoPositionData {
  final double latitude;
  final double longitude;
  final double? altitude;
  final double? accuracy;

  const GeoPositionData({
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.accuracy,
  });
}

class GeoResult {
  final GeoPositionData? position;
  final GeoFailureReason? failureReason;
  final String? errorMessage;

  const GeoResult.success(GeoPositionData this.position)
    : failureReason = null,
      errorMessage = null;

  const GeoResult.failure(this.failureReason, [this.errorMessage])
    : position = null;

  bool get isSuccess => position != null;
}

class GeoUtils {
  /// Queries current device GPS position with detailed result and fallback mechanisms.
  /// Handles platform-specific quirks (Android permissions, Windows location service, Web HTTPS contexts).
  static Future<GeoResult> getCurrentLocationResult() async {
    try {
      // 1. Verify location services are enabled on the host OS
      bool serviceEnabled = false;
      try {
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
      } catch (e) {
        debugPrint('isLocationServiceEnabled check error: $e');
        // On web or environments where checking fails, continue and let permission/position handle it
        serviceEnabled = true;
      }

      if (!serviceEnabled) {
        return const GeoResult.failure(GeoFailureReason.serviceDisabled);
      }

      // 2. Check and request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return const GeoResult.failure(GeoFailureReason.permissionDenied);
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return const GeoResult.failure(
          GeoFailureReason.permissionDeniedForever,
        );
      }

      // 3. Acquire location coordinates.
      // First attempt high accuracy with a 10s timeout (ideal for hardware GPS on mobile).
      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 10),
          ),
        );
      } catch (e) {
        debugPrint(
          'High accuracy position query failed/timed out: $e. Falling back to medium accuracy...',
        );
        // Medium accuracy fallback (ideal for Windows Wi-Fi/IP location, web, or indoor mobile)
        try {
          position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.medium,
              timeLimit: Duration(seconds: 6),
            ),
          );
        } catch (e2) {
          debugPrint(
            'Medium accuracy query failed: $e2. Trying last known position...',
          );
          try {
            position = await Geolocator.getLastKnownPosition();
          } catch (_) {}
        }
      }

      if (position == null) {
        return const GeoResult.failure(GeoFailureReason.timeout);
      }

      return GeoResult.success(
        GeoPositionData(
          latitude: position.latitude,
          longitude: position.longitude,
          altitude: position.altitude,
          accuracy: position.accuracy,
        ),
      );
    } catch (e) {
      debugPrint('Error getting GPS location: $e');
      return GeoResult.failure(GeoFailureReason.error, e.toString());
    }
  }

  /// Convenience wrapper returning nullable position data for simple callers.
  static Future<GeoPositionData?> getCurrentLocation() async {
    final result = await getCurrentLocationResult();
    return result.position;
  }

  /// Opens the device/system app settings.
  static Future<bool> openAppSettings() async {
    try {
      return await Geolocator.openAppSettings();
    } catch (e) {
      debugPrint('Error opening app settings: $e');
      return false;
    }
  }

  /// Opens the device/system location settings.
  static Future<bool> openLocationSettings() async {
    try {
      return await Geolocator.openLocationSettings();
    } catch (e) {
      debugPrint('Error opening location settings: $e');
      return false;
    }
  }

  /// Opens the given coordinates in external maps (Google Maps / Apple Maps).
  static Future<bool> openInMap(double latitude, double longitude) async {
    final Uri uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching map URL: $e');
    }
    return false;
  }
}
