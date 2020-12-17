@JS('Amap')
library amap;

import 'package:js/js.dart';

@JS()
class AMap {
  external Map(String id);
}

@JS()
@anonymous
class MapOptions {
  external factory MapOptions({
    /// 初始中心经纬度
    LngLat center,

    /// 地图显示的缩放级别
    num zoom,

    /// 地图视图模式, 默认为‘2D’
    String /*‘2D’|‘3D’*/ viewMode,
  });
}

@JS()
class LngLat {
  external num getLng();
  external num getLat();
  external LngLat(num lng, num lat);
}
