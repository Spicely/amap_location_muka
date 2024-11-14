import 'dart:async';

import 'package:amap_core/amap_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'amap_location_muka_platform_interface.dart';
import 'src/enum.dart';

/// An implementation of [AmapLocationMukaPlatform] that uses method channels.
class MethodChannelAmapLocationMuka extends AmapLocationMukaPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('plugins.muka.com/amap_location');

  final eventChannel = const EventChannel('plugins.muka.com/amap_location_event');

  StreamSubscription<dynamic>? _stream;

  Stream<dynamic> get _eventStream => eventChannel.receiveBroadcastStream();

  /// 设置Android和iOS的apiKey，建议在widget初始化时设置<br>
  /// apiKey的申请请参考高德开放平台官网<br>
  /// Android端: https://lbs.amap.com/api/android-location-sdk/guide/create-project/get-key<br>
  /// iOS端: https://lbs.amap.com/api/ios-location-sdk/guide/create-project/get-key<br>
  /// [androidKey] Android平台的key<br>
  /// [iosKey] ios平台的key<br>
  @override
  Future<void> setApiKey(String androidKey, String iosKey) async {
    await methodChannel.invokeMethod<bool>('setApiKey', {'android': androidKey, 'ios': iosKey});
  }

  /// 单次定位
  ///
  /// androidMode 定位方式 [ 仅适用android ]
  ///
  /// iosAccuracy 精确度 [ 仅适用ios ]
  @override
  Future<Location> fetch({
    AMapLocationMode androidMode = AMapLocationMode.HIGHT_ACCURACY,
    AMapLocationAccuracy iosAccuracy = AMapLocationAccuracy.THREE_KILOMETERS,
  }) async {
    dynamic location = await methodChannel.invokeMethod('fetch', {
      'mode': androidMode.index,
      'accuracy': iosAccuracy.index,
    });
    return Location.fromJson(location);
  }

  /// 持续定位
  ///
  /// [time] 间隔时间 默认 2000
  ///
  /// [mode] 定位方式 [ 仅适用android ]
  ///
  /// [accuracy] 精确度 [ 仅适用ios ]
  @override
  Future<Future<Null> Function()> start({
    AMapLocationListen? listen,
    AMapLocationMode mode = AMapLocationMode.HIGHT_ACCURACY,
    int? time,
    AMapLocationAccuracy accuracy = AMapLocationAccuracy.THREE_KILOMETERS,
  }) async {
    await methodChannel.invokeMethod('start', {
      'mode': mode.index,
      'time': time ?? 2000,
      'accuracy': accuracy.index,
    });
    _stream ??= _eventStream.listen((dynamic data) {
      listen!(Location.fromJson(data));
    });
    return () async {
      await methodChannel.invokeMethod('stop');
    };
  }

  /// 启动后台服务
  @override
  Future<void> enableBackground({
    required String title,
    required String label,
    required String assetName,
    bool? vibrate,
  }) async {
    await methodChannel.invokeMethod('enableBackground', {'title': title, 'label': label, 'assetName': assetName, 'vibrate': vibrate ?? true});
  }

  /// 关闭后台服务
  @override
  Future<void> disableBackground() async {
    await methodChannel.invokeMethod('disableBackground');
  }

  /// 根据关键字创建围栏
  ///
  /// [keyword] POI关键字
  ///
  /// [poiType] POI类型
  ///
  /// [city] POI所在的城市名称
  ///
  /// [customId] 与围栏关联的自有业务Id
  ///
  @override
  Future<void> addGeoFenceKeyword(String keyword, String poiType, String city, String customId) async {
    await methodChannel.invokeMethod('addGeoFenceKeyword', {
      'keyword': keyword,
      'poiType': poiType,
      'city': city,
      'customId': customId,
    });
  }

  /// 根据周边POI创建围栏
  ///
  /// [keyword] POI关键字
  ///
  /// [poiType] POI类型
  ///
  /// [point] 周边区域中心点的经纬度，以此中心点建立周边地理围栏
  ///
  /// [aroundRadius] 周边半径，0-50000米，默认3000米
  ///
  /// [customId] 与围栏关联的自有业务Id
  ///
  @override
  Future<void> addGeoFencePoint(String keyword, String poiType, LatLng point, double aroundRadius, String customId) async {
    await methodChannel.invokeMethod('addGeoFencePoint', {
      'keyword': keyword,
      'poiType': poiType,
      'point': point.toJson(),
      'aroundRadius': aroundRadius,
      'customId': customId,
    });
  }

  /// 创建行政区划围栏
  ///
  /// [keyword] 行政区划关键字
  ///
  /// [customId] 与围栏关联的自有业务Id
  ///
  @override
  Future<void> addGeoFenceArea(String keyword, String customId) async {
    await methodChannel.invokeMethod('addGeoFenceArea', {
      'keyword': keyword,
      'customId': customId,
    });
  }

  /// 创建自定义围栏
  ///
  /// [point] 围栏中心点
  ///
  /// [radius] 要创建的围栏半径 ，半径无限制，单位米
  ///
  /// [customId] 与围栏关联的自有业务Id
  ///
  @override
  Future<void> addGeoFenceDiy(LatLng point, String radius, String customId) async {
    await methodChannel.invokeMethod('addGeoFenceDiy', {
      'point': point,
      'radius': radius,
      'customId': customId,
    });
  }

  /// 创建自定义围栏
  ///
  /// [points] 多边形的边界坐标点，最少传3个
  ///
  /// [customId] 与围栏关联的自有业务Id
  ///
  @override
  Future<void> addGeoFencePolygon(List<LatLng> points, String customId) async {
    assert(points.length < 3, '多边形的边界坐标点最少传3个');
    await methodChannel.invokeMethod('addGeoFencePolygon', {
      'points': points,
      'customId': customId,
    });
  }

  /// 确保调用SDK任何接口前先调用更新隐私合规updatePrivacyShow、updatePrivacyAgree两个接口并且参数值都为true，若未正确设置有崩溃风险
  @override
  Future<void> updatePrivacyShow(bool hasContains, bool hasShow) async {
    await methodChannel.invokeMethod('updatePrivacyShow', {
      'hasContains': hasContains,
      'hasShow': hasShow,
    });
  }

  /// 确保调用SDK任何接口前先调用更新隐私合规updatePrivacyShow、updatePrivacyAgree两个接口并且参数值都为true，若未正确设置有崩溃风险
  @override
  Future<void> updatePrivacyAgree(bool hasAgree) async {
    await methodChannel.invokeMethod('updatePrivacyAgree', {
      'hasAgree': hasAgree,
    });
  }
}
