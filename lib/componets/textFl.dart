import 'package:flutter/material.dart';

class TxtFiled extends StatelessWidget {
  const TxtFiled({
    super.key,
    required this.IngredientFoucsNodes,
    required this.ingriderntController,
    this.onSubmittedCallback, // Made it optional
  });

  final FocusNode IngredientFoucsNodes;
  final TextEditingController ingriderntController;
  final VoidCallback?
      onSubmittedCallback; // Change VoidCallbackAction? to VoidCallback? if needed

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: TextField(
        focusNode: IngredientFoucsNodes,
        autocorrect: true,
        controller: ingriderntController,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          hintText: "Enter ingredient's",
          border: OutlineInputBorder(
            borderRadius:  BorderRadius.all(Radius.circular(28))
          ),
          filled: true,
          labelText: "  Type Some Ingredients...",
          labelStyle: TextStyle(
            fontSize: 18.0,
            color: Colors.black
          ),
          alignLabelWithHint: true,
          focusColor: Colors.white,
        ),
        onSubmitted: (val) {
          // Use the null-aware call operator to invoke the callback if it is not null
          onSubmittedCallback?.call();
          IngredientFoucsNodes.requestFocus();
        },
      ),
    );
  }
}



// normal code 
// Flexible(
//   child: TextField(
                    //     focusNode: IngredientFoucsNodes,
                    //     autocorrect: true,
                    //     controller: _ingriderntController,
                    //     keyboardType: TextInputType.text,
                    //     decoration: const InputDecoration(
                    //       hintText: "Enter ingredient's",
                    //       border: OutlineInputBorder(),
                    //       filled: true,
                    //       labelText: "Enter Ingredient's",
                    //       alignLabelWithHint: true,
                    //       focusColor: Colors.white,
                    //     ),
                    //     onSubmitted: (val) {
                    //       _handleAdditems();
                    //       IngredientFoucsNodes.requestFocus();
                    //     },
                    //   ),
                    // ),