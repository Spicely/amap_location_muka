import 'dart:async';
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'package:amap_core/amap_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:js/js.dart';
import 'package:universal_html/html.dart';

/// A web implementation of the AmapLocationMuka plugin.
class AmapLocationMukaWeb {
  bool init = false;
  static StreamController<Event> customStreamController = StreamController();
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
      case 'start':
        return Future.value(null);
      case 'stop':
        return Future.value();
      case 'enableBackground':
        return Future.value();
      case 'disableBackground':
        return Future.value();
      default:
        print(2222);
        throw PlatformException(
          code: 'Unimplemented',
          details: 'amap_location_muka for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  /// Returns a [String] containing the version of the platform.
  Future<dynamic> fetchLocation() {
    Completer completer = Completer<Map<String, dynamic>>();
    MapOptions _mapOptions = MapOptions(
      zoom: 0,
      viewMode: '2D',
    );
    AMap aMap = AMap('location', _mapOptions);

    aMap.plugin(['AMap.Geolocation'], allowInterop(() {
      Geolocation geolocation = Geolocation(GeoOptions());
      aMap.addControl(geolocation);
      geolocation.getCurrentPosition(allowInterop((status, result) {
        if (status == 'complete') {
          completer.complete(Location(
            latitude: result.position.lat,
            longitude: result.position.lng,
            country: result.addressComponent.country,
            province: result.addressComponent.province,
            city: result.addressComponent.city,
            district: result.addressComponent.district,
            street: result.addressComponent.street,
            address: result.formattedAddress,
            accuracy: 0.0,
          ).toJson());
        } else {
          completer.completeError(result.message);
        }
      }));
    }));
    return completer.future;
  }
}
