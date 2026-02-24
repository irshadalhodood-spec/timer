import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class Network {
  Network._internal();

  static final Network _instance = Network._internal();

  factory Network() => _instance;

  final Connectivity _connectivity = Connectivity();

  Future<bool> get isOnline async => _isOnline();

  Future<bool> _isOnline() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      final results = _normalizeResults(connectivityResult);

      debugPrint("Network:_isOnline:connectivityResults:$results");

      final hasConnectivity = results.any(
        (result) =>
            result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi ||
            result == ConnectivityResult.ethernet ||
            result == ConnectivityResult.vpn ||
            result == ConnectivityResult.other,
      );

      debugPrint("Network:_isOnline:hasConnectivity:$hasConnectivity");

      if (!hasConnectivity) {
        debugPrint("Network:_isOnline:no connectivity, returning false");
        return false;
      }

      if (kIsWeb) {
        debugPrint("Network:_isOnline:web platform, assuming online");
        return true;
      }

      debugPrint("Network:_isOnline:testing internet connection via DNS...");

      try {
        final result = await InternetAddress.lookup(
          "google.com",
        ).timeout(const Duration(seconds: 10));

        final isOnline =
            result.isNotEmpty && result.first.rawAddress.isNotEmpty;

        debugPrint("Network:_isOnline:internet test result:$isOnline");
        return isOnline;
      } catch (lookupError) {
        debugPrint("Network:_isOnline:DNS lookup failed:$lookupError");
        debugPrint("Network:_isOnline:trying HTTP fallback...");

        try {
          final client = HttpClient();
          final request = await client
              .getUrl(Uri.parse('https://www.google.com'))
              .timeout(const Duration(seconds: 10));
          final response = await request.close().timeout(
            const Duration(seconds: 10),
          );

          client.close();

          final isOnline = response.statusCode == 200;
          debugPrint("Network:_isOnline:HTTP fallback result:$isOnline");

          return isOnline;
        } catch (httpError) {
          debugPrint("Network:_isOnline:HTTP fallback failed:$httpError");
          return false;
        }
      }
    } catch (e) {
      debugPrint("Network:_isOnline:Exception:$e");
      return false;
    }
  }

  Future<bool> isOnlineLenient() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      final results = _normalizeResults(connectivityResult);

      final hasConnectivity = results.any(
        (result) => result != ConnectivityResult.none,
      );

      return hasConnectivity;
    } catch (e) {
      debugPrint("Network:isOnlineLenient:Exception:$e");
      return false;
    }
  }

  Future<Map<String, dynamic>> getConnectivityDetails() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      final results = _normalizeResults(connectivityResult);

      return {
        'connectivityResults': results.map((r) => r.toString()).toList(),
        'hasConnectivity': results.any(
          (result) => result != ConnectivityResult.none,
        ),
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  List<ConnectivityResult> _normalizeResults(dynamic connectivityResult) {
    if (connectivityResult is List<ConnectivityResult>) {
      return connectivityResult;
    }
    if (connectivityResult is ConnectivityResult) {
      return [connectivityResult];
    }
    return const [ConnectivityResult.none];
  }
}

final network = Network();