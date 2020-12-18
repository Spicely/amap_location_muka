import 'dart:async';
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'amap_web_amap.dart';

/// A web implementation of the AmapLocationMuka plugin.
class AmapLocationMukaWeb {
  bool init = false;
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'plugins.muka.com/amap_location',
      const StandardMethodCodec(),
      registrar.messenger,
    );

    final pluginInstance = AmapLocationMukaWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  /// Handles method calls over the MethodChannel of this plugin.
  /// Note: Check the "federated" architecture for a new way of doing this:
  /// https://flutter.dev/go/federated-plugins
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'fetch':
        return fetchLocation();
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'amap_location_muka for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  /// Returns a [String] containing the version of the platform.
  Future<String> fetchLocation() {
    MapOptions _mapOptions = MapOptions(
      zoom: 0,
      viewMode: '2D',
    );
    AMap aMap = AMap('location', _mapOptions);
    aMap.plugin('AMap.Geolocation', () {
      Geolocation geolocation = Geolocation();
      aMap.addControl(geolocation);
      geolocation.getCurrentPosition((status, result) {
        if (status == 'complete') {
          print(result);
        } else {
          print(result);
        }
      });
    });
    return Future.value(null);
  }
}
