
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class AppService {
  static final AppService _navigator = AppService._internal();
  static AppService get instance {
    return _navigator;
  }

  AppService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateNamedTo(String routeName) {
    return navigatorKey.currentState.pushNamed(routeName);
  }

  Future<dynamic> navigateNamedReplacementTo(String routeName) {
    return navigatorKey.currentState.pushReplacementNamed(routeName);
  }

  Future<dynamic> navigatePushReplecementTo(Widget widget,
      {bool animated: false}) {
    return navigatorKey.currentState.pushReplacement(
      !animated ? _pageRouteDefault(widget) : _pageRouteAnimated(widget),
    );
  }

  Future<dynamic> navigateTo(Widget widget, {bool animated: false}) {
    return navigatorKey.currentState.push(
      !animated ? _pageRouteDefault(widget) : _pageRouteAnimated(widget),
    );
  }

  Future<dynamic> navigateReplacementTo(Widget widget) {
    return navigatorKey.currentState.pushReplacement(
      CupertinoPageRoute(builder: (_) {
        return widget;
      }),
    );
  }

  void navigatePop([Object object]) {
    return navigatorKey.currentState.pop(object);
  }

  CupertinoPageRoute _pageRouteDefault(Widget widget) {
    return CupertinoPageRoute(
      builder: (_) {
        return widget;
      },
    );
  }

  PageRouteBuilder _pageRouteAnimated(Widget widget) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final begin = Offset(0.0, 1.0);
        final end = Offset.zero;
        final curve = Curves.ease;
        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  BuildContext get context {
    return navigatorKey.currentState.overlay.context;
  }

  Future<String> getAppName() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.appName;
  }

  Future<String> getVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<String> getBuildNumber() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }

  Future<String> getPackageName() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }
}
