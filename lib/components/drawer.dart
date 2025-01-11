import 'package:f_aviation_accidents/appversion_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

class AvccDrawer extends StatelessWidget {
  const AvccDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      surfaceTintColor: Colors.lightBlueAccent,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage("assets/icons/avcc_app_icon_round.png"),
                    width: 50.0,
                  ),
                  Text("AVCC"),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.message,
            ),
            title: Text(
              '의견 및 피드백 제공',
              style: TextStyle(),
            ),
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
            onTap: () {
              // TODO
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.copyright),
            title: Text(
              '저작권',
              style: TextStyle(),
            ),
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
            onTap: () {
              _launchUrl("${dotenv.env["AVIATION_SAFETY_HOST"]}");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.check,
            ),
            title: Text("버전"),
            trailing: Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: AppVersionWidget(),
            ),
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
