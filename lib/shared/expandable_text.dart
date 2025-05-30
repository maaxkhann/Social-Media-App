import 'package:flutter/material.dart';
import 'package:social_media/constants/app_text.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int trimLines;
  final double fontSize;

  const ExpandableText({
    super.key,
    required this.text,
    this.trimLines = 3,
    this.fontSize = 14,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;
  bool showToggle = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverflow());
  }

  void _checkOverflow() {
    final span = TextSpan(
      text: widget.text,
      style: TextStyle(fontSize: widget.fontSize),
    );
    final tp = TextPainter(
      text: span,
      maxLines: widget.trimLines,
      textDirection: TextDirection.ltr,
    );
    tp.layout(maxWidth: MediaQuery.of(context).size.width * 0.85);
    setState(() {
      showToggle = tp.didExceedMaxLines;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: widget.text,
          size: widget.fontSize,
          maxLine: isExpanded ? 50 : widget.trimLines,
          txtOverFlow:
              isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        if (showToggle)
          TextButton(
            onPressed: () => setState(() => isExpanded = !isExpanded),
            child: CustomText(
              title: isExpanded ? 'See Less' : 'See More',
              size: 10,
            ),
          ),
      ],
    );
  }
}
