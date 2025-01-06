import 'package:f_aviation_accidents/accident_tile.dart';
import 'package:f_aviation_accidents/aircraft_status.dart';
import 'package:f_aviation_accidents/api.dart';
import 'package:flutter/material.dart';

class AccidentWithDescription extends Accident {
  String description;

  AccidentWithDescription({
    required DateTime date,
    required int fatalities,
    required int occupants,
    required String location,
    required String airline,
    required AircraftStatus aircraftStatus,
    required this.description,
  }) : super(
          date: date,
          fatalities: fatalities,
          occupants: occupants,
          location: location,
          airline: airline,
          aircraftStatus: aircraftStatus,
        );
}

class DescriptionScreen extends StatefulWidget {
  final Accident acc;

  const DescriptionScreen({
    super.key,
    required this.acc,
  });

  @override
  DescriptionScreenState createState() => DescriptionScreenState();
}

class DescriptionScreenState extends State<DescriptionScreen> {
  late AccidentWithDescription accDescription;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDescription();
  }

  Future<void> _fetchDescription() async {
    final description =
        await fetchDescription(widget.acc.airline, widget.acc.date);

    setState(() {
      accDescription = AccidentWithDescription(
        date: widget.acc.date,
        fatalities: widget.acc.fatalities,
        occupants: widget.acc.occupants,
        location: widget.acc.location,
        airline: widget.acc.airline,
        aircraftStatus: widget.acc.aircraftStatus,
        description: description,
      );
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Description"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              accDescription.description,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
