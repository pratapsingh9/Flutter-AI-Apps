import 'dart:math';
import 'package:flutter/rendering.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeletons/skeletons.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe/componets/RemoveButton.dart';
import 'package:recipe/constant.dart';
import 'package:recipe/states/states.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool OnceMadeed = false;
  //gemini api starting here

  final Gemini gemini = Gemini.instance;

  bool isloading = false;

  late final ChatSession _chatSession;
  String _generatedRecipe = "";
  late final GenerativeModel _generativeModel;
  List<String> _ingredients = [];
  TextEditingController _ingriderntController = TextEditingController();
  // Add a boolean flag to track loading state
  bool _isLoading = false;

  bool _showGenerateAnotherButton = false;

  @override
  void initState() {
    super.initState();
    _generativeModel =
        GenerativeModel(model: "gemini-pro", apiKey: GeminiApiKey);
    _chatSession = _generativeModel.startChat();
  }

  Color _LightRandmomsColoring() {
    Random random = Random();
    int red = 125 + random.nextInt(128);
    int blue = 125 + random.nextInt(120);
    int green = 125 + random.nextInt(120);
    return Color.fromRGBO(red, green, blue, 0.9);
  }

  Color _LightRandomColor() {
    Random random = Random();
    int red = 128 + random.nextInt(128); // Range from 128 to 255
    int green = 128 + random.nextInt(128); // Range from 128 to 255
    int blue = 128 + random.nextInt(128); // Range from 128 to 255
    return Color.fromRGBO(red, green, blue, 1);
  }

  void _handleAdditems() {
    if (_ingriderntController.text.isNotEmpty) {
      setState(() {
        _ingredients.add(_ingriderntController.text);
        _ingriderntController.clear();
      });
    }
    print(_ingredients);
  }

  void _emptyList() {
    setState(() {
      _ingredients.clear();
    });
  }

  void _generateAnotherRecipe() {
    setState(() {
      _generatedRecipe = ""; // Clear the generated recipe
      _ingredients.clear(); // Clear the ingredients list
      _ingriderntController.clear(); // Clear the ingredient input field
      _showGenerateAnotherButton =
          false; // Hide the "Generate Another Recipe" button
    });
  }

// Update the loading state before and after the API call
  void _sendRecipiesToGemini(String sendingRequest) async {
    setState(() {
      _isLoading = true;
      _showGenerateAnotherButton = false; // Reset the button visibility
    });

    String ingredientsRequest = _ingredients.join(", ");
    try {
      await gemini
          .streamGenerateContent(
              "Generate a recipe using these ingredients: $ingredientsRequest")
          .listen((response) {
        setState(() {
          print(response);
          _generatedRecipe =
              response.toString(); // Adjust this based on actual property
          _isLoading = false;
          _showGenerateAnotherButton =
              true; // Show the "Generate Another Recipe" button
        });
      }, onError: (error) {
        setState(() {
          _isLoading = false;
        });
        print('Error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to generate recipe. Please try again.'),
          ),
        );
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
    }
  }

  Widget _buildChips() {
    List<Widget> chips = [];

    // Add 'Remove All' chip at the start if there are ingredients
    if (_ingredients.isNotEmpty) {
      chips.add(ActionChip(
        label: const Text('Remove All'),
        onPressed: _emptyList,
        backgroundColor: Colors.redAccent,
      ));
    }

    for (int i = 0; i < _ingredients.length; i++) {
      final ingredient = _ingredients[i];
      chips.add(Chip(
        label: Text(ingredient, style: TextStyle(color: Colors.black)),
        backgroundColor: _LightRandomColor(),
        deleteIcon: const Icon(Icons.close),
        onDeleted: () => setState(() => _ingredients.removeAt(i)),
      ));

      // Optionally, continue to add 'Remove All' chip after every seventh chip
      if ((i + 1) % 7 == 0) {
        chips.add(ActionChip(
          label: const Text('Remove All'),
          onPressed: _emptyList,
          backgroundColor: Colors.redAccent,
        ));
      }
    }

    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: chips,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              Consumer(
                builder: (context, ref, child) {
                  final txt = ref.watch(NameProvider);
                  return Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.0),
                        child: Text(
                          txt,
                          style: const TextStyle(
                              fontSize: 28.0, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        autocorrect: true,
                        autofocus: true,
                        controller: _ingriderntController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: "Enter ingredient's",
                          border: OutlineInputBorder(),
                          filled: true,
                          labelText: "Enter Ingredient's",
                          alignLabelWithHint: true,
                          focusColor: Colors.white,
                        ),
                        onSubmitted: (val) {
                          _handleAdditems();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: InkWell(
                        focusColor: Colors.blue.shade900,
                        onTap: _handleAdditems,
                        child: Container(
                            height: 67,
                            width: 60,
                            decoration: BoxDecoration(
                                color: Colors.blue.shade800,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.add)),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Container(
                height: 50, // Max height before becoming scrollable
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(19)),
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 17.0, right: 10.0),
                      child: _buildChips(),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              // if(_generatedRecipe.isNotEmpty)
              Skeleton(
                duration: const Duration(seconds: 3),
                skeleton: SkeletonParagraph(
                  style: SkeletonParagraphStyle(
                    lines: 25,
                    spacing: 9,
                    lineStyle: SkeletonLineStyle(
                      borderRadius: BorderRadius.circular(12),
                      height: 12,
                      randomLength: true,
                      padding: const EdgeInsets.only(left: 15.0,top: 3.0),
                      alignment: Alignment.center,
                      minLength: 10,
                      maxLength: 15
                    )
                  ),
                ),
    
                isLoading: _isLoading,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 5),
                  child: _generatedRecipe == null || _generatedRecipe.isEmpty
                      ? const SizedBox
                          .shrink() // If there's no recipe, don't show anything
                      : Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Recipe',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                Text(
                                  _generatedRecipe,
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              )

              // if (_generatedRecipe.isNotEmpty)
              //   Padding(
              //     padding: const EdgeInsets.only(left: 16, right: 16, top: 5),
              //     child: Card(
              //       child: Padding(
              //         padding: const EdgeInsets.all(16.0),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             const Text(
              //               'Recipe',
              //               style: TextStyle(
              //                 fontSize: 24.0,
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //             const SizedBox(height: 16.0),
              //             Text(
              //               _generatedRecipe,
              //               style: const TextStyle(fontSize: 16.0),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // if (_isLoading)

              //   // Shimmer.fromColors(
              //   //   baseColor: Colors.grey.shade100,
              //   //   highlightColor: Colors.grey.shade300,
              //   //   child: Container(
              //   //     height: 800,
              //   //     decoration: BoxDecoration(
              //   //       color: Colors.white,
              //   //       borderRadius: BorderRadius.circular(16),
              //   //     ),
              //   //   ),
              //   // ),
            ],
          ),
        ),
        floatingActionButton: _showGenerateAnotherButton
            ? GestureDetector(
                onTap: _generateAnotherRecipe,
                child: Container(
                  margin: const EdgeInsets.only(
                      bottom: 20, right: 22.0), // Adjust spacing from bottom
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 60, // Reduced height for aesthetic purposes
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30), // Circular borders
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black45,
                        offset: Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.auto_awesome),
                      SizedBox(
                        width: 25.0,
                      ),
                      Text(
                        'Generate Another Recipe',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
              )
            : GestureDetector(
                onTap: () {
                  String sendingRequest = "I Have These ingredients " +
                      _ingredients.join(',') +
                      " i want a good recipe from these items";
                  _sendRecipiesToGemini(sendingRequest);
                },
                child: Container(
                  margin: const EdgeInsets.only(
                      bottom: 20, right: 22.0), // Adjust spacing from bottom
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 60, // Reduced height for aesthetic purposes
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30), // Circular borders
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black45,
                        offset: Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.auto_awesome),
                      SizedBox(
                        width: 25.0,
                      ),
                      Text(
                        'Generate Recipe',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
