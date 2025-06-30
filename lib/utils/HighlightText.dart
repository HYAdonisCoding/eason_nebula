import 'package:flutter/material.dart';

class HighlightText extends StatelessWidget {
  final String text;
  final List<String> highlights;
  final TextStyle? style;
  final TextStyle? highlightStyle;
  final Map<String, TextStyle>? highlightStyles;
  final Map<String, VoidCallback>? highlightTaps; // 新增：指定词的点击事件

  const HighlightText({
    Key? key,
    required this.text,
    required this.highlights,
    this.style,
    this.highlightStyle,
    this.highlightStyles,
    this.highlightTaps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (highlights.isEmpty) {
      return Text(text, style: style);
    }
    final pattern = highlights.map(RegExp.escape).join('|');
    final reg = RegExp(pattern);

    final spans = <InlineSpan>[];
    int start = 0;
    reg.allMatches(text).forEach((match) {
      if (match.start > start) {
        spans.add(
          TextSpan(text: text.substring(start, match.start), style: style),
        );
      }
      final matchText = match.group(0)!;
      final ts =
          highlightStyles != null && highlightStyles!.containsKey(matchText)
          ? highlightStyles![matchText]
          : (highlightStyle ?? style);
      if (highlightTaps != null && highlightTaps!.containsKey(matchText)) {
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: GestureDetector(
              onTap: highlightTaps![matchText],
              child: Text(matchText, style: ts),
            ),
          ),
        );
      } else {
        spans.add(TextSpan(text: matchText, style: ts));
      }
      start = match.end;
    });
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start), style: style));
    }
    return RichText(text: TextSpan(children: spans));
  }
}
