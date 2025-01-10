import 'package:f_aviation_accidents/aircraft_status.dart';
import 'package:flutter/material.dart';
import 'package:f_aviation_accidents/accident_tile.dart';
import 'package:intl/intl.dart';
import 'package:f_aviation_accidents/drawer.dart';
import 'package:pie_chart/pie_chart.dart';

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

  final Map<String, String> statsMap = {
    "Destroyed, written off": "Critical",
    "Substantial, repaired": "Critical",
    "Substantial": "Critical",
    "Substantial, written off": "Critical",
    "Destroyed": "Critical",
    "Aircraft missing, written off": "Severe",
    "Aircraft missing": "Severe",
    "Minor, repaired": "Moderate",
    "Minor": "Moderate",
    "Minor, written off": "Moderate",
    "None": "No Issue",
    "None, repaired": "No Issue",
    "Unknown": "No Issue",
    "Unknown, repaired": "No Issue",
    "Unknown, written off": "No Issue",
    "Destroyed, repaired": "No Issue",
    "UnknownUnknown": "Unknown",
    "": "Unknown",
  };
  Map<String, double> statsDataMap = {
    "Critical": 0,
    "Severe": 0,
    "Moderate": 0,
    "No Issue": 0,
    "Unknown": 0,
  };
  final colorList = <Color>[
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.blue,
    Colors.grey,
  ];

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
      return AccidentTile(
        hits: info,
        isStatsScreen: true,
      );
    }).toList();

    for (AccidentTile acc in accidentTiles) {
      final status = enumToEnStringMap[acc.acc.aircraftStatus];
      final key = statsMap[status];

      if (key != null && statsDataMap.containsKey(key)) {
        statsDataMap[key] = (statsDataMap[key] ?? 0) + 1;
      } else {
        print(
            "Unknown or unexpected aircraftStatus: ${acc.acc.aircraftStatus}");
      }
    }

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
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 30.0, 0.0, 0.0),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Builder(
                  builder: (BuildContext context) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 30.0, 20.0, 0.0),
                      child: IconButton(
                        icon: Icon(Icons.menu),
                        iconSize: 30.0,
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30.0, 20.0, 0.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * (0.6),
                        child: Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: Text(
                            airlineStats.airline,
                            style: const TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            PieChart(
                              dataMap: statsDataMap,
                              colorList: colorList,
                              animationDuration: Duration(milliseconds: 1000),
                              chartType: ChartType.ring,
                              ringStrokeWidth: 10,
                              centerText: "항공기\n피해",
                              centerTextStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold,
                              ),
                              chartRadius:
                                  MediaQuery.of(context).size.width / 5,
                              legendOptions: LegendOptions(
                                showLegendsInRow: false,
                                showLegends: false,
                              ),
                              chartValuesOptions: ChartValuesOptions(
                                showChartValueBackground: true,
                                showChartValues: true,
                                showChartValuesInPercentage: false,
                                showChartValuesOutside: true,
                                decimalPlaces: 0,
                              ),
                            ),
                            // SizedBox(width: 30.0),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Column(
                    children: [
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
            ),
          ],
        ),
      ),
      endDrawer: AvccDrawer(),
    );
  }
}
