import 'package:f_aviation_accidents/accident_tile.dart';

class AccidentWithDescription extends Accident {
  String description;

  AccidentWithDescription({
    required DateTime date,
    required int fatalities,
    required int occupants,
    required String location,
    required String airline,
    required this.description,
  }) : super(
          date: date,
          fatalities: fatalities,
          occupants: occupants,
          location: location,
          airline: airline,
        );
}
