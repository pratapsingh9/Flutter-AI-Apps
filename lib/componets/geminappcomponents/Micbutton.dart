import 'package:flutter/material.dart';

class MicButton extends StatelessWidget {
  const MicButton({super.key, required this.Add_ingridents_items});

  final VoidCallback? Add_ingridents_items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: InkWell(
        focusColor: Colors.blue.shade400,
        onTap: () {
          Add_ingridents_items?.call();
        },
        child: Container(
            height: 63,
            width: 60,
            decoration: BoxDecoration(
                color: Colors.lightBlue.shade400,
                borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.add , color: Colors.white,)),
      ),
    );
  }
}
