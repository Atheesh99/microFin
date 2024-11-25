import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.icon,
    this.errorText,
    this.width,
    required this.labeltext,
    this.inputText,
  });
  final IconData? icon;
  final String labeltext;
  final String? inputText;
  final String? errorText;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labeltext != ""
            ? Padding(
                padding: const EdgeInsets.only(left: 27),
                child: Text(
                  labeltext,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w400),
                ),
              )
            : const SizedBox(),
        TextFormField(
          initialValue: inputText,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
          decoration: InputDecoration(
            errorText: errorText,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                color: Colors.black,
                width: 1.0,
              ),
            ),
            suffixIcon: Icon(
              icon,
            ),
          ),
        ),
      ],
    );
  }
}

class CustomDropDownTextFormField extends StatelessWidget {
  const CustomDropDownTextFormField({
    super.key,
    this.icon,
    this.errorText,
    this.width,
    required this.labeltext,
    this.dropdownItems,
    this.onChanged,
    this.hintText,
  });

  final IconData? icon;
  final String labeltext;
  final String? errorText;
  final double? width;
  final List<String>? dropdownItems;
  final ValueChanged<String?>? onChanged;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 27),
          child: Text(
            labeltext,
            style: const TextStyle(fontSize: 13),
          ),
        ),
        Container(
          margin:
              EdgeInsets.only(left: width ?? 23, right: width ?? 23, top: 5),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelStyle: const TextStyle(fontSize: 19),
              errorText: errorText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              suffixIcon: Icon(icon),
            ),
            hint: Text(hintText ?? "Select an option"),
            items: dropdownItems?.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
