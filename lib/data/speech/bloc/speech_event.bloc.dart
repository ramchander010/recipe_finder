abstract class SpeechEvent {}

class InitSpeech extends SpeechEvent {}

class StartListening extends SpeechEvent {}

class StopListening extends SpeechEvent {}

class SpeechResultEvent extends SpeechEvent {
  final String text;
  SpeechResultEvent(this.text);
}

class SpeechErrorEvent extends SpeechEvent {
  final String message;
  SpeechErrorEvent(this.message);
}
class ClearSpeech extends SpeechEvent {}