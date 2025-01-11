import 'package:auto_size_text/auto_size_text.dart';
import 'package:f_aviation_accidents/components/accident_tile.dart';
import 'package:f_aviation_accidents/ads/ad_widget.dart';
import 'package:f_aviation_accidents/utils/api.dart';
import 'package:f_aviation_accidents/components/drawer.dart';
import 'package:flutter/material.dart';

class AccidentWithDescription extends Accident {
  String description;
  late String koDescription = "";

  AccidentWithDescription({
    required super.date,
    required super.id,
    required super.fatalities,
    required super.occupants,
    required super.location,
    required super.airline,
    required super.aircraftStatus,
    required this.description,
    required this.koDescription,
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
  bool isKo = false;
  String translateLanguage = "번역문 보기";

  @override
  void initState() {
    super.initState();
    _fetchDescription();
  }

  Future<void> _fetchDescription() async {
    setState(() {
      isLoading = true;
    });

    final description = await fetchDescription(widget.acc.id);

    setState(() {
      accDescription = AccidentWithDescription(
        date: widget.acc.date,
        id: widget.acc.id,
        fatalities: widget.acc.fatalities,
        occupants: widget.acc.occupants,
        location: widget.acc.location,
        airline: widget.acc.airline,
        aircraftStatus: widget.acc.aircraftStatus,
        description: description,
        koDescription: "",
      );
      isLoading = false;
    });
  }

  Future<void> _fetchKoDescription(String description) async {
    setState(() {
      isLoading = true;
    });

    final koDescription =
        await translateDescription(widget.acc.id, description);

    setState(() {
      accDescription.koDescription = koDescription;
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
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
              child: Row(
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
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(top: 30.0),
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
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "상황",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                  TextButton(
                    child: Row(
                      children: [
                        Text(translateLanguage),
                        Icon(Icons.rotate_left_rounded),
                      ],
                    ),
                    onPressed: () async {
                      if (isKo) {
                        setState(() {
                          translateLanguage = "번역문 보기";
                          isKo = false;
                        });
                      } else {
                        if (accDescription.koDescription == "") {
                          await _fetchKoDescription(accDescription.description);
                          setState(() {
                            translateLanguage = "원문 보기";
                            isKo = true;
                          });
                        } else {
                          setState(() {
                            translateLanguage = "원문 보기";
                            isKo = true;
                          });
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.all(25.0),
                    child: Text(
                      accDescription.koDescription == "" || isKo == false
                          ? accDescription.description
                          : accDescription.koDescription,
                      style: TextStyle(
                        fontSize: 16.0,
                        height: 1.5,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  BannerWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
      endDrawer: AvccDrawer(),
    );
  }
}
