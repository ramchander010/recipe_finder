// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:recipe_app/core/theme/app_text_style_.dart';
import 'package:recipe_app/core/theme/app_theme.dart';

class InfoScreen extends StatelessWidget {
  final String title;

  const InfoScreen({super.key, required this.title});

  String getContent() {
    switch (title) {
      case "About Us":
        return """
Welcome to our Recipe App 🍲

This application is designed to make cooking simple, enjoyable, and personalized. Users can explore a wide range of recipes, search based on preferences, and save their favorite dishes for quick access.

Our platform allows you to:

• Browse and search from a curated list of recipes
• Add recipes to your favorites for easy access
• Create personalized shopping lists
• Generate shopping lists directly from recipes
• Edit and manage your shopping items anytime

We focus on delivering a smooth and intuitive experience so you can spend less time planning and more time cooking.

""";

      case "Terms & Conditions":
        return """
Terms & Conditions

By using this application, you agree to use it responsibly and for personal purposes only.

• The app provides recipe content for informational purposes only.
• Users are responsible for how they use recipes and ingredients.
• We do not guarantee accuracy of all recipe details.
• The app may be updated or modified at any time.

Continued use of the app indicates acceptance of these terms.

""";

      case "Privacy Policy":
        return """
Privacy Policy 🔒

Your privacy is important to us.

• We do NOT store or share your personal data.
• Your data remains on your device and is fully under your control.
• We do not access your personal preferences, favorites, or shopping lists.

The app is designed to respect user privacy while providing a personalized experience.

""";

      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title, style: AppTextStyles.h2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    getContent(),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textMain,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    "Made with love for food lovers",
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Version 1.0.0",
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
