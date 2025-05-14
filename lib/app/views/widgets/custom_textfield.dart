import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.isReadOnly = false,
    this.width = 300,
    this.height = 50,
  });

  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool isReadOnly;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextField(
        style: Theme.of(context).textTheme.bodyMedium,
        cursorColor: Theme.of(context).primaryColorDark,
        controller: controller,
        readOnly: isReadOnly,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).hintColor),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColorLight,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),

          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColorDark,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),

          filled: true,
          fillColor: Theme.of(context).primaryColorLight.withOpacity(.2),
        ),
      ),
    );
  }
}
