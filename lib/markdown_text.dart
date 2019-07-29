import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final TextStyle style;
  final Map<String, TextStyle> elementStyles;

  const MarkdownText({
    @required this.text,
    Key key,
    this.textAlign,
    this.style,
    this.elementStyles,
  })  : assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO(aaron): How to apply textAlign?
    return MarkdownBody(
      data: text,
      styleSheet: _genStyleSheet(context),
    );
  }

  MarkdownStyleSheet _genStyleSheet(BuildContext context) {
    var sheet = MarkdownStyleSheet.fromTheme(Theme.of(context));
    if (style != null) {
      sheet = sheet.copyWith(p: sheet.p.merge(style));
    }
    final emStyle = elementStyles['em'];
    if (emStyle != null) {
      sheet = sheet.copyWith(em: sheet.em.merge(emStyle));
    }
    final strongStyle = elementStyles['strong'];
    if (strongStyle != null) {
      sheet = sheet.copyWith(strong: sheet.strong.merge(strongStyle));
    }
    return sheet;
  }
}
