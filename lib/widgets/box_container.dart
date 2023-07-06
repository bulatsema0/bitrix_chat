import 'package:bitrix_chat/themes/app_defaults.dart';
import 'package:flutter/material.dart';

class BoxContainer extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final bool hasError;
  final Color? color;
  final BoxConstraints? constraints;
  final bool showShadow;
  final DecorationImage? decorationImage;
  final BoxShape shape;
  final BoxDecoration? decoration;
  final bool enablePadding;
  final EdgeInsetsGeometry? padding;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;

  const BoxContainer({
    Key? key,
    this.child,
    this.width,
    this.height,
    this.hasError = false,
    this.color,
    this.constraints,
    this.showShadow = true,
    this.decorationImage,
    this.shape = BoxShape.rectangle,
    this.decoration,
    this.enablePadding = true,
    this.padding,
    this.border,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.easeIn,
      duration: const Duration(
          milliseconds: AppDefaults.kStandartMinDelayMilliseconds),
      margin: const EdgeInsets.all(AppDefaults.kStandartContentPaddingLow),
      width: width,
      height: height,
      constraints: constraints,
      decoration: decoration ??
          BoxDecoration(
            shape: shape,
            image: decorationImage,
            color: color ?? Theme.of(context).cardColor,
            border: border,
            borderRadius: shape != BoxShape.rectangle
                ? null
                : borderRadius ??
                    BorderRadius.circular(AppDefaults.kStandartBorderRadius),
            boxShadow: showShadow
                ? [
                    BoxShadow(
                      color: hasError
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).highlightColor,
                      blurRadius: AppDefaults.kStandartBlurRadius,
                      spreadRadius: AppDefaults.kStandartSpreadRadius,
                      offset: const Offset(0.0, 0.0),
                    ),
                  ]
                : null,
          ),
      child: Padding(
        padding: child.runtimeType == TextField ||
                child.runtimeType == TextFormField ||
                child.runtimeType == Padding ||
                !enablePadding
            ? const EdgeInsets.all(0.0)
            : padding ??
                const EdgeInsets.all(AppDefaults.kStandartContentPadding),
        child: child,
      ),
    );
  }
}
