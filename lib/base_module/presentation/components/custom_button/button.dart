import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text;
  final double? width;
  final double? height;
  final double? borderRadius, elevation;
  final double? fontSize;
  final Widget? widget;
  final Color? textColor, bgColor, indicatorColor, borderColor;
  final bool isLoading;
  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final double? borderWidth;

  const PrimaryButton({
    super.key,
    required this.onTap,
    required this.text,
    this.width,
    this.height,
    this.elevation = 5,
    this.borderRadius,
    this.fontSize,
    this.textColor,
    this.bgColor,
    this.indicatorColor,
    this.widget,
    this.isLoading = false,
    this.gradient,
    this.padding,
    this.textStyle,
    this.borderColor,
    this.borderWidth,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final Tween<double> _tween = Tween<double>(begin: 1.0, end: 0.95);

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double effectiveBorderRadius = widget.borderRadius ?? 10;

    return GestureDetector(
      onTap: () {
        if (!widget.isLoading) {
          _controller.forward().then((_) {
            _controller.reverse();
          });
          widget.onTap();
        }
      },
      child: ScaleTransition(
        scale: _tween.animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn,
          ),
        ),
        child: Card(
          elevation: widget.elevation ?? 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
          ),
          child: Container(
            height: widget.height ?? 55,
            width: widget.width,
            alignment: Alignment.center,
            padding: widget.padding,
            decoration: BoxDecoration(
              color: widget.gradient == null ? widget.bgColor?? Theme.of(context).colorScheme.primary : null,
              gradient: widget.gradient,
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
              border: Border.all(
                color: widget.borderColor ?? Colors.transparent,
                width: widget.borderWidth ?? 1.0,
              ),
            ),
            child: widget.isLoading
                ? CupertinoActivityIndicator(color: widget.indicatorColor??Colors.white, )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        widget.text,
                        style: widget.textStyle ??
                            Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  fontSize: widget.fontSize ?? 14,
                                  fontWeight: FontWeight.w500,
                                  color: widget.textColor ?? Colors.white,  
                                ),
                      ),
                      widget.widget ?? const SizedBox.shrink(),

                  ],
                ),
          ),
        ),
      ),
    );
  }
}
