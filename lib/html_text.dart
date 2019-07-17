import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

class HtmlText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final TextStyle style;
  final Map<String, TextStyle> elementStyles;

  const HtmlText({
    @required this.text,
    Key key,
    this.textAlign,
    this.style,
    this.elementStyles,
  })  : assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Html(
      data: text,
      defaultTextStyle: style,
      customTextAlign: textAlign == null ? null : (_) => TextAlign.center,
      customTextStyle: elementStyles == null ? null : _applyElementStyle,
    );
  }

  TextStyle _applyElementStyle(dom.Node node, TextStyle baseStyle) {
    if (node is dom.Element) {
      final custom = elementStyles[node.localName];
      if (custom != null) {
        return baseStyle.merge(custom);
      }
    }
    return style;
  }
}
