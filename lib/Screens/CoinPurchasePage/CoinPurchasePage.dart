
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../Controllers/AuthController/AuthController.dart';
import '../../Controllers/PaymentController/PaymentController.dart';
import '../../Models/plan_model/plan.dart';
import '../../Theme/Colors.dart';
import 'PurchaseHistoryPage.dart';

class CoinPurchasePage extends StatelessWidget {
  CoinPurchasePage({super.key});

  final PaymentController controller = Get.put(PaymentController());

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.textColor),
        title: Text("Wallet", style: TextStyle(color: AppColors.textColor)),
        backgroundColor: const Color(0xFF000D64),

        centerTitle: true,
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: controller.refreshCoinPlans,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Top Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(
                  children: [
                  // Available Coins Card
                  Expanded(
                  child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF000000),
                        Color(0xFF0a192f),
                        Color(0xFF112240),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.greenAccent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Available Coins",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                           // 👈 reduces top/bottom text spacing
                        ),
                      ),
                      Text(
                        "${totalCoin.value}",
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
   height: 1.0
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Purchase History Button
              InkWell(
                onTap: () {
                  Get.to(PurchaseHistoryPage());
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(

                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF000000),
                        Color(0xFF0a192f),
                        Color(0xFF112240),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.greenAccent,
                      width: 1.3,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.history,
                        color: Colors.white,
                        size: 24,

                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "History",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.0
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

                      const SizedBox(height: 20),

                      Text(
                        "Coin Packages",
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),

              // Grid View
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 13,
                    mainAxisSpacing: 24,
                    childAspectRatio: 1.2,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return _buildCoinPlanCard(controller.coinPlan[index]);
                  }, childCount: controller.coinPlan.length),
                ),
              ),

              // Purchase History Button
            ],
          ),
        );
      }),
    );
  }

  /// Card UI
  Widget _buildCoinPlanCard(Plan pkg) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      onTap: () async {
        String package = pkg.id!;

        if (userModel!.user!.email == null) {
          Get.dialog(
            AlertDialog(
              backgroundColor: AppColors.onBoardSecondary,
              title: const Text('Enter your Email'),
              content: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'example@mail.com',
                  border: OutlineInputBorder(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final email = emailController.text.trim();
                    if (email.isNotEmpty && GetUtils.isEmail(email)) {
                      Get.back();
                      await controller.createPayment(package, email);
                    } else {
                      Get.snackbar(
                        'Invalid Email',
                        'Please enter a valid email address',
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.onBoardPrimary,
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            barrierDismissible: false,
          );
        } else {
          await controller.createPayment(package, null);
        }
      },

      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF000000), Color(0xFF0a192f), Color(0xFF112240)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (pkg.description != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                margin: const EdgeInsets.only(bottom: 2),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  pkg.description!,
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            /// Coin Icon (SVG)
            SvgPicture.asset("assets/icons/coin.svg", height: 34),

            const SizedBox(height: 8),

            /// Coins Text
            Text(
              "${pkg.coins} Coins",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),

            const SizedBox(height: 4),

            /// Price
            Text(
              "₹${pkg.rate}",
              style: const TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

}

// SliverToBoxAdapter(
// child: Padding(
// padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
// child: GestureDetector(
// onTap: () {
// Get.to(PurchaseHistoryPage());
// },
// child: Container(
// width: double.infinity,
// padding: const EdgeInsets.all(16),
// decoration: BoxDecoration(
// gradient: const LinearGradient(
// colors: [
// Color(0xFF000000),
// Color(0xFF0a192f),
// Color(0xFF112240),
// ],
// begin: Alignment.topLeft,
// end: Alignment.bottomRight,
// ),
// borderRadius: BorderRadius.circular(14),
// ),
// child: Center(
// child: Text(
// "Purchase History",
// style: TextStyle(
// fontWeight: FontWeight.bold,
// fontSize: 16,
// ),
// ),
// ),
// ),
// ),
// ),
// )
