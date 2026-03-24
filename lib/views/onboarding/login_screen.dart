// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/data/viewmodels/auth_bloc.dart/auth.bloc.dart';
import 'package:recipe_app/data/viewmodels/auth_bloc.dart/auth_event.bloc.dart';
import 'package:recipe_app/data/viewmodels/auth_bloc.dart/auth_state.bloc.dart';
import 'package:recipe_app/widgets/my_buttom.dart';
import '../../core/theme/app_theme.dart';
import '../dashboard/dashboard_view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

enum UnitType { metric, imperial }

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  UnitType _selectedUnit = UnitType.metric;

  String _formatName(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final name = _formatName(_nameController.text.trim());

      context.read<AuthBloc>().add(
        SaveUser(name: name, unit: _selectedUnit.name),
      );
    }
  }

  Widget _unitCard({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.08)
              : AppColors.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.textSecondary.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DashboardView()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.restaurant_menu,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),

                  const SizedBox(height: 40),

                  Text(
                    "Hey 👋",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 20),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "What should we call you?",
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 28,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 30),

                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    maxLength: 30,
                    buildCounter:
                        (
                          context, {
                          required currentLength,
                          required isFocused,
                          required maxLength,
                        }) => null,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(fontSize: 18),
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) return "Name is required";
                      if (text.length < 3) {
                        return "Minimum 3 characters required";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      final formatted = _formatName(value.trim());
                      if (value != formatted) {
                        _nameController.value = TextEditingValue(
                          text: formatted,
                          selection: TextSelection.collapsed(
                            offset: formatted.length,
                          ),
                        );
                      }
                    },
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    decoration: InputDecoration(
                      hintText: "Enter your name",
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.textSecondary.withOpacity(0.3),
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Row(
                  //   children: [
                  //     Text(
                  //       "Preferred Units",
                  //       style: Theme.of(context).textTheme.titleMedium,
                  //     ),
                  //     const SizedBox(width: 6),
                  //     Tooltip(
                  //       message:
                  //           "You can change this anytime later in settings",
                  //       textStyle: Theme.of(
                  //         context,
                  //       ).textTheme.bodySmall?.copyWith(color: Colors.white),
                  //       decoration: BoxDecoration(
                  //         color: AppColors.black,
                  //         borderRadius: BorderRadius.circular(6),
                  //       ),
                  //       child: const Icon(
                  //         Icons.info_outline,
                  //         size: 18,
                  //         color: AppColors.textSecondary,
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  // const SizedBox(height: 16),

                  // _unitCard(
                  //   title: "Metric",
                  //   subtitle: "grams, ml, °C",
                  //   isSelected: _selectedUnit == UnitType.metric,
                  //   onTap: () =>
                  //       setState(() => _selectedUnit = UnitType.metric),
                  // ),

                  // const SizedBox(height: 12),

                  // _unitCard(
                  //   title: "Imperial",
                  //   subtitle: "ounces, cups, °F",
                  //   isSelected: _selectedUnit == UnitType.imperial,
                  //   onTap: () =>
                  //       setState(() => _selectedUnit = UnitType.imperial),
                  // ),
                  const Spacer(),

                  MyCustomButton(myText: "Continue", onTap: _submit),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
