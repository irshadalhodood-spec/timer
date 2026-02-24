import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomBreadcrumbHeader extends StatelessWidget implements PreferredSizeWidget {
  final List<TextSpan> crumbs;
  final String separator;
  final TextStyle? style;
  final double height;

  const CustomBreadcrumbHeader({
    Key? key,
    required this.crumbs,
    this.separator = ' > ',
    this.style,
    this.height = 48.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(height),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0, // Adjust as needed
          top: 24.0,  // Adjust as needed
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RichText(
              text: TextSpan(
                children: _buildBreadcrumbs(),
                style: style ?? Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TextSpan> _buildBreadcrumbs() {
    final List<TextSpan> breadcrumbSpans = [];
    for (var i = 0; i < crumbs.length; i++) {
      breadcrumbSpans.add(crumbs[i]);
      if (i < crumbs.length - 1) {
        breadcrumbSpans.add(TextSpan(text: separator));
      }
    }
    return breadcrumbSpans;
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
