import 'package:flutter/material.dart';

class CustomFieldInsideContainer extends StatelessWidget {
  const CustomFieldInsideContainer(
      {super.key,
      this.icon,
      required this.labeltext,
      required this.inputextController,
      required this.screenWidth,
      required this.screenHeight,
      this.maxLength,
      this.onChanged});
  final String labeltext;
  final TextEditingController inputextController;
  final IconData? icon;
  final int? maxLength;
  final double screenWidth;
  final double screenHeight;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    // Get screen size using MediaQuery

    return Column(
      children: [
        SizedBox(
          height: screenHeight * 0.002,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: screenHeight * 0.16,
              child: Text(
                labeltext,
                style: TextStyle(
                    fontSize: screenWidth * 0.037, fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              height: screenHeight * 0.05,
              width: screenWidth * 0.45,
              // margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    offset: Offset(0, 1),
                    blurRadius: 2.0,
                  ),
                ],
              ),
              child: TextFormField(
                onChanged: onChanged,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: inputextController,
                maxLength: maxLength,
                // textAlign: TextAlign.end,
                decoration: InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                  ),
                  suffixIcon: Icon(icon),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 12.0),
                ),
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
