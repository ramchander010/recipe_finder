// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/core/theme/app_image_provider.dart';
import 'package:recipe_app/core/theme/app_text_style_.dart';
import 'package:recipe_app/core/theme/app_theme.dart';
import 'package:recipe_app/data/viewmodels/auth_bloc.dart/auth.bloc.dart';
import 'package:recipe_app/data/viewmodels/auth_bloc.dart/auth_event.bloc.dart';
import 'package:recipe_app/data/viewmodels/auth_bloc.dart/auth_state.bloc.dart';
import 'package:recipe_app/views/settings/info_screen.dart';
import '../onboarding/login_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> openEmailSupport(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'kbs.xiaomi.mobile@gmail.com',
      query: Uri.encodeFull('subject=App Support&body=Hello Support Team,'),
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No email app found")));
    }
  }

  Future<void> rateApp() async {
    final Uri androidUrl = Uri.parse(
      "https://play.google.com/store/apps/details?id=com.yourapp.package",
    );

    final Uri iosUrl = Uri.parse("https://apps.apple.com/app/idYOUR_APP_ID");

    final Uri url = Platform.isIOS ? iosUrl : androidUrl;

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not launch store";
    }
  }

  Future<void> shareApp() async {
    final String androidLink =
        "https://play.google.com/store/apps/details?id=com.yourapp.package";

    final String iosLink = "https://apps.apple.com/app/idYOUR_APP_ID";

    final String link = Platform.isIOS ? iosLink : androidLink;

    await Share.share(
      "🍲 Check out this amazing Recipe App!\n\nDownload here:\n$link",
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final userName = state.userName ?? "Guest";
        final unit = state.unit ?? "metric";

        return Scaffold(
          backgroundColor: AppColors.background,

          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded),
            ),
            title: Text("Settings", style: AppTextStyles.h2),
            centerTitle: false,
          ),

          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          AppImageProvider.appLogo,
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello 👋",
                            style: AppTextStyles.w400.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            userName,
                            style: AppTextStyles.w700.copyWith(fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Text(
                    "Account",
                    style: AppTextStyles.w600.copyWith(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 10),

                  _cardWrapper(context, userName),
                  const SizedBox(height: 10),
                  _settingsSection("General", [
                    _tile(
                      title: "About App",
                      icon: Icons.info_outline,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const InfoScreen(title: "About Us"),
                          ),
                        );
                      },
                      context: context,
                    ),
                    _tile(
                      title: "Rate Us",
                      icon: Icons.star_border,
                      onTap: () {
                        rateApp();
                      },
                      context: context,
                    ),
                    _tile(
                      title: "Share App",
                      icon: Icons.share_outlined,
                      onTap: () {
                        shareApp();
                      },
                      context: context,
                    ),
                  ]),

                  const SizedBox(height: 20),

                  _settingsSection("Legal", [
                    _tile(
                      title: "Terms & Conditions",
                      icon: Icons.description_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const InfoScreen(title: "Terms & Conditions"),
                          ),
                        );
                      },
                      context: context,
                    ),
                    _tile(
                      title: "Privacy Policy",
                      icon: Icons.privacy_tip_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const InfoScreen(title: "Privacy Policy"),
                          ),
                        );
                      },
                      context: context,
                    ),
                  ]),

                  const SizedBox(height: 20),

                  _settingsSection("Support", [
                    _tile(
                      title: "Help & Support",
                      icon: Icons.help_outline,
                      onTap: () {
                        openEmailSupport(context);
                      },
                      context: context,
                    ),
                  ]),
                  SizedBox(height: 30),
                  Center(
                    child: Text(
                      "App Version 1.0.0",
                      style: AppTextStyles.w400.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  SizedBox(height: 80),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => _showLogoutDialog(context),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _settingsSection(String title, List<Widget> tiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.w600.copyWith(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: tiles),
        ),
      ],
    );
  }

  Widget _tile({
    required String title,
    IconData? icon,
    VoidCallback? onTap,
    dynamic context,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: AppTextStyles.w500),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      ),
    );
  }

  Widget _cardWrapper(dynamic context, String userName) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Text('Your Name', style: AppTextStyles.w600),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                userName,
                style: AppTextStyles.w500.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.edit, size: 18),
            ],
          ),
          onTap: () => _showEditNameDialog(context, userName),
        ),
      ),
    );
  }

  void _showEditNameDialog(BuildContext context, String currentName) {
    final controller = TextEditingController(text: currentName);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Edit Name",
                  style: AppTextStyles.w700.copyWith(fontSize: 18),
                ),

                const SizedBox(height: 16),

                Form(
                  key: formKey,
                  child: TextFormField(
                    controller: controller,
                    style: AppTextStyles.w500,
                    validator: (val) {
                      if (val == null || val.trim().length < 3) {
                        return "Min 3 characters required";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter your name",
                      hintStyle: AppTextStyles.w400.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.cardColor,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text("Cancel", style: AppTextStyles.w500),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            final newName = controller.text.trim();

                            context.read<AuthBloc>().add(
                              SaveUser(
                                name: newName,
                                unit:
                                    context.read<AuthBloc>().state.unit ??
                                    "metric",
                              ),
                            );

                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Center(
                            child: Text(
                              "Save",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text("Logout", style: AppTextStyles.w700),
          content: Text(
            "Are you sure you want to logout?",
            style: AppTextStyles.w500,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: AppTextStyles.w500),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(Logout());

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: Text(
                "Logout",
                style: AppTextStyles.w600.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        );
      },
    );
  }
}
