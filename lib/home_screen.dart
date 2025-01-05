import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:f_aviation_accidents/search_bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:f_aviation_accidents/accident_tile.dart';

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

    final _url =
        "${dotenv.env["SERVER_HOST"]!}/api/accidents?start=$currentIndex&size=${currentIndex + 10}";
    final url = Uri.parse(_url);

    try {
      final response = await get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decodeBody = utf8.decode(response.bodyBytes);
        final List<dynamic> hits = jsonDecode(decodeBody);

        newData = hits.map<AccidentTile>((hit) {
          return AccidentTile(hits: hit);
        }).toList();

        currentIndex += hits.length;
      }
    } catch (e) {
      print('Error fetching suggestions: $e');
    }

    setState(() {
      data.addAll(newData);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 100.0),
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
              top: 10.0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(15.0),
                color: Colors.white,
                child: SearchField(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
