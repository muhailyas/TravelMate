import 'dart:core';

bool isValidNames(String input) {
  return true;
}

bool isValidEmail(String input) {
  final emailRegex = RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$");
  final emailContains = input.contains('@gmail.com');
  return emailRegex.hasMatch(input) && emailContains;
}

bool isValidName(String input) {
  final alphabetsRegex = RegExp(r'^[a-zA-Z]+$');
  return alphabetsRegex.hasMatch(input);
}

bool isValidPass(String input) {
  return input.length > 5;
}
