import 'package:flutter/material.dart';

class CustomTextWithTextFormField extends StatelessWidget {
  const CustomTextWithTextFormField({
    super.key,
    this.icon,
    required this.labeltext,
    // required this.inputext,
    required this.controller,
    this.validator,
  });
  final String labeltext;
  // final String inputext;
  final IconData? icon;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    // Get screen size using MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: screenHeight * 0.1,
          child: Text(
            labeltext,
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Material(
            elevation: 7, // Controls the shadow intensity
            shadowColor: Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(5),
            child: TextFormField(
              keyboardType: TextInputType.number,
              validator: validator,
              controller: controller,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none, // No visible border
                ),
                filled: true,
                fillColor: Colors.white, // Field background color
                suffixIcon: Icon(icon),
              ),
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: screenWidth * 0.04, // Adjust the text size
              ),
            ),
          ),
        ),
      ],
    );
  }
}
