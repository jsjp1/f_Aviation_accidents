import 'package:flutter/material.dart';

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
                    image: AssetImage("assets/icons/avcc_app_icon512.png"),
                    width: 50.0,
                  ),
                  Text("AVCC"),
                ],
              ),
            ),
          ),
          ListTile(
            title: Text('Temp1'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Temp2'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
