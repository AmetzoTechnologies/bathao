import 'package:bathao/Theme/Colors.dart';
import 'package:flutter/material.dart';

class OnBoardPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final bool isFirst;
  final int currentPage;
  final VoidCallback onTap;

  const OnBoardPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.currentPage,
    this.isFirst = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    // Perfect responsive hero image sizing
    final desiredHeight = h * 0.70;
    // Clamp logic = premium feel on Pixel + safe on all screens
    final imageHeight = desiredHeight.clamp(420.0, 690.0);

    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.onBoardColors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: h * 0.06),

              SizedBox(
                height: imageHeight,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),

              const Spacer(),
            ],
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.onBoardPrimary,
                    AppColors.onBoardSecondary,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _indicator(currentPage == 0),
                      const SizedBox(width: 6),
                      _indicator(currentPage == 1),
                      const SizedBox(width: 6),
                      _indicator(currentPage == 2),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 25),

                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.getStartBackground,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Get Started",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(Icons.arrow_forward_ios,
                              color: AppColors.textColor),
                          Icon(Icons.arrow_forward_ios,
                              color: AppColors.textColor.withOpacity(0.8)),
                          Icon(Icons.arrow_forward_ios,
                              color: AppColors.textColor.withOpacity(0.6)),
                          const SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: AppColors.buttonGradient,
                                begin: Alignment.topLeft,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.textColor.withValues(
                                    alpha: 0.30,
                                  ),
                                  blurRadius: 10,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(Icons.arrow_forward_ios,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _indicator(bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: active ? 50 : 28,
      height: active ? 6 : 4,
      decoration: BoxDecoration(
        color: active ? Colors.white : Colors.white54,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
