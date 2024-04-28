import 'package:flutter/material.dart';



class CodeGenerator extends StatefulWidget {
  const CodeGenerator({super.key});

  @override
  State<CodeGenerator> createState() => _CodeGeneratorState();
}

class _CodeGeneratorState extends State<CodeGenerator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generative Ai"),
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(onPressed: (){}, icon: const Icon(Icons.menu)),  
      ),
    );
  }
}