import 'package:flutter/material.dart';

class DefaultFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType type;
  final Function? onSubmit;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? onValidate;
  final VoidCallback? suffixPressed;
  final String label;
  final int maxlines;

  final String hint;
  final bool isPassword;
  final IconData? suffix;

  const DefaultFormField({
    Key? key,
    required this.controller,
    required this.type,
    this.onSubmit,
    this.onChanged,
    this.onTap,
    required this.onValidate,
    this.suffixPressed,
    required this.label,
    required this.maxlines,
    required this.hint,
    this.isPassword = false,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxlines,
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onChanged: onChanged,
      onTap: onTap,
      validator: onValidate,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white, // Background color
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black), // Label text color
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
            vertical: 15.0, horizontal: 12.0), // Padding
        suffixIcon: IconButton(
          onPressed: suffixPressed,
          icon: Icon(suffix),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }
}

class SelectorFormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final List<String> options; // List of categories
  final FormFieldValidator<String>? onValidate;

  const SelectorFormField({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.options,
    this.onValidate,
  }) : super(key: key);

  @override
  _SelectorFormFieldState createState() => _SelectorFormFieldState();
}

class _SelectorFormFieldState extends State<SelectorFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: true, // Prevents user from typing
      validator: widget.onValidate,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: widget.label,
        labelStyle: const TextStyle(color: Colors.black),
        hintText: widget.hint,
        contentPadding: const EdgeInsets.symmetric(
            vertical: 15.0, horizontal: 12.0), // Padding
        suffixIcon: PopupMenuButton<String>(
          icon: const Icon(Icons.keyboard_arrow_down), // Category icon
          onSelected: (String value) {
            setState(() {
              widget.controller.text =
                  value; // Update text field with selection
            });
          },
          itemBuilder: (BuildContext context) {
            return widget.options
                .map((String option) => PopupMenuItem<String>(
                      value: option,
                      child: Text(option),
                    ))
                .toList();
          },
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }
}

Widget passwordFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  ValueChanged<String>? onChanged,
  VoidCallback? onTap,
  required FormFieldValidator<String>? onValidate,
  VoidCallback? suffixPressed,
  required String label,
  required String hint,
  required IconData prefix,
  bool isPassword = false,
  IconData? suffix,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onChanged: onChanged,
      onTap: onTap,
      validator: onValidate,
      //

      //
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white, // Background color
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black), // Label text color
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
            vertical: 15.0, horizontal: 12.0), // Padding
        suffixIcon: IconButton(
          onPressed: suffixPressed,
          icon: Icon(suffix),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
