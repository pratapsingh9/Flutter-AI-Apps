import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/states/states.dart';

class title extends ConsumerWidget {
  const title({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txt = ref.watch(NameProvider);
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Text(
            txt,
            style: const TextStyle(fontSize: 28.0, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
