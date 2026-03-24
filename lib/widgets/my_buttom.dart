import 'package:flutter/material.dart';
import 'package:recipe_app/core/theme/app_text_style_.dart';
import 'package:recipe_app/core/theme/app_theme.dart';
 

class MyCustomButton extends StatelessWidget {
  const MyCustomButton({
    super.key,
    required this.myText,
    this.onTap,
    this.myColor,
    this.myBorderColor,
    this.mytextColor,
    this.myfontSize,
    this.myfontPending,
    this.mybuttomHorizontalPadding,
    this.mybuttomHeight,
    this.mybuttomradius,
    this.myicon,
    this.isLoading = false,
    this.mybuttomverticalPadding,
    this.myLoaderColor,
    this.myFontFamily,
    this.hasLinearGradient = false,
    this.mybackIconcon,
  });

  final String myText;
  final String? myFontFamily;
  final VoidCallback? onTap;
  final Color? myColor;
  final Color? myBorderColor;
  final Color? mytextColor;
  final Color? myLoaderColor;
  final double? myfontSize;
  final double? myfontPending;
  final double? mybuttomHorizontalPadding;
  final double? mybuttomverticalPadding;
  final double? mybuttomHeight;
  final double? mybuttomradius;
  final Widget? myicon;
  final Widget? mybackIconcon;
  final bool isLoading;
  final bool hasLinearGradient;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading == true ? () {} : onTap,
      onSecondaryTap: () {
        // AppSnackBar.show('Please Wait');
      },
      onDoubleTap: () {
        // AppSnackBar.show('Please Wait');
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: mybuttomHorizontalPadding ?? 10,
          vertical: mybuttomverticalPadding ?? 6,
        ),
        width: double.infinity,
        height: mybuttomHeight ?? 56,
        padding: EdgeInsets.all(myfontPending ?? 8.0),
        decoration: BoxDecoration(
          color: hasLinearGradient ? null : (myColor ?? AppColors.primary),
          gradient: hasLinearGradient
              ? const LinearGradient(
                  colors: [Color(0XFFF4BA09), Color(0XFFFEDC04)],
                )
              : null,
          borderRadius: BorderRadius.circular(mybuttomradius ?? 12),
          border: Border.all(color: myBorderColor ?? AppColors.primary),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              myicon ?? const SizedBox(),
              myicon == null ? const SizedBox() : const SizedBox(width: 10),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(
                        begin: 0.9,
                        end: 1.0,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: isLoading
                    ? SizedBox(
                        key: const ValueKey('loader'),
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: myLoaderColor ?? AppColors.white,
                        ),
                      )
                    : Text(
                        myText,
                        key: const ValueKey('text'),
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.w700.copyWith(
                          fontFamily: myFontFamily ?? appFontFamily,
                          fontSize: myfontSize ?? 18,
                          color: mytextColor ?? Colors.white,
                        ),
                      ),
              ),
              mybackIconcon ?? const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
