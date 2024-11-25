import 'package:flutter/material.dart';

class CustomTextWithTextFormField extends StatelessWidget {
  const CustomTextWithTextFormField({
    super.key,
    this.icon,
    required this.labeltext,
    required this.inputext,
  });
  final String labeltext;
  final String inputext;
  final IconData? icon;

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
        Container(
          height: screenHeight * 0.05,
          width: screenWidth * 0.6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 1),
                blurRadius: 2.0,
              ),
            ],
          ),
          child: TextFormField(
            initialValue: inputext,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
              suffixIcon: Icon(icon),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12, // Adjust this for vertical padding
                horizontal: 15, // Adjust this for horizontal padding
              ),
            ),
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: screenWidth * 0.04, // Adjust the text size
            ),
          ),
        ),
      ],
    );
  }
}
