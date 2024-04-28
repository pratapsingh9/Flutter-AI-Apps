import 'package:flutter/material.dart';

class RecipeButton extends StatelessWidget {
  final bool ingredientsEmpty;
  final VoidCallback onTapGenerate;
  final String buttonText;

  const RecipeButton({
    Key? key,
    required this.ingredientsEmpty,
    required this.onTapGenerate,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ingredientsEmpty
          ? () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(
                      'No ingredients selected',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 28,
                          fontWeight: FontWeight.w300),
                    ),
                    content:
                        const Text('Please select at least one ingredient'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("OK"),
                      ),
                    ],
                  );
                },
              );
            }
          : onTapGenerate,
      child: Container(
        margin: EdgeInsets.only(
            right: MediaQuery.of(context).size.width * 0.1,
            left: MediaQuery.of(context).size.width * 0.1),
        width: MediaQuery.of(context).size.width * 0.8,
        height: 60, // Aesthetic height
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ingredientsEmpty ? Colors.grey.shade400 : Colors.blue,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              offset: Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_awesome),
            const SizedBox(width: 25.0),
            Text(
              buttonText,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
