import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/data/speech/bloc/speech_event.bloc.dart';
import 'package:recipe_app/data/speech/bloc/speech_state.bloc.dart';
import '../service/speech_service.dart';

class SpeechBloc extends Bloc<SpeechEvent, SpeechState> {
  final SpeechService service;

  SpeechBloc(this.service) : super(const SpeechState()) {
    on<InitSpeech>(_onInit);
    on<StartListening>(_onStart);
    on<StopListening>(_onStop);
    on<SpeechResultEvent>(_onResult);
    on<SpeechErrorEvent>(_onError);
    on<ClearSpeech>((event, emit) {
      emit(state.copyWith(text: ''));
    });
  }

  Future<void> _onInit(InitSpeech event, Emitter<SpeechState> emit) async {
    final enabled = await service.init(
      onDone: () => add(StopListening()),
      onError: (msg) => add(SpeechErrorEvent(msg)),
    );

    emit(state.copyWith(isEnabled: enabled));
  }

  Future<void> _onStart(StartListening event, Emitter<SpeechState> emit) async {
    if (!state.isEnabled) {
      add(InitSpeech());
      return;
    }

    emit(state.copyWith(isListening: true));

    await service.listen(
      onResult: (text) {
        add(SpeechResultEvent(text));
      },
    );
  }

  Future<void> _onStop(StopListening event, Emitter<SpeechState> emit) async {
    await service.stop();
    emit(state.copyWith(isListening: false));
  }

  void _onResult(SpeechResultEvent event, Emitter<SpeechState> emit) {
    emit(state.copyWith(text: event.text));
  }

  void _onError(SpeechErrorEvent event, Emitter<SpeechState> emit) {
    emit(state.copyWith(error: event.message));
  }
}
