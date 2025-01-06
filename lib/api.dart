import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:f_aviation_accidents/accident_tile.dart';

Future<List<String>> fetchSuggestions(String query) async {
  String _url = "${dotenv.env["SERVER_HOST"]!}/api/suggestions/$query";
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

      return hits.map((item) => item.toString()).toList();
    } else {
      return [];
    }
  } catch (_) {
    return [];
  }
}

Future<List<dynamic>> fetchInformation(String airline) async {
  final _url = "${dotenv.env["SERVER_HOST"]!}/api/information/$airline";
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

      return hits;
    } else {
      return [];
    }
  } catch (_) {
    return [];
  }
}

Future<List<AccidentTile>> fetchAccidents(int currentIndex) async {
  final _url =
      "${dotenv.env["SERVER_HOST"]!}/api/accidents?start=$currentIndex&size=10";
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

      currentIndex += hits.length;

      final accidents = hits.map<AccidentTile>((hit) {
        return AccidentTile(hits: hit);
      }).toList();

      return accidents;
    } else {
      return [];
    }
  } catch (_) {
    return [];
  }
}
