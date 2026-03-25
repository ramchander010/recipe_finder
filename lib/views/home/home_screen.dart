// ignore_for_file: strict_top_level_inference, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:recipe_app/views/home/widgets/home_recipe_listing_view.dart';
import 'package:recipe_app/views/home/widgets/my_search_widget.dart';
import 'package:recipe_app/views/search/search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedSearchBar(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchScreen()),
                  );
                },
              ),
              homeRecipeListingView(),
              buildHomeHeader(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHomeHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 100),
          Text(
            "Crafted in India\nwith love ❤️",
            style: TextStyle(
              fontSize: 38,
              color: const Color.fromARGB(255, 155, 151, 151),
            ),
          ),
        ],
      ),
    );
  }
}
