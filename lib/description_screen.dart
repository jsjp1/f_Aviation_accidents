import 'package:auto_size_text/auto_size_text.dart';
import 'package:f_aviation_accidents/accident_tile.dart';
import 'package:f_aviation_accidents/api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccidentWithDescription extends Accident {
  String description;

  AccidentWithDescription({
    required super.date,
    required super.fatalities,
    required super.occupants,
    required super.location,
    required super.airline,
    required super.aircraftStatus,
    required this.description,
  });
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
    final String formattedDate =
        DateFormat("yyyy-MM-dd").format(widget.acc.date);
    final description =
        await fetchDescription(widget.acc.airline, formattedDate);

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
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: AutoSizeText(
                      accDescription.airline,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 3,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 20.0, 20.0, 0.0),
                  child: IconButton(
                    icon: Icon(Icons.menu),
                    iconSize: 30.0,
                    // TODO: 메뉴
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            Flexible(
              child: Text(
                accDescription.description,
                style: TextStyle(
                  fontSize: 16.0,
                  height: 1.5,
                ),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
