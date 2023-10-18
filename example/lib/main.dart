import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:amap_location_muka/amap_location_muka.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Location? _location;
  Function? stopLocation;

  @override
  void initState() {
    super.initState();

    initPlatformState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: // 应用程序可见，前台
        print('22111112122');
        await AMapLocation.disableBackground();
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        print('22222222');
        await AMapLocation.enableBackground(assetName: 'app_icon', label: '正在获取位置信息', title: '高德地图', vibrate: false);
        break;
      default:
        break;
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (!kIsWeb) {
      await Permission.location.request();
    }
    await AMapLocation.updatePrivacyShow(true, true);
    await AMapLocation.updatePrivacyAgree(true);

    await AMapLocation.setApiKey('d725d072f587a82f8a78a6aeb5d005b7', '239aa734a203e8ee6d7740edf762afe0');

    // print(statuses[Permission.location]);
    // print('单次定位');
    _location = await AMapLocation.fetch();
    print(_location?.toJson());
    // print('单次定位');
    // setState(() {});
    stopLocation = await AMapLocation.start(
      time: 1000,
      listen: (Location location) {
        print(location.toJson());
        print('持续定位222');
      },
    );

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            Center(
              child: Text('Running on: ${_location?.address}'),
            ),
            ElevatedButton(
              child: Text('停止定位'),
              onPressed: () async {
                if (stopLocation != null) {
                  await stopLocation?.call();
                  print('停止定位');
                }
              },
            ),
            ElevatedButton(
              child: Text('单次定位'),
              onPressed: () async {
                _location = await AMapLocation.fetch();
                print(_location?.toJson());
                print('单次定位');
                setState(() {});
              },
            ),
            ElevatedButton(
              child: Text('持续定位'),
              onPressed: () async {
                print('持续定位');
                stopLocation = await AMapLocation.start(
                  time: 1000,
                  listen: (Location location) {
                    print(location.toJson());
                    print('持续定位222');
                  },
                );
              },
            ),
            // RaisedButton(
            //   child: Text('地址转换'),
            //   onPressed: () async {
            //     // LatLng pos = await AmapLocation.convert(latLng: LatLng(40.012044, 116.332404), type: ConvertType.BAIDU);
            //     // print(pos);
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
