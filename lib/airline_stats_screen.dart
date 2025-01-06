import 'package:flutter/material.dart';
import 'package:f_aviation_accidents/accident_tile.dart';
import 'package:intl/intl.dart';

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
      if (info["fatalities"] is int) {
        totalFatalities += info["fatalities"] as int;
      } else if (info["fatalities"] is String) {
        totalFatalities += int.parse(info["fatalities"]);
      }
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 0.0),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 20.0, 20.0, 0.0),
                  child: IconButton(
                    icon: Icon(Icons.menu),
                    iconSize: 30.0,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30.0, 20.0, 0.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    airlineStats.airline,
                    style: const TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      const Text('총 사고 수: '),
                      Text(
                        airlineStats.totalAccidentsCount.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('총 사망자 수: '),
                      Text(
                        airlineStats.totalFatalities.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('마지막 사고 발생 시각: '),
                      Text(
                        airlineStats.accidentTiles.isNotEmpty
                            ? DateFormat('yyyy-MM-dd HH:mm').format(
                                airlineStats.accidentTiles.first.dateTime)
                            : "",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                child: ListView.builder(
                  itemCount: airlineStats.accidentTiles.length,
                  itemBuilder: (context, index) {
                    return airlineStats.accidentTiles[index];
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
