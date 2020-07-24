import 'package:flutter/services.dart';

const platform = const MethodChannel("todoappchannel_android");

Future<bool> getDrawPermissionState() async {
  bool drawPermission;

  try {
    final result = await platform.invokeMethod("getDrawPermissionState");
    drawPermission = result;
  } catch (e) {
    drawPermission = false;
  }

  return drawPermission;
}

Future<void> reqDrawPermission() async {
  if (!await getDrawPermissionState()) {
    try {
      await platform.invokeMethod("reqDrawPermission");
    } catch (e) {
      print(e.message);
    }
  }
}

Future<bool> getShowWidgetPreference() async {
  bool showWidget;

  try {
    final result = await platform.invokeMethod("getShowWidgetPreference");
    showWidget = result;
  } catch (e) {
    showWidget = false;
  }

  return showWidget;
}

Future<void> setFalseShowWidget() async {
  try {
    await platform.invokeMethod("setFalseShowWidget");
  } catch (e) {
    print(e.message);
  }
}

Future<void> setTrueShowWidget() async {
  try {
    await platform.invokeMethod("setTrueShowWidget");
  } catch (e) {
    print(e.message);
  }
}
