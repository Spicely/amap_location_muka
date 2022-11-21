library amap_location_muka;

import 'dart:async';
import 'package:amap_core/amap_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

export 'package:amap_core/amap_core.dart';

/// 仅Android可用
enum AMapLocationMode {
  /// 高精度模式
  HIGHT_ACCURACY,

  /// 低功耗模式
  BATTERY_SAVING,

  /// 仅设备模式,不支持室内环境的定位
  DEVICE_SENSORS,
}

enum AMapGeoFenceActivateAction {
  /// 进入地理围栏
  GEOFENCE_IN,

  /// 退出地理围栏\
  GEOFENCE_OUT,

  ///停留在地理围栏内10分钟
  GEOFENCE_STAYED,
}

/// 仅IOS可用
enum AMapLocationAccuracy {
  /// 最快 精确度最底 约秒到
  THREE_KILOMETERS,

  /// 精确度较低 约秒到
  KILOMETER,

  /// 精确度较低 约2s
  HUNDREE_METERS,

  /// 精确度较高 约5s
  NEAREST_TENMETERS,

  /// 最慢 精确度最高 约8s
  BEST,
}

enum ConvertType {
  /// GPS
  GPS,

  /// 百度
  BAIDU,

  /// Google
  GOOGLE,
}

typedef void AMapLocationListen(Location location);

class AMapLocation {
  static const _channel = MethodChannel('plugins.muka.com/amap_location');

  static const _event = EventChannel('plugins.muka.com/amap_location_event');

  static StreamController<dynamic> customStreamController = StreamController<dynamic>();

  static StreamSubscription<dynamic>? _stream;

  static Stream<dynamic> get _eventStream {
    if (kIsWeb) {
      return customStreamController.stream;
    } else {
      return _event.receiveBroadcastStream();
    }
  }

  /// 设置Android和iOS的apikey，建议在weigdet初始化时设置<br>
  /// apiKey的申请请参考高德开放平台官网<br>
  /// Android端: https://lbs.amap.com/api/android-location-sdk/guide/create-project/get-key<br>
  /// iOS端: https://lbs.amap.com/api/ios-location-sdk/guide/create-project/get-key<br>
  /// [androidKey] Android平台的key<br>
  /// [iosKey] ios平台的key<br>
  static Future<bool> setApiKey(String androidKey, String iosKey) async {
    bool? status = await _channel.invokeMethod<bool>('setApiKey', {'android': androidKey, 'ios': iosKey});
    return status ?? false;
  }

  /// 单次定位
  ///
  /// androidMode 定位方式 [ 仅适用android ]
  ///
  /// iosAccuracy 精确度 [ 仅适用ios ]
  static Future<Location> fetch({
    AMapLocationMode androidMode = AMapLocationMode.HIGHT_ACCURACY,
    AMapLocationAccuracy iosAccuracy = AMapLocationAccuracy.THREE_KILOMETERS,
  }) async {
    dynamic location = await _channel.invokeMethod('fetch', {
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
  static Future<Future<Null> Function()> start({
    AMapLocationListen? listen,
    AMapLocationMode mode = AMapLocationMode.HIGHT_ACCURACY,
    int? time,
    AMapLocationAccuracy accuracy = AMapLocationAccuracy.THREE_KILOMETERS,
  }) async {
    await _channel.invokeMethod('start', {
      'mode': mode.index,
      'time': time ?? 2000,
      'accuracy': accuracy.index,
    });
    if (_stream == null) {
      _stream = _eventStream.listen((dynamic data) {
        listen!(Location.fromJson(data));
      });
    }
    return () async {
      await _channel.invokeMethod('stop');
    };
  }

  /// 启动后台服务
  static Future<void> enableBackground({
    required String title,
    required String label,
    required String assetName,
    bool? vibrate,
  }) async {
    await _channel.invokeMethod('enableBackground', {'title': title, 'label': label, 'assetName': assetName, 'vibrate': vibrate ?? true});
  }

  /// 关闭后台服务
  static Future<void> disableBackground() async {
    await _channel.invokeMethod('disableBackground');
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
  static Future<void> addGeoFenceKeyword(String keyword, String poiType, String city, String customId) async {
    await _channel.invokeMethod('addGeoFenceKeyword', {
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
  static Future<void> addGeoFencePoint(String keyword, String poiType, LatLng point, double aroundRadius, String customId) async {
    await _channel.invokeMethod('addGeoFencePoint', {
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
  static Future<void> addGeoFenceArea(String keyword, String customId) async {
    await _channel.invokeMethod('addGeoFenceArea', {
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
  static Future<void> addGeoFenceDiy(LatLng point, String radius, String customId) async {
    await _channel.invokeMethod('addGeoFenceDiy', {
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
  static Future<void> addGeoFencePolygon(List<LatLng> points, String customId) async {
    assert(points.length < 3, '多边形的边界坐标点最少传3个');
    await _channel.invokeMethod('addGeoFencePolygon', {
      'points': points,
      'customId': customId,
    });
  }

  /// 确保调用SDK任何接口前先调用更新隐私合规updatePrivacyShow、updatePrivacyAgree两个接口并且参数值都为true，若未正确设置有崩溃风险
  static Future<void> updatePrivacyShow(bool hasContains, bool hasShow) async {
    await _channel.invokeMethod('updatePrivacyShow', {
      'hasContains': hasContains,
      'hasShow': hasShow,
    });
  }

  /// 确保调用SDK任何接口前先调用更新隐私合规updatePrivacyShow、updatePrivacyAgree两个接口并且参数值都为true，若未正确设置有崩溃风险
  static Future<void> updatePrivacyAgree(bool hasAgree) async {
    await _channel.invokeMethod('updatePrivacyAgree', {
      'hasAgree': hasAgree,
    });
  }
}
