import 'package:f_aviation_accidents/accident_tile.dart';
import 'package:f_aviation_accidents/aircraft_status.dart';

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
