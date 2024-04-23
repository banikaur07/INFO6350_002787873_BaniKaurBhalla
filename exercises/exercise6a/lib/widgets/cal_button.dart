import 'package:class_exercise_6a/provider/cal_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';

class CalculateButton extends StatelessWidget {
  const CalculateButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          Provider.of<CalculatorProvider>(context, listen: false).setValue("="),
      child: Container(
        height: 160,
        width: 70,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 95, 152, 250),
            borderRadius: BorderRadius.circular(40)),
        child: const Center(
          child: Text(
            "=",
            style: TextStyle(
              fontSize: 32,
            ),
          ),
        ),
      ),
    );
  }
}
