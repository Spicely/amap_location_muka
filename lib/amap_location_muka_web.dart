import 'dart:async';
import 'dart:js';
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'package:amap_core/amap_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'amap_location_muka.dart';

/// A web implementation of the AmapLocationMuka plugin.
class AmapLocationMukaWeb {
  Timer? _timer;

  bool init = false;

  static void registerWith(Registrar registrar) {
    MethodChannel channel = MethodChannel(
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
        _timer?.cancel();
        _timer = null;
        return listenLocation(call.arguments);
      case 'stop':
        _timer?.cancel();
        _timer = null;
        return Future.value(null);
      case 'enableBackground':
        return Future.value(null);
      case 'disableBackground':
        return Future.value(null);
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'amap_location_muka for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  /// Returns a [Location]
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

  /// Returns a [bool]
  Future<bool> listenLocation(dynamic data) {
    _timer = Timer.periodic(Duration(milliseconds: data['time']), (Timer time) {
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
            AMapLocation.customStreamController.add(Location(
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
            AMapLocation.customStreamController.add(result.message);
          }
        }));
      }));
    });
    return Future.value(true);
  }
}
