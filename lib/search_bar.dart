import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  Future<List<String>> _fetchSuggestions(String query) async {
    String _url = "${dotenv.env["SERVER_HOST"]!}/api/suggestions/$query";
    final url = Uri.parse(_url);
    try {
      final response = await get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // TODO: 오류 처리
      if (response.statusCode == 200) {
        final List<dynamic> hits = jsonDecode(response.body);

        return hits.map((item) => item.toString()).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(Duration(milliseconds: 300), () async {
      if (query.isEmpty) {
        _streamController.add([]);
        return;
      }

      final results = await _fetchSuggestions(query);
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
            hintText: "항공사명을 입력해보세요.",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          onChanged: _onSearchChanged,
        ),
        StreamBuilder<List<String>>(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return SizedBox.shrink();
            }
            return Container(
              color: Colors.grey[200],
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index]),
                    onTap: () {
                      _controller.text = snapshot.data![index];
                      _streamController.add([]);
                    },
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
