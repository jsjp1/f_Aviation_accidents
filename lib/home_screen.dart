import 'dart:async';

import 'package:flutter/material.dart';
import 'package:f_aviation_accidents/search_bar.dart';
import 'package:f_aviation_accidents/accident_tile.dart';
import 'package:f_aviation_accidents/api.dart';
import 'package:f_aviation_accidents/drawer.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late List<AccidentTile> data = [];
  Image todayAppbarIcon = Image(
    image: AssetImage(
      "assets/icons/avcc_app_icon_monochrome.png",
    ),
    width: 20.0,
  );
  final StreamController<List<String>> _streamController = StreamController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _loadMoreData();
    _changeIconTodayAccident();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !_isLoading) {
        _loadMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _streamController.close();
    super.dispose();
  }

  Future<void> _loadMoreData() async {
    List<AccidentTile> newData = [];

    setState(() {
      _isLoading = true;
    });

    newData = await fetchAccidents(currentIndex, false);

    setState(() {
      data.addAll(newData);
      currentIndex += 10;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 70.0,
                  height: 90.0,
                ),
                SizedBox(
                  width: 90.0,
                  height: 90.0,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: todayAppbarIcon,
                  ),
                ),
                Builder(
                  builder: (BuildContext context) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 20.0, 20.0, 0.0),
                      child: IconButton(
                        icon: Icon(Icons.menu),
                        iconSize: 30.0,
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 90.0, 15.0, 0.0),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: data.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < data.length) {
                          return data[index];
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(0),
                      ),
                      child: SearchField(streamController: _streamController),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      endDrawer: AvccDrawer(),
    );
  }

  Future<void> _changeIconTodayAccident() async {
    final DateFormat ymdFormat = DateFormat('yyyy-MM-dd');
    final String today = ymdFormat.format(DateTime.now());
    final AccidentTile lastAccident = await fetchAccident(today);

    final String lastAccidentDate = ymdFormat.format(lastAccident.acc.date);

    if (today == lastAccidentDate) {
      todayAppbarIcon = Image(
        image: AssetImage("assets/icons/avcc_app_icon_monochrome.png"),
        color: Colors.red,
        width: 20.0,
      );
    }
  }
}
