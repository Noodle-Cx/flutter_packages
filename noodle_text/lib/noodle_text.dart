library noodle_text;

import 'package:flutter/material.dart';

class NoodleText extends StatelessWidget {
  NoodleText(
    String text, {
    Key? key,
    this.style,
    this.textAlign = TextAlign.start,
    this.onTap,
    this.spanColors = const [],
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.extraBold = false,
    this.lineHeight,
    this.fontFamily,
    this.defaultColor,
  })  : text = text.replaceAll('<br>', '\n'),
        super(key: key);

  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final VoidCallback? onTap;
  final List<Color?> spanColors;
  final int? maxLines;
  final TextOverflow overflow;
  final bool extraBold;
  final double? lineHeight;
  final String? fontFamily;
  final Color? defaultColor;

  Color? _defaultTextColor(BuildContext context) =>
      style?.color ??
      defaultColor ??
      Theme.of(context).textTheme.bodyText1?.color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RichText(
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        text: TextSpan(
          style: style?.copyWith(
                  fontFamily: fontFamily,
                  height: textHeight,
                  color: _defaultTextColor(context)) ??
              TextStyle(
                fontFamily: fontFamily,
                height: textHeight,
                color: _defaultTextColor(context),
              ),
          children: _getSpans(
            context,
            text,
          ),
        ),
      ),
    );
  }

  List<TextSpan> _getSpans(BuildContext context, String text) {
    final List<TextSpan> spans = [];
    var boldText = false;
    var underlineText = false;
    var italicText = false;
    var colorText = false;
    var hasOpenTag = false;
    var finalText = '';
    var colorIndex = 0;
    for (int i = 0; i < text.length; i++) {
      if (text[i] == '<') {
        hasOpenTag = true;
        if (finalText.isNotEmpty) {
          spans.add(
            _createSpan(
              context,
              finalText,
              boldText,
              italicText,
              colorText,
              underlineText,
              colorIndex,
            ),
          );
          finalText = '';
          boldText = false;
          underlineText = false;
          italicText = false;
          colorText = false;
        }

        if (i + 1 < text.length) {
          if (text[i + 1] == 'b') {
            boldText = true;
            i++;
          } else if (text[i + 1] == 'u') {
            underlineText = true;
            i++;
          } else if (text[i + 1] == 'i') {
            italicText = true;
            i++;
          } else if (text[i + 1] == 'c') {
            colorIndex++;
            colorText = true;
            i++;
          }
        }
      } else if (text[i] == '/') {
        if (hasOpenTag) {
          i++;
        } else {
          finalText += text[i];
        }
      } else if (text[i] == '>') {
        if (hasOpenTag) {
          hasOpenTag = false;
        } else {
          finalText += text[i];
        }
      } else {
        finalText += text[i];
      }

      if (i + 1 >= text.length) {
        spans.add(
          _createSpan(
            context,
            finalText,
            boldText,
            italicText,
            colorText,
            underlineText,
            colorIndex,
          ),
        );
      }
    }
    return spans;
  }

  TextSpan _createSpan(
    BuildContext context,
    String finalText,
    bool boldText,
    bool italicText,
    bool colorText,
    bool underlineText,
    int colorIndex,
  ) {
    if (boldText) {
      return _boldSpan(context, finalText, colorText, colorIndex);
    } else if (underlineText) {
      return _underlineSpan(context, finalText, colorText, colorIndex);
    } else if (italicText) {
      return _italicSpan(context, finalText, colorText, colorIndex);
    } else if (colorText) {
      return _colorSpan(context, finalText, colorIndex);
    } else {
      return TextSpan(
        text: finalText,
        style: style?.copyWith(
            fontFamily: fontFamily,
            height: textHeight,
            color: _defaultTextColor(context)),
      );
    }
  }

  TextSpan _boldSpan(
    BuildContext context,
    String text,
    bool colorText,
    int colorIndex,
  ) {
    return TextSpan(
      text: text,
      style: TextStyle(
        height: textHeight,
        fontFamily: fontFamily,
        fontWeight: extraBold
            ? FontWeight.w700
            : style?.fontWeight == FontWeight.w300
                ? FontWeight.w500
                : FontWeight.bold,
        color: colorText
            ? _getSpanColor(context, colorIndex)
            : _defaultTextColor(context),
      ),
    );
  }

  TextSpan _underlineSpan(
    BuildContext context,
    String text,
    bool colorText,
    int colorIndex,
  ) {
    return TextSpan(
      text: text,
      style: TextStyle(
        height: textHeight,
        fontFamily: fontFamily,
        decoration: TextDecoration.underline,
        color: colorText
            ? _getSpanColor(context, colorIndex)
            : _defaultTextColor(context),
      ),
    );
  }

  TextSpan _italicSpan(
    BuildContext context,
    String text,
    bool colorText,
    int colorIndex,
  ) {
    return TextSpan(
      text: text,
      style: TextStyle(
        height: textHeight,
        fontFamily: fontFamily,
        fontStyle: FontStyle.italic,
        color: colorText
            ? _getSpanColor(context, colorIndex)
            : _defaultTextColor(context),
      ),
    );
  }

  TextSpan _colorSpan(
    BuildContext context,
    String text,
    int colorIndex,
  ) {
    return TextSpan(
      text: text,
      style: TextStyle(
        color: _getSpanColor(context, colorIndex),
        height: textHeight,
      ),
    );
  }

  Color? _getSpanColor(
    BuildContext context,
    int colorIndex,
  ) {
    if (colorIndex <= spanColors.length) {
      return spanColors[colorIndex - 1];
    }
    if (spanColors.isNotEmpty) {
      return spanColors.last;
    }
    return _defaultTextColor(context);
  }

  double? get textHeight {
    if (style?.height != null) {
      return style?.height;
    }

    if (lineHeight != null) {
      return lineHeight! / (style?.fontSize ?? 1);
    }

    return 1;
  }
}
