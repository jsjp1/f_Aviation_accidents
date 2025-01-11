import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersionWidget extends StatefulWidget {
  const AppVersionWidget({super.key});

  @override
  AppVersionWidgetState createState() => AppVersionWidgetState();
}

class AppVersionWidgetState extends State<AppVersionWidget> {
  String appVersion = "";

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        appVersion = packageInfo.version;
      });
    } catch (e) {
      setState(() {
        appVersion = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      appVersion,
      style: TextStyle(
        fontWeight: FontWeight.w100,
        fontSize: 15.0,
      ),
    );
  }
}
