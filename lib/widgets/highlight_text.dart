
import 'package:flutter/material.dart';

class HighlightText extends StatelessWidget {
  final String searchQuery;
  final String fullText;

  const HighlightText(
      {super.key, required this.searchQuery, required this.fullText});

  @override
  Widget build(BuildContext context) {
    const TextStyle highlightStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.green, 
    );

    // Find the index of the matching text, ignoring case sensitivity
    int? index = fullText.toLowerCase().indexOf(searchQuery.toLowerCase());

    if (index != -1 && searchQuery.isNotEmpty) {
      // Create two parts: before and after the matched text
      String beforeMatch = fullText.substring(0, index);
      String matched = fullText.substring(index, index + searchQuery.length);
      String afterMatch = fullText.substring(index + searchQuery.length);

      // Return a Row with two Text widgets, one for the normal part and one for the matched part
      return Row(
        children: [
          Text(beforeMatch),
          Text(
            matched,
            style: highlightStyle,
          ),
          Text(afterMatch),
        ],
      );
    } else {
      // If no match found or search query is empty, just return the original text
      return Text(fullText);
    }
  }
}