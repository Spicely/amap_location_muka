import 'package:amap_core/amap_core.dart';

import 'amap_location_muka_platform_interface.dart';
import 'src/enum.dart';

export 'package:amap_core/amap_core.dart';

export 'src/enum.dart';

class AMapLocation {
  /// 设置Android和iOS的apiKey，建议在widget初始化时设置<br>
  /// apiKey的申请请参考高德开放平台官网<br>
  /// Android端: https://lbs.amap.com/api/android-location-sdk/guide/create-project/get-key<br>
  /// iOS端: https://lbs.amap.com/api/ios-location-sdk/guide/create-project/get-key<br>
  /// [androidKey] Android平台的key<br>
  /// [iosKey] ios平台的key<br>
  static Future<void> setApiKey(String androidKey, String iosKey) async {
    await AmapLocationMukaPlatform.instance.setApiKey(androidKey, iosKey);
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
    return await AmapLocationMukaPlatform.instance.fetch(androidMode: androidMode, iosAccuracy: iosAccuracy);
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
    return await AmapLocationMukaPlatform.instance.start(listen: listen, mode: mode, time: time, accuracy: accuracy);
  }

  /// 启动后台服务
  static Future<void> enableBackground({
    required String title,
    required String label,
    required String assetName,
    bool? vibrate,
  }) async {
    await AmapLocationMukaPlatform.instance.enableBackground(title: title, label: label, assetName: assetName, vibrate: vibrate);
  }

  /// 关闭后台服务
  static Future<void> disableBackground() async {
    await AmapLocationMukaPlatform.instance.disableBackground();
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
    await AmapLocationMukaPlatform.instance.addGeoFenceKeyword(keyword, poiType, city, customId);
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
    await AmapLocationMukaPlatform.instance.addGeoFencePoint(keyword, poiType, point, aroundRadius, customId);
  }

  /// 创建行政区划围栏
  ///
  /// [keyword] 行政区划关键字
  ///
  /// [customId] 与围栏关联的自有业务Id
  ///
  static Future<void> addGeoFenceArea(String keyword, String customId) async {
    await AmapLocationMukaPlatform.instance.addGeoFenceArea(keyword, customId);
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
    await AmapLocationMukaPlatform.instance.addGeoFenceDiy(point, radius, customId);
  }

  /// 创建自定义围栏
  ///
  /// [points] 多边形的边界坐标点，最少传3个
  ///
  /// [customId] 与围栏关联的自有业务Id
  ///
  static Future<void> addGeoFencePolygon(List<LatLng> points, String customId) async {
    await AmapLocationMukaPlatform.instance.addGeoFencePolygon(points, customId);
  }

  /// 确保调用SDK任何接口前先调用更新隐私合规updatePrivacyShow、updatePrivacyAgree两个接口并且参数值都为true，若未正确设置有崩溃风险
  static Future<void> updatePrivacyShow(bool hasContains, bool hasShow) async {
    await AmapLocationMukaPlatform.instance.updatePrivacyShow(hasContains, hasShow);
  }

  /// 确保调用SDK任何接口前先调用更新隐私合规updatePrivacyShow、updatePrivacyAgree两个接口并且参数值都为true，若未正确设置有崩溃风险
  static Future<void> updatePrivacyAgree(bool hasAgree) async {
    await AmapLocationMukaPlatform.instance.updatePrivacyAgree(hasAgree);
  }
}
