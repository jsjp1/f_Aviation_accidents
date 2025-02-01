import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SortDropdownButton extends StatefulWidget {
  final Function(String) updateOrderState;
  const SortDropdownButton({super.key, required this.updateOrderState});

  @override
  SortDropdownButtonState createState() => SortDropdownButtonState();
}

class SortDropdownButtonState extends State<SortDropdownButton> {
  String selectedSort = "dropdown_newest";
  final List<String> sortOptions = ["dropdown_newest", "dropdown_oldest"];

  void onSortSelected(String value) {
    setState(() {
      selectedSort = value;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedSort = sortOptions[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      child: DropdownMenu<String>(
        width: 120.0,
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(Colors.white),
          elevation: WidgetStateProperty.all(6),
          padding: WidgetStateProperty.all(
            EdgeInsets.all(0.0),
          ),
        ),
        textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        inputDecorationTheme: InputDecorationTheme(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
        ),
        initialSelection: sortOptions.first,
        onSelected: (String? value) {
          setState(() {
            selectedSort = value!;
          });

          widget.updateOrderState(value!);
        },
        dropdownMenuEntries:
            sortOptions.map<DropdownMenuEntry<String>>((String value) {
          return DropdownMenuEntry<String>(
            value: value,
            label: tr(value),
          );
        }).toList(),
      ),
    );
  }
}
