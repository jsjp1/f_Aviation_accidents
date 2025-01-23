import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:f_aviation_accidents/components/accident_tile.dart';

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

Future<AccidentTile> fetchAccident() async {
  final _url = "${dotenv.env["SERVER_HOST"]!}/api/accident";
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
      final hits = jsonDecode(decodeBody);

      final AccidentTile acc = AccidentTile(
        hits: hits,
        isStatsScreen: false,
      );

      return acc;
    } else {
      return AccidentTile(
        hits: [],
        isStatsScreen: false,
      );
    }
  } catch (_) {
    return AccidentTile(
      hits: [],
      isStatsScreen: false,
    );
  }
}

Future<List<AccidentTile>> fetchAccidents(
    int currentIndex, bool isStatsScreen) async {
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
        return AccidentTile(
          hits: hit,
          isStatsScreen: isStatsScreen,
        );
      }).toList();

      return accidents;
    } else {
      return [];
    }
  } catch (_) {
    return [];
  }
}

Future<String> fetchDescription(String id) async {
  final _url = "${dotenv.env["SERVER_HOST"]!}/api/description/$id";
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
      final Map<String, dynamic> hits = jsonDecode(decodeBody);

      return hits["description"];
    } else {
      return "";
    }
  } catch (e) {
    return "";
  }
}

Future<String> translateDescription(String id, String description) async {
  const String from_lang = "en";
  const String to_lang = "ko";

  final is_ko_description_empty = await checkKoreanDescription(id);
  if (is_ko_description_empty == false) {
    // opensearch에 이미 ko_description이 존재하는 경우
    final _url = "${dotenv.env["SERVER_HOST"]!}/api/ko_description/$id";
    final url = Uri.parse(_url);

    try {
      final response = await get(url, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final decodeBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> hits = jsonDecode(decodeBody);

        return hits["description"];
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  final url = Uri.parse(dotenv.env["NAVER_API_HOST"]!);
  try {
    final response = await post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-ncp-apigw-api-key-id': dotenv.env["NAVER_API_KEY_ID"]!,
        'x-ncp-apigw-api-key': dotenv.env["NAVER_API_KEY_SECRET"]!,
      },
      body: json.encode(
        {
          "source": from_lang,
          "target": to_lang,
          "text": description,
        },
      ),
    );

    if (response.statusCode == 200) {
      final decodeBody = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> hits = jsonDecode(decodeBody);
      final koDescription = hits["message"]["result"]["translatedText"];

      // 처음 api 요청 후 opensearch에 저장
      await updateKoreanDescription(id, koDescription);

      return koDescription;
    } else {
      return "";
    }
  } catch (_) {
    return "";
  }
}

Future<void> updateKoreanDescription(String id, String description) async {
  String _url = "${dotenv.env["SERVER_HOST"]!}/api/ko_description/";
  final url = Uri.parse(_url);

  try {
    final response = await put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          "doc_id": id,
          "description": description,
        },
      ),
    );

    if (response.statusCode == 200) {
      final hits = jsonDecode(response.body);

      if (hits["status"] != "success") {
        print("Error while update korean description.");
      }

      return;
    } else {
      return;
    }
  } catch (e) {
    return;
  }
}

Future<bool> checkKoreanDescription(String id) async {
  String _url = "${dotenv.env["SERVER_HOST"]!}/api/check_ko_description/$id";
  final url = Uri.parse(_url);

  try {
    final response = await get(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final hits = jsonDecode(response.body);

      return hits["ko_description_empty"];
    } else {
      return false; // 일단 번역 안하는걸로
    }
  } catch (_) {
    return false; // 일단 번역 안하는걸로
  }
}
