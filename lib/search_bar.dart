import 'dart:async';

import 'package:flutter/material.dart';
import 'package:f_aviation_accidents/api.dart';
import 'package:f_aviation_accidents/airline_stats_screen.dart';

class SearchField extends StatefulWidget {
  @override
  SearchFieldState createState() => SearchFieldState();
}

class SearchFieldState extends State<SearchField> {
  final TextEditingController _controller = TextEditingController();
  final StreamController<List<String>> _streamController = StreamController();
  Timer? _debounce;

  @override
  void dispose() {
    _controller.dispose();
    _streamController.close();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(Duration(milliseconds: 300), () async {
      if (query.isEmpty) {
        _streamController.add([]);
        return;
      }

      final results = await fetchSuggestions(query);
      _streamController.add(results);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            suffixIcon: IconButton(
              icon: Icon(Icons.backspace_rounded),
              onPressed: () {
                _controller.text = "";
                _streamController.add([]);
              },
            ),
            hintText: "항공사명을 입력해보세요.",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          onChanged: _onSearchChanged,
          onSubmitted: (value) async {
            if (value.isNotEmpty) {
              List<dynamic> response = await fetchInformation(value);

              if (response.isEmpty) {
                try {
                  final suggestionAirline = await fetchSuggestions(value);
                  response = await fetchInformation(suggestionAirline[0]);
                } catch (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("항공사가 존재하지 않습니다.")),
                  );
                  return;
                }
              }

              List<Map<String, dynamic>> listMapResponse = response.map((item) {
                return item as Map<String, dynamic>;
              }).toList();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      StatsScreen(information: listMapResponse),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("입력값이 필요합니다!")),
              );
            }
          },
        ),
        StreamBuilder<List<String>>(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return SizedBox.shrink();
            }
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0), // 둥근 모서리
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return TextButton(
                    onPressed: () {
                      _controller.text = snapshot.data![index];
                      _streamController.add([]);
                      FocusScope.of(context).unfocus();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.airplane_ticket_outlined),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(snapshot.data![index]),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
