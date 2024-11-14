// ignore_for_file: constant_identifier_names

import 'package:amap_core/amap_core.dart';

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

  /// 退出地理围栏
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
