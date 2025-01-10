import 'package:f_aviation_accidents/airline_stats_screen.dart';
import 'package:f_aviation_accidents/api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:f_aviation_accidents/aircraft_status.dart';
import 'package:f_aviation_accidents/description_screen.dart';

class Accident {
  late DateTime date;
  String id = "";
  int fatalities = 0;
  int occupants = 0;
  String location = "";
  String airline = "";
  late AircraftStatus aircraftStatus = AircraftStatus.empty;

  Accident({
    required this.date,
    required this.id,
    required this.fatalities,
    required this.occupants,
    required this.location,
    required this.airline,
    required this.aircraftStatus,
  });
}

class AccidentTile extends StatelessWidget {
  final dynamic hits;
  late DateTime dateTime;
  late Accident acc;
  late bool isStatsScreen;

  AccidentTile({
    super.key,
    required this.hits,
    required this.isStatsScreen,
  }) {
    String rawTime = (hits["time"] != null && hits["time"].trim().isNotEmpty)
        ? hits["time"]
        : "00:00";
    String rawDateTime = "${hits["date"]} $rawTime";

    String cleanedDateTime = rawDateTime
        .replaceAll(RegExp(r'[^0-9:\-\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    DateFormat format = DateFormat("yyyy-MM-dd HH:mm");

    try {
      dateTime = format.parse(cleanedDateTime);
    } catch (e) {
      print("Invalid date format: $cleanedDateTime. Error: $e");
      dateTime = DateTime(1900);
    }

    int fatalities = 0;
    int occupants = 0;

    if (hits["fatalities"] is String) {
      fatalities = int.tryParse(hits["fatalities"]) ?? 0;
    } else if (hits["fatalities"] is int) {
      fatalities = hits["fatalities"];
    }

    if (hits["occupants"] is String) {
      occupants = int.tryParse(hits["occupants"]) ?? 0;
    } else if (hits["occupants"] is int) {
      occupants = hits["occupants"];
    }

    if (occupants <= fatalities) fatalities = occupants;

    AircraftStatus? status = stringToAircraftStatusMap[hits["aircraft_status"]];

    acc = Accident(
      id: hits["_id"] ?? "Unknown document id",
      date: dateTime,
      fatalities: fatalities,
      occupants: occupants,
      location: hits["location"] ?? "Unknown location",
      airline: hits["airline"] ?? "Unknown location",
      aircraftStatus: status ?? AircraftStatus.empty,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DescriptionScreen(acc: acc),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(200),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Tooltip(
                    message: enumToStringMap[acc.aircraftStatus],
                    child: GestureDetector(
                      onTap: () {
                        print("Aircraft status: ${acc.aircraftStatus}");
                      },
                      child: getAircraftStatusIcon(acc.aircraftStatus),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () async {
                          if (isStatsScreen == false) {
                            List<dynamic> response =
                                await fetchInformation(acc.airline);

                            List<Map<String, dynamic>> listMapResponse =
                                response.map((item) {
                              return item as Map<String, dynamic>;
                            }).toList();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    StatsScreen(information: listMapResponse),
                              ),
                            );
                          }
                        },
                        child: Text(
                          acc.airline,
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color:
                                isStatsScreen ? Colors.blueGrey : Colors.blue,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '날짜:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(DateFormat('yyyy-MM-dd HH:mm').format(acc.date)),
                ],
              ),
              SizedBox(height: 4.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '위치:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(
                      acc.location,
                      textAlign: TextAlign.right,
                      style: TextStyle(overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '사망자 수:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(acc.fatalities.toString()),
                ],
              ),
              SizedBox(height: 4.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '탑승자 수:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(acc.occupants.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Icon getAircraftStatusIcon(AircraftStatus status) {
  switch (status) {
    case AircraftStatus.destroyedWrittenOff ||
          AircraftStatus.destroyed ||
          AircraftStatus.substantialWrittenOff:
      return Icon(Icons.airplanemode_off, color: Colors.red);
    case AircraftStatus.substantial ||
          AircraftStatus.substantialRepaired ||
          AircraftStatus.destroyedRepaired:
      return Icon(Icons.airplanemode_on, color: Colors.orange);
    case AircraftStatus.minor ||
          AircraftStatus.minorRepaired ||
          AircraftStatus.minorWrittenOff:
      return Icon(Icons.airplanemode_on_rounded, color: Colors.yellow);
    case AircraftStatus.none || AircraftStatus.noneRepaired:
      return Icon(Icons.airplanemode_on, color: Colors.blue);
    case AircraftStatus.unknown ||
          AircraftStatus.unknownUnknown ||
          AircraftStatus.unknownRepaired ||
          AircraftStatus.unknownWrittenOff:
      return Icon(Icons.question_mark, color: Colors.grey);
    default:
      return Icon(Icons.question_mark, color: Colors.black);
  }
}
