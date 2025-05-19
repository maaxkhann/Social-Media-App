import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/extensions/build_context.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final bool isBorder;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.isBorder = true,
    this.maxLines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: TextField(
        controller: widget.controller,
        obscureText: _obscure,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontSize: 12,
            color: context.theme.colorTheme.black.withValues(alpha: 0.5),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color:
                  !widget.isBorder ? AppColors.white : AppColors.primaryColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color:
                  !widget.isBorder ? AppColors.white : AppColors.primaryColor,
            ),
          ),
          suffixIcon:
              widget.obscureText
                  ? IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.black,
                      size: 18,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                  )
                  : widget.suffixIcon,
        ),
      ),
    );
  }
}
