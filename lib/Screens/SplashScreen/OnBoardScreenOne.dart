import 'package:flutter/material.dart';

import '../../Theme/Colors.dart';

class OnBoardPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final int currentPage;
  final VoidCallback onTap;

  const OnBoardPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.currentPage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.height < 700;
    final isTablet = size.width > 600;

    return Scaffold(
      body: Stack(
        children: [

          /// Background gradient (Login screen)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF13228B), // Deep blue
                    Color(0xFF501861), // Blue-violet
                    Color(0xFFA6047D), // Wine purple
                  ],
                  stops: [0.0, 0.60, 1.0],
                ),
              ),
            ),
          ),

          /// Hero Image with soft light blend
          Positioned.fill(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              color: Colors.white.withOpacity(0.06),
              colorBlendMode: BlendMode.softLight,
            ),
          ),

          /// Dark bottom fade (depth for text container)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.15),
                    Colors.black.withOpacity(0.55),
                  ],
                  stops: const [0.50, 0.78, 1.0],
                ),
              ),
            ),
          ),

          /// Glass bottom content container
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).padding.bottom,
            child: SafeArea(
              top: false,
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  size.width * 0.07,
                  size.height * 0.03,
                  size.width * 0.07,
                  size.height * 0.02, // FIXED bottom padding
                ),
                decoration:BoxDecoration(
                  color: Colors.black.withOpacity(0.25),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(isTablet ? 45 : 35),
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.12),
                    width: 1.1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    _indicators(size),

                    SizedBox(height: size.height * 0.025),

                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: _font(size, isSmall, isTablet, 28),
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),

                    SizedBox(height: size.height * 0.02),

                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.02),
                      child: Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: _font(size, isSmall, isTablet, 15),
                          color: Colors.white.withOpacity(0.9),
                          height: 1.6,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(height: size.height * 0.035),

                    _buildMinimalButton(size, isSmall, isTablet),

                    SizedBox(height: size.height * 0.02),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Indicators
  Widget _indicators(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final active = currentPage == i;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.012),
          width: active ? 45 : 28,
          height: 4,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }

  /// Custom button
  Widget _buildMinimalButton(Size size, bool small, bool tablet) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05,
          vertical: size.height * 0.018,
        ),
        decoration: BoxDecoration(
          color: AppColors.getStartBackground,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            Text(
              "Get Started",
              style: TextStyle(
                color: Colors.white,
                fontSize: _font(size, small, tablet, 18),
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(width: size.width * 0.03),

            /// Fading trail arrows
            Icon(Icons.arrow_forward_ios,
                size: _font(size, small, tablet, 16),
                color: Colors.white),
            Icon(Icons.arrow_forward_ios,
                size: _font(size, small, tablet, 16),
                color: Colors.white.withOpacity(0.8)),
            Icon(Icons.arrow_forward_ios,
                size: _font(size, small, tablet, 16),
                color: Colors.white.withOpacity(0.6)),
            Icon(Icons.arrow_forward_ios,
                size: _font(size, small, tablet, 16),
                color: Colors.white.withOpacity(0.4)),

            SizedBox(width: size.width * 0.03),

            /// Circular gradient action
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors:AppColors.buttonGradient,
                  begin: Alignment.topLeft,

                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 3,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: _font(size, small, tablet, 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Font scaling
  double _font(Size size, bool small, bool tab, double base) {
    if (tab) return base * 1.25;
    if (small) return base * 0.9;
    return base;
  }
}
