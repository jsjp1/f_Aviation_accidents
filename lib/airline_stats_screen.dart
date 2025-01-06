import 'package:flutter/material.dart';
import 'package:f_aviation_accidents/accident_tile.dart';

class Stats {
  String airline = "";
  int totalAccidentsCount = 0;
  int totalFatalities = 0;
  late List<AccidentTile> accidentTiles;

  Stats({
    required this.airline,
    required this.totalAccidentsCount,
    required this.totalFatalities,
    required this.accidentTiles,
  });
}

class StatsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> information;
  late Stats airlineStats;

  StatsScreen({
    super.key,
    required this.information,
  }) {
    int totalAccidentsCount = information.length;
    int totalFatalities = 0;
    for (var info in information) {
      totalFatalities += info["fatalities"] as int;
    }

    String airline =
        information.isNotEmpty ? information.first["airline"] : "Not Found";

    final List<AccidentTile> accidentTiles = information.map((info) {
      return AccidentTile(hits: info);
    }).toList();

    airlineStats = Stats(
      accidentTiles: accidentTiles,
      airline: airline,
      totalAccidentsCount: totalAccidentsCount,
      totalFatalities: totalFatalities,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Positioned(
                top: 50.0,
                child: Text(
                  airlineStats.airline,
                  style: TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    '총 사고 수: ',
                  ),
                  Text(
                    airlineStats.totalAccidentsCount.toString(),
                  )
                ],
              ),
              Row(children: [
                Text(
                  '총 사망자 수: ',
                ),
                Text(
                  airlineStats.totalFatalities.toString(),
                )
              ])
            ],
          ),
        ),
      ),
    );
  }
}
