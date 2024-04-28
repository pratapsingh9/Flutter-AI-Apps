import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe/componets/geminappcomponents/CustomDrawer.dart';
import 'package:recipe/states/states.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter/material.dart';
import 'package:recipe/componets/geminappcomponents/Micbutton.dart';
import 'package:recipe/componets/textFl.dart';
import 'package:recipe/utils/Colors.dart';
import 'package:skeletons/skeletons.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  // ignore: non_constant_identifier_names
  FocusNode IngredientFoucsNodes = FocusNode();
  final Gemini gemini = Gemini.instance;
  bool isloading = false;

  late AnimationController _animationController;
  String _generatedRecipe = "";
  List<String> _ingredients = [];
  final TextEditingController _ingriderntController = TextEditingController();
  // Add a boolean flag to track loading state
  bool _isLoading = false;
    final GlobalKey<ScaffoldState> Scaffold_key = GlobalKey<ScaffoldState>();

  bool _isSpeechRecognitionActive = false;
  final SpeechToText _speechToText = SpeechToText();
  late Animation<double> _opactiyAnimation;
  //checking if the list is empty or n

  bool _showGenerateAnotherButton = false;

  //disposing of the item
  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _opactiyAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _speechToText.initialize(onError: (error) {}, onStatus: (status) {});
  }

  void _handleSpeechRecognitionResult(String recognizedText) {
    setState(() {
      _ingredients.add(recognizedText);
      _ingriderntController.clear();
    });
  }

  void startListening() async {
    bool available = await _speechToText.initialize();
    if (available) {
      await _speechToText.listen(
        onResult: (result) {
          _handleSpeechRecognitionResult(result.recognizedWords);
        },
      );
    }
  }
  // ignore: non_constant_identifier_names

  void _showSpeechDialog() async {
    bool available = await _speechToText.initialize();

    if (available) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Speech Recognition'),
            content: const Text('Tap the button to start speaking.'),
            actions: [
              GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    _isSpeechRecognitionActive = true;
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    _isSpeechRecognitionActive = false;
                  });
                },
                onTap: () async {
                  if (_isSpeechRecognitionActive) {
                    await startListening;
                  }
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade400,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(Icons.mic, color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    } else {
      // Handle speech recognition not available
    }
  }

  void _handleAdditems([String? ingredient]) {
    if (ingredient != null && ingredient.isNotEmpty) {
      setState(() {
        _ingredients.add(ingredient);
        _ingriderntController.clear();
      });
    } else if (_ingriderntController.text.isNotEmpty) {
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
      _showGenerateAnotherButton = false;
      _generatedRecipe = ''; // Clear the previous recipe
    });

    try {
      final responseStream = await gemini.text(
          "Generate a recipe using these ingredients: $sendingRequest");
      print(responseStream);
      final completeResponse = responseStream as String;

      setState(() {
        _generatedRecipe = completeResponse;
        _isLoading = false;
        _showGenerateAnotherButton = true;
      });
      print(_generatedRecipe);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
      // Show a SnackBar with animation
      _animationController.forward(from: 0.0).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to generate recipe. Please try again.'),
            duration: Duration(seconds: 3),
          ),
        );
        _animationController.reset();
      });
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
        label: Text(ingredient, style: const TextStyle(color: Colors.black)),
        backgroundColor: CustomColors.LightRandomColor(),
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
        key: Scaffold_key,
        appBar: AppBar(
          // backgroundColor: Colors.lightBlue.shade200,
          title: Text("Cookings App", style: GoogleFonts.aBeeZee()),
          leading: IconButton(onPressed: () {
            Scaffold_key.currentState?.openDrawer();
          }, icon:  Icon(Icons.menu)),
          centerTitle: true,
          actions: [
            Consumer(
              builder: ((context, ref, child) {
                final thememode = ref.watch(themeProvider);
                return IconButton(
                    onPressed: () {
                      ref.watch(themeProvider.notifier).state =
                          thememode == ThemeMode.dark
                              ? ThemeMode.light
                              : ThemeMode.dark;
                    },
                    icon: thememode == ThemeMode.light
                        ? const Icon(Icons.dark_mode)
                        : const Icon(Icons.light_mode));
              }),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Row(
                  children: [
                    TxtFiled(
                        IngredientFoucsNodes: IngredientFoucsNodes,
                        ingriderntController: _ingriderntController),
                    MicButton(Add_ingridents_items: _handleAdditems),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Skeleton(
                  duration: const Duration(seconds: 3),
                  skeleton: SkeletonParagraph(
                    style: SkeletonParagraphStyle(
                        lines: 25,
                        spacing: 9,
                        lineStyle: SkeletonLineStyle(
                            borderRadius: BorderRadius.circular(4),
                            height: 12,
                            randomLength: true,
                            minLength: 90,
                            maxLength: 420)),
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
                ),
              )
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _showGenerateAnotherButton
            ? GestureDetector(
                onTap: () {
                  if (_ingredients.isNotEmpty) {
                    _generateAnotherRecipe();
                  } else {
                    AlertDialog(
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
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("OK"))
                      ],
                    );
                  }
                },
                child: Container(
                  // Adjust spacing from bottom
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 60, // Reduced height for aesthetic purposes
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _ingredients.isEmpty
                        ? Colors.grey.shade400
                        : Colors.blue.shade300,
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
                  if (_ingredients.isNotEmpty) {
                    String sendingRequest =
                        "I Have These ingredients ${_ingredients.join(',')} i want a good recipe from these items";
                    _sendRecipiesToGemini(sendingRequest);
                    if (kDebugMode) {
                      print(_generatedRecipe);
                    }
                  } else {
                    AlertDialog(
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
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("OK"))
                      ],
                    );
                  }
                },
                child: Container(
                  // right: MediaQuery.of(context).size.width * 0.1,),.
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 60, // Reduced height for aesthetic purposes
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _ingredients.isEmpty
                        ? Colors.grey.shade400
                        : Colors.blue,
                    borderRadius: BorderRadius.circular(30), // Circular borders
                    boxShadow: const [],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 25.0,
                      ),
                      Text(
                        'Generate Recipe',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
          drawer: const CustomDrawer(),
      ),
    );
  }
}
