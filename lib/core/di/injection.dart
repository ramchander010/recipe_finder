import 'package:get_it/get_it.dart';
import 'package:recipe_app/data/services/recipe_service.bloc.dart';
import 'package:recipe_app/data/speech/bloc/speech.bloc.dart';
import 'package:recipe_app/data/speech/service/speech_service.dart';
import 'package:recipe_app/data/viewmodels/auth_bloc.dart/auth.bloc.dart';
import 'package:recipe_app/data/viewmodels/recipe_bloc.dart/recipe.bloc.dart';
import 'package:recipe_app/data/viewmodels/shopping_bloc.dart/shopping.bloc.dart';

final sl = GetIt.instance;

void init() {
  sl.registerLazySingleton<RecipeService>(() => RecipeService());
  sl.registerLazySingleton<SpeechService>(() => SpeechService());

  sl.registerFactory<RecipeBloc>(() => RecipeBloc(sl()));
  sl.registerFactory<AuthBloc>(() => AuthBloc());
  sl.registerFactory<ShoppingBloc>(() => ShoppingBloc());

  sl.registerFactory<SpeechBloc>(() => SpeechBloc(sl()));
}
