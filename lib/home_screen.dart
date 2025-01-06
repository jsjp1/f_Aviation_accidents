import 'package:flutter/material.dart';
import 'package:f_aviation_accidents/search_bar.dart';
import 'package:f_aviation_accidents/accident_tile.dart';
import 'package:f_aviation_accidents/api.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<AccidentTile> data = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadMoreData();

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
    super.dispose();
  }

  Future<void> _loadMoreData() async {
    List<AccidentTile> newData = [];

    setState(() {
      _isLoading = true;
    });

    newData = await fetchAccidents(currentIndex);

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
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 20.0, 20.0, 0.0),
            child: IconButton(
              icon: Icon(Icons.menu),
              iconSize: 30.0,
              onPressed: () {},
            ),
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
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(0),
                    ),
                    child: SearchField(),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
