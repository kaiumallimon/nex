
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = 300,
    this.height = 50,
    this.isLoading = false,
  });

  final String text;
  final void Function() onPressed;
  final double width;
  final double height;
  final bool isLoading;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColorDark,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: isLoading
            ?  Center(
                child: CupertinoActivityIndicator(
                  radius: 10,
                  color: Theme.of(context).primaryColorDark,
                ),
              )
            : Text(text),
      ),
    );
  }
}
