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
  final bool autoFocus;
  final int maxLines;
  final Color? fillColor;
  final Color? hintColor;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.isBorder = true,
    this.autoFocus = false,
    this.maxLines = 1,
    this.fillColor = AppColors.white,
    this.hintColor = AppColors.black,
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
        autofocus: widget.autoFocus,
        keyboardType:
            widget.maxLines != 1
                ? TextInputType.multiline
                : widget.keyboardType,
        // cursorColor: widget.hintColor,
        style: TextStyle(color: widget.hintColor, fontSize: 14),
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          fillColor: widget.fillColor,
          filled: true,

          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
          hintText: widget.hintText,
          hintStyle: TextStyle(fontSize: 12, color: widget.hintColor),

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
