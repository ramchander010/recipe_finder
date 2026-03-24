// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();

  Future<bool> init({
    required VoidCallback onDone,
    required Function(String) onError,
  }) async {
    try {
      final result = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            onDone();
          }
        },
        onError: (error) {
          onError(error.errorMsg);
        },
      );

      return result;
    } catch (e) {
      onError(e.toString());
      return false;
    }
  }

  Future<bool> checkPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.microphone.request();
      return status.isGranted;
    }
    return true;
  }

  Future<void> listen({required Function(String) onResult}) async {
    if (!_speech.isAvailable || _speech.isListening) return;
    await _speech.listen(
      listenFor: const Duration(minutes: 5),
      pauseFor: const Duration(seconds: 10),
      partialResults: true,
      cancelOnError: true,
      onResult: (result) => onResult(result.recognizedWords),
    );
  }

  Future<void> stop() async {
    await _speech.stop();
  }
}
