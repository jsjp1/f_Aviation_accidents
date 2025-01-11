import 'dart:async';

import 'package:flutter/material.dart';
import 'package:f_aviation_accidents/utils/api.dart';
import 'package:f_aviation_accidents/screen/airline_stats_screen.dart';

class SearchField extends StatefulWidget {
  final StreamController<List<String>> streamController;

  const SearchField({
    super.key,
    required this.streamController,
  });

  @override
  SearchFieldState createState() => SearchFieldState();
}

class SearchFieldState extends State<SearchField> {
  final TextEditingController _textController = TextEditingController();
  Timer? _debounce;
  late List<String> suggestionResults = [];

  @override
  void dispose() {
    _textController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(Duration(milliseconds: 300), () async {
      if (query.isEmpty) {
        widget.streamController.add([]);
        return;
      }

      suggestionResults = await fetchSuggestions(query);
      widget.streamController.add(suggestionResults);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _textController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            suffixIcon: IconButton(
              icon: Icon(Icons.backspace_rounded),
              onPressed: () {
                _textController.text = "";
                widget.streamController.add([]);
                suggestionResults = [];
                FocusScope.of(context).unfocus();
              },
            ),
            hintText: "항공사명을 입력해보세요.",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          onChanged: _onSearchChanged,
          onTap: () {
            widget.streamController.add(suggestionResults);
          },
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
          stream: widget.streamController.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return SizedBox.shrink();
            }
            return Container(
              height: snapshot.data!.length * 50.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
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
                      _textController.text = snapshot.data![index];
                      suggestionResults = [snapshot.data![index]];
                      widget.streamController.add([]);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.airplane_ticket_outlined),
                        SizedBox(
                          width: 10.0,
                        ),
                        SizedBox(
                          // TODO: 더 고쳐야할 것 같음
                          width: MediaQuery.of(context).size.width * (0.78),
                          child: Text(
                            snapshot.data![index],
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                        ),
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
