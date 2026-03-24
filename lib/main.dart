import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/data/speech/bloc/speech.bloc.dart';
import 'package:recipe_app/data/viewmodels/auth_bloc.dart/auth.bloc.dart';
import 'package:recipe_app/data/viewmodels/auth_bloc.dart/auth_event.bloc.dart';
import 'package:recipe_app/data/viewmodels/recipe_bloc.dart/recipe.bloc.dart';
import 'package:recipe_app/data/viewmodels/recipe_bloc.dart/recipe_event.bloc.dart';
import 'package:recipe_app/data/viewmodels/shopping_bloc.dart/shopping.bloc.dart';
import 'package:recipe_app/views/onboarding/splash_screen.dart';
import 'core/theme/app_theme.dart';
import 'core/di/injection.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()..add(CheckUser())),
        BlocProvider(create: (_) => di.sl<RecipeBloc>()..add(LoadRecipes())),
        BlocProvider(create: (_) => di.sl<ShoppingBloc>()),
        BlocProvider(create: (_) => di.sl<SpeechBloc>()),
      ],
      child: MaterialApp(
        title: 'Recipe App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
