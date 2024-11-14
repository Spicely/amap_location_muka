// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'dart:async';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'amap_location_muka_platform_interface.dart';

/// A web implementation of the AmapLocationMukaPlatform of the AmapLocationMuka plugin.
class AmapLocationMukaWeb extends AmapLocationMukaPlatform {
  /// Constructs a AmapLocationMukaWeb
  AmapLocationMukaWeb();

  static void registerWith(Registrar registrar) {
    AmapLocationMukaPlatform.instance = AmapLocationMukaWeb();
  }

  StreamController<dynamic> customStreamController = StreamController<dynamic>();

  StreamSubscription<dynamic>? _stream;

  Stream<dynamic> get _eventStream => customStreamController.stream;
}
