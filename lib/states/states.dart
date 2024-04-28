import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';

final NameProvider = Provider<String>((ref) => "Find the Best Recipes for Cooking !");
final LengthProvider = StateProvider<int>((ref) => 190);

// Create a new provider to manage the app theme state
final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);


final SpeechProvider = StateNotifierProvider<SpeechControler,bool>((ref) => SpeechControler());


class SpeechControler extends StateNotifier<bool> {
  SpeechControler():super(false);
  final SpeechToText _speechToText = SpeechToText();
  void ToogleListending() async{
    if (_speechToText.isNotListening) {
      bool avalible = await _speechToText.initialize(
        onError: (error) => print("Error :$error"),
        onStatus: (status) => print("Status :$status")
      );
      if (avalible) {
        _speechToText.listen(onResult: (val) => print("$val"));
        state = true;
      }
    } else{
      _speechToText.stop();
      state = false;
    }
  }
}