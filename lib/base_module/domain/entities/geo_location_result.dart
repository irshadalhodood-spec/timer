/// Result of fetching current location and reverse-geocoding to a full address.
/// Stored with attendance (check-in/check-out) for lat, lng, and full address.
class GeoLocationResult {
  const GeoLocationResult({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.street,
    this.locality,
    this.administrativeArea,
    this.postalCode,
    this.country,
  });

  final double latitude;
  final double longitude;
  /// Full formatted address (e.g. "123 Main St, City, State 12345, Country").
  final String address;
  final String? street;
  final String? locality;
  final String? administrativeArea;
  final String? postalCode;
  final String? country;
}
