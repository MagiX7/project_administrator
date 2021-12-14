import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 35,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.grey[600], borderRadius: BorderRadius.circular(5)),
      child: const Center(
        child: Text(
          "Add Task",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
