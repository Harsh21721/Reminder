// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remi/reminder/Themes/theme.dart';

class InputFields extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  const InputFields({super.key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
            height: 50,
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.only(left: 14),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.0
              ),
              borderRadius: BorderRadius.circular(12)
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: widget == null?false:true,
                    autofocus: false,
                    controller: controller,
                    style: subTitleStyle,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: subTitleStyle,
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 0
                        )
                      )
                    ),


                  ),
                ),
                widget==null?Container():Container(child: widget)
              ]
            ),
          )

        ],
      ),
    );
  }
}
