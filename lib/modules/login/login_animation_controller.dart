import 'package:rive/rive.dart';

StateMachineController? riveController;
SMIInput<bool>? isTyping;
SMIInput<bool>? isHandsUp;
SMIInput<dynamic>? success;
SMIInput<dynamic>? fail;

final List<String> characterNames = [
  'Tigo the Tiger',
  'Hooty',
  'Bubbles',
  'Hoppy',
  'Donny Roll',
  'Chirpy',
  'BooBean',
  'Snuggles',
  'Pandy',
];

bool hasShownCompletionDialog = false;
bool showTreasureHint = false;
bool treasureOpened=false;

