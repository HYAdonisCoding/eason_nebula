import 'package:flutter/material.dart';

class HighlightText extends StatelessWidget {
  final String text;
  final List<String> highlights;
  final TextStyle? style;
  final TextStyle? highlightStyle;
  final Map<String, TextStyle>? highlightStyles; // 可选：每个高亮词单独样式

  const HighlightText({
    Key? key,
    required this.text,
    required this.highlights,
    this.style,
    this.highlightStyle,
    this.highlightStyles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (highlights.isEmpty) {
      return Text(text, style: style);
    }
    final pattern = highlights.map(RegExp.escape).join('|');
    final reg = RegExp(pattern);

    final spans = <TextSpan>[];
    int start = 0;
    reg.allMatches(text).forEach((match) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start), style: style));
      }
      final matchText = match.group(0)!;
      // 优先使用 highlightStyles，其次用 highlightStyle
      final ts = highlightStyles != null && highlightStyles!.containsKey(matchText)
          ? highlightStyles![matchText]
          : highlightStyle;
      spans.add(TextSpan(text: matchText, style: ts));
      start = match.end;
    });
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start), style: style));
    }
    return Text.rich(TextSpan(children: spans));
  }
}