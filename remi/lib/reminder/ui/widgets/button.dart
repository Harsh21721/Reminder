import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;

  const MyButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child:Container(
        width:100,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color.fromRGBO(31,182,246,1),

        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(

              color: Color.fromRGBO(255, 255, 255, 1),
              fontSize:15,

            ),
          ),
        ),
      ),
    );
  }
}
