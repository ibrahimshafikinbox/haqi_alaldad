import 'package:flutter/material.dart';

import 'package:store_mangment/Feature/resources/colors/colors.dart';

class DefaultButton extends StatelessWidget {
  final double height;
  // final Color background;
  final VoidCallback function;
  final String text;
  final bool isUpperCase;
  final double radius;
  final Color textColor;
  final Color bottonColor;

  const DefaultButton({
    Key? key,
    this.height = 50,
    required this.function,
    required this.text,
    this.isUpperCase = false,
    this.radius = 15.0,
    required this.textColor,
    required this.bottonColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: bottonColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MaterialButton(
            onPressed: function,
            child: Text(
              isUpperCase ? text.toUpperCase() : text,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18.0,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class appButton extends StatelessWidget {
  final double height;
  // final Color background;
  final VoidCallback function;
  final String text;
  final bool isUpperCase;
  final double radius;
  final Color textColor;
  final Color bottonColor;

  const appButton({
    super.key,
    this.height = 50,
    required this.function,
    required this.text,
    this.isUpperCase = false,
    this.radius = 25.0,
    required this.textColor,
    required this.bottonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      // width: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.black),
        borderRadius: BorderRadius.circular(radius),
        color: AppColors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          onPressed: function,
          child: Text(
            isUpperCase ? text.toUpperCase() : text,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18.0,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class appButtonWithIcon extends StatelessWidget {
  final double height;
  // final Color background;
  final VoidCallback function;
  final String text;
  final bool isUpperCase;
  final double radius;
  final Color textColor;
  final Color bottonColor;
  final IconData icon;

  const appButtonWithIcon({
    Key? key,
    this.height = 50,
    required this.function,
    required this.text,
    this.isUpperCase = false,
    this.radius = 25.0,
    required this.textColor,
    required this.bottonColor,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.black),
        borderRadius: BorderRadius.circular(radius),
        color: AppColors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          onPressed: function,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Center(
                child: Text(
                  isUpperCase ? text.toUpperCase() : text,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                    color: textColor,
                  ),
                ),
              ),
              const Spacer(),

              // Spacer(),
              Icon(icon),
            ],
          ),
        ),
      ),
    );
  }
}

class FinishedConractButton extends StatelessWidget {
  final double height;
  final VoidCallback function;
  final String text;
  final bool isUpperCase;
  final double radius;
  final Color textColor;
  final Color bottonColor;
  final IconData icon;
  final bool condition;

  const FinishedConractButton({
    Key? key,
    this.height = 50,
    required this.function,
    required this.text,
    this.isUpperCase = false,
    this.radius = 25.0,
    required this.textColor,
    required this.bottonColor,
    required this.icon,
    required this.condition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.black),
        borderRadius: BorderRadius.circular(radius),
        color: AppColors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          onPressed: function,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Center(
                child: Text(
                  isUpperCase ? text.toUpperCase() : text,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                    color: textColor,
                  ),
                ),
              ),
              const Spacer(),
              condition
                  ? const Icon(Icons.check, color: AppColors.green, size: 30)
                  : const Icon(Icons.navigate_before),
              // Spacer(),
              // Icon(icon)
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentButton extends StatelessWidget {
  final double height;
  // final Color background;
  final VoidCallback function;
  final String text;
  final bool isUpperCase;
  final double radius;
  final Color textColor;
  final Color bottonColor;
  final IconData icon;

  const PaymentButton({
    Key? key,
    this.height = 50,
    required this.function,
    required this.text,
    this.isUpperCase = false,
    this.radius = 12.0,
    required this.textColor,
    required this.bottonColor,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.black),
        borderRadius: BorderRadius.circular(radius),
        color: AppColors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          onPressed: function,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.green),
              const Spacer(),
              Center(
                child: Text(
                  isUpperCase ? text.toUpperCase() : text,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                    color: textColor,
                  ),
                ),
              ),
              const Spacer(),

              // Spacer(),
              Icon(Icons.navigate_next),
            ],
          ),
        ),
      ),
    );
  }
}
