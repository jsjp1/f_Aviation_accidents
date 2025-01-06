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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Text(
                airlineStats.airline,
                style: const TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  const Text('총 사고 수: '),
                  Text(airlineStats.totalAccidentsCount.toString()),
                ],
              ),
              Row(
                children: [
                  const Text('총 사망자 수: '),
                  Text(airlineStats.totalFatalities.toString()),
                ],
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: ListView.builder(
                  itemCount: airlineStats.accidentTiles.length,
                  itemBuilder: (context, index) {
                    return airlineStats.accidentTiles[index];
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
