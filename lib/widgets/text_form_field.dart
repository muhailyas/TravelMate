import 'package:flutter/material.dart';
import 'package:travelmate/Widgets/ValidatorFunctions.dart';
import 'package:travelmate/Widgets/text.dart';

class TextFormFieldWidget extends StatefulWidget {
  final String hintText;
  final Function function;
  final TextEditingController controller;

  const TextFormFieldWidget({
    Key? key,
    required this.hintText,
    required this.function,
    required this.controller,
  }) : super(key: key);

  @override
  TextFormFieldWidgetState createState() => TextFormFieldWidgetState();
}

class TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  bool obscureText = true;
  bool suffixIconVisibility = true;
  @override
  Widget build(BuildContext context) {
    final heightmedia = MediaQuery.of(context).size.height;
    final widthmedia = MediaQuery.of(context).size.width;

    return SizedBox(
      height: heightmedia * .10,
      width: widthmedia * 0.85,
      child: TextFormField(
        obscureText: widget.function == isValidPass ? obscureText : false,
        controller: widget.controller,
        style: const TextStyle(
          color: Colors.white,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'please enter ${widget.hintText}';
          } else if (widget.function == isValidName) {
            return isValidName(value) ? null : 'Invalid ${widget.hintText}';
          } else if (widget.function == isValidPass) {
            return isValidPass(value) ? null : 'at least 6 letters required';
          } else if (widget.function == isValidEmail) {
            return isValidEmail(value) ? null : 'Invalid ${widget.hintText}';
          }
          return null;
        },
        onChanged: (_) {
          updateIcon();
        },
        decoration: InputDecoration(
          labelText: widget.hintText,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 0),
            borderRadius: BorderRadius.circular(25.0),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25),
          ),
          labelStyle: formFielTextStyle,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25),
          ),
          suffixIcon: widget.function == isValidPass &&
                  widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: obscureText
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility),
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }

  void updateIcon() {
    setState(() {
      suffixIconVisibility =
          widget.function == isValidPass && widget.controller.text.isNotEmpty;
    });
  }
}
