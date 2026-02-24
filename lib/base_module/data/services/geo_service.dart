import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../domain/entities/geo_location_result.dart';

class GeoService {
  Future<GeoLocationResult?> getCurrentLocationWithAddress() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    final p = placemarks.isNotEmpty ? placemarks.first : null;
    final address = _formatFullAddress(
      p,
      position.latitude,
      position.longitude,
    );

    return GeoLocationResult(
      latitude: position.latitude,
      longitude: position.longitude,
      address: address,
      street: p?.street,
      locality: p?.locality,
      administrativeArea: p?.administrativeArea,
      postalCode: p?.postalCode,
      country: p?.country,
    );
  }

  static String _formatFullAddress(Placemark? p, double lat, double lng) {
    if (p == null) {
      return '${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}';
    }
    final parts = <String>[];
    if (p.street != null && p.street!.isNotEmpty) parts.add(p.street!);
    if (p.subLocality != null && p.subLocality!.isNotEmpty) {
      parts.add(p.subLocality!);
    }
    if (p.locality != null && p.locality!.isNotEmpty) parts.add(p.locality!);
    if (p.administrativeArea != null && p.administrativeArea!.isNotEmpty) {
      parts.add(p.administrativeArea!);
    }
    if (p.postalCode != null && p.postalCode!.isNotEmpty) {
      parts.add(p.postalCode!);
    }
    if (p.country != null && p.country!.isNotEmpty) parts.add(p.country!);
    if (parts.isEmpty) {
      return '${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}';
    }
    return parts.join(', ');
  }
}
