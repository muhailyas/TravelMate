import 'package:flutter/material.dart';
import 'package:travelmate/Db/category_and_district_list/category_list.dart';
import 'package:travelmate/Db/category_and_district_list/district_list.dart';

class DropDownButtonField extends StatefulWidget {
   const DropDownButtonField(
      {super.key,
      required this.hintText,
      required this.listName,
      required this.item,
      required this.onChanged,
      this.categorySelectedValue,
      this.districtSelectedValue});
  final String hintText;
  final List listName;
  final bool item;
  final ValueSetter onChanged;
  final String? districtSelectedValue;
  final String? categorySelectedValue;
  @override
  State<DropDownButtonField> createState() => _DropDownButtonFieldState();
}

class _DropDownButtonFieldState extends State<DropDownButtonField> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double heightmedia = size.height;
    double widthmedia = size.width;
    return SizedBox(
      height: heightmedia * .10,
      width: widthmedia * 0.85,
      child: DropdownButtonFormField<String>(
        borderRadius: BorderRadius.circular(25),
        dropdownColor: const Color.fromARGB(255, 102, 93, 42),
        validator: (value) {
          if (value == null && value!.isEmpty) {
            return 'please enter ${widget.hintText}';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Colors.white)),
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.white, width: 0),
          ),
          labelText: widget.hintText,
          labelStyle: const TextStyle(color: Colors.white),
        ),
        value: widget.item ? widget.districtSelectedValue :widget.categorySelectedValue,
        style: const TextStyle(color: Colors.white),
        onChanged: (newValue) {
          widget.onChanged(newValue);
        },
        items: widget.item
            ? districts.map((districtModel) {
                return DropdownMenuItem<String>(
                    value: districtModel, child: Text(districtModel));
              }).toList()
            : categories.map((categoryModel) {
                return DropdownMenuItem<String>(
                    value: categoryModel[0], child: Text(categoryModel[0]));
              }).toList(),
      ),
    );
  }
}
