// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/data/viewmodels/auth_bloc.dart/auth.bloc.dart';
import 'package:recipe_app/data/viewmodels/auth_bloc.dart/auth_state.bloc.dart';
import 'package:recipe_app/views/category/category_screen.dart';
import 'package:recipe_app/views/settings/settings_screen.dart';
import 'package:recipe_app/views/shoping/shoping_screen.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_text_style_.dart';
import '../home/home_screen.dart';
import '../favorites/favorites_screen.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CategoryScreen(),
    const FavoritesScreen(),
    const ShopingScreen(showAppBar: false,),
  ];

  final List<Map<String, dynamic>> _items = [
    {"icon": Icons.home_rounded, "label": "Home"},
    {"icon": Icons.grid_view_rounded, "label": "Categories"},
    {"icon": Icons.favorite_rounded, "label": "Favorites"},
    {"icon": Icons.shopping_cart_rounded, "label": "Shopping List"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(_currentIndex),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: _screens[_currentIndex],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader(int currentIndex) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final userName = state.userName ?? "Guest";
          final firstLetter = userName.isNotEmpty
              ? userName[0].toUpperCase()
              : "G";

          final hour = DateTime.now().hour;
          final greeting = hour < 12
              ? "Good morning"
              : hour < 17
              ? "Good afternoon"
              : "Good evening";

          return Row(
            children: [
              if (currentIndex == 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$greeting,',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      userName,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              else
                Text(
                  _items[currentIndex]["label"],
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

              const Spacer(),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
                child: Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary,
                        colorScheme.primary.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      firstLetter,
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (index) {
          final isSelected = _currentIndex == index;

          return GestureDetector(
            onTap: () => setState(() => _currentIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.15),
                          AppColors.primary.withOpacity(0.05),
                        ],
                      )
                    : null,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  Icon(
                    _items[index]["icon"],
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary.withOpacity(.8),
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 8),
                    Text(
                      _items[index]["label"],
                      style: AppTextStyles.w600.copyWith(
                        color: AppColors.primary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
