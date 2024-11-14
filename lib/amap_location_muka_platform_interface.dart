import 'package:amap_core/amap_core.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'amap_location_muka_method_channel.dart';
import 'src/enum.dart';

abstract class AmapLocationMukaPlatform extends PlatformInterface {
  /// Constructs a AmapLocationMukaPlatform.
  AmapLocationMukaPlatform() : super(token: _token);

  static final Object _token = Object();

  static AmapLocationMukaPlatform _instance = MethodChannelAmapLocationMuka();

  /// The default instance of [AmapLocationMukaPlatform] to use.
  ///
  /// Defaults to [MethodChannelAmapLocationMuka].
  static AmapLocationMukaPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AmapLocationMukaPlatform] when
  /// they register themselves.
  static set instance(AmapLocationMukaPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> setApiKey(String androidKey, String iosKey) {
    throw UnimplementedError('setApiKey() has not been implemented.');
  }

  Future<Location> fetch({
    AMapLocationMode androidMode = AMapLocationMode.HIGHT_ACCURACY,
    AMapLocationAccuracy iosAccuracy = AMapLocationAccuracy.THREE_KILOMETERS,
  }) {
    throw UnimplementedError('fetch() has not been implemented.');
  }

  Future<Future<Null> Function()> start({
    AMapLocationListen? listen,
    AMapLocationMode mode = AMapLocationMode.HIGHT_ACCURACY,
    int? time,
    AMapLocationAccuracy accuracy = AMapLocationAccuracy.THREE_KILOMETERS,
  }) {
    throw UnimplementedError('start() has not been implemented.');
  }

  Future<void> enableBackground({
    required String title,
    required String label,
    required String assetName,
    bool? vibrate,
  }) {
    throw UnimplementedError('enableBackground() has not been implemented.');
  }

  Future<void> disableBackground() {
    throw UnimplementedError('disableBackground() has not been implemented.');
  }

  Future<void> addGeoFenceKeyword(String keyword, String poiType, String city, String customId) {
    throw UnimplementedError('addGeoFenceKeyword() has not been implemented.');
  }

  Future<void> addGeoFencePoint(String keyword, String poiType, LatLng point, double aroundRadius, String customId) {
    throw UnimplementedError('addGeoFencePoint() has not been implemented.');
  }

  Future<void> addGeoFenceArea(String keyword, String customId) {
    throw UnimplementedError('addGeoFenceArea() has not been implemented.');
  }

  Future<void> addGeoFenceDiy(LatLng point, String radius, String customId) {
    throw UnimplementedError('addGeoFenceDiy() has not been implemented.');
  }

  Future<void> addGeoFencePolygon(List<LatLng> points, String customId) {
    throw UnimplementedError('addGeoFencePolygon() has not been implemented.');
  }

  Future<void> updatePrivacyShow(bool hasContains, bool hasShow) {
    throw UnimplementedError('updatePrivacyShow() has not been implemented.');
  }

  Future<void> updatePrivacyAgree(bool hasAgree) {
    throw UnimplementedError('updatePrivacyAgree() has not been implemented.');
  }
}
