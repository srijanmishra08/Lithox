import 'package:flutter/material.dart';

/// Lithox Logo Widget - Displays the company logo
class LithoxLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  const LithoxLogo({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.backgroundColor,
    this.padding,
  });

  /// Small logo for app bars and compact spaces
  const LithoxLogo.small({
    super.key,
    this.fit = BoxFit.contain,
    this.backgroundColor,
    this.padding,
  }) : width = 40,
       height = 40;

  /// Medium logo for headers and cards
  const LithoxLogo.medium({
    super.key,
    this.fit = BoxFit.contain,
    this.backgroundColor,
    this.padding,
  }) : width = 80,
       height = 80;

  /// Large logo for splash screens and main headers
  const LithoxLogo.large({
    super.key,
    this.fit = BoxFit.contain,
    this.backgroundColor,
    this.padding,
  }) : width = 120,
       height = 120;

  /// Extra large logo for splash/welcome screens
  const LithoxLogo.extraLarge({
    super.key,
    this.fit = BoxFit.contain,
    this.backgroundColor,
    this.padding,
  }) : width = 200,
       height = 200;

  @override
  Widget build(BuildContext context) {
    Widget logo = Image.asset(
      'assets/images/icon.jpeg',
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        // Fallback if logo image is not found
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.business,
            size: (width ?? 40) * 0.6,
            color: Colors.grey[600],
          ),
        );
      },
    );

    if (padding != null) {
      logo = Padding(
        padding: padding!,
        child: logo,
      );
    }

    if (backgroundColor != null) {
      logo = Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: logo,
      );
    }

    return logo;
  }
}
