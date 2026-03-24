class SpeechState {
  final bool isListening;
  final bool isEnabled;
  final String text;
  final String? error;

  const SpeechState({
    this.isListening = false,
    this.isEnabled = false,
    this.text = '',
    this.error,
  });

  SpeechState copyWith({
    bool? isListening,
    bool? isEnabled,
    String? text,
    String? error,
  }) {
    return SpeechState(
      isListening: isListening ?? this.isListening,
      isEnabled: isEnabled ?? this.isEnabled,
      text: text ?? this.text,
      error: error,
    );
  }
}