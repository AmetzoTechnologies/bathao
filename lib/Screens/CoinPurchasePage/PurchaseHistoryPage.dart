 import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Controllers/PaymentController/PaymentController.dart';
import '../../Theme/Colors.dart';

class PurchaseHistoryPage extends StatelessWidget {
  PurchaseHistoryPage({super.key});
  final PaymentController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                "Purchase History",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Obx(
                  () =>
                      controller.history.isEmpty
                          ? Center(child: Text("No purchase history found"))
                          : ListView.builder(
                            controller: controller.scrollController,
                            itemCount: controller.history.length,
                            itemBuilder: (context, index) {
                              if (index < controller.history.length) {
                                final item = controller.history[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF1A1A1A),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.monetization_on,
                                              color: Colors.amber,
                                              size: 24,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              "${item.amountOfCoins} Coins",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "${item.transaction?.amount ?? 0}",
                                              style: TextStyle(
                                                color: Colors.greenAccent,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              DateFormat(
                                                'dd MMM yyyy, hh:mm a',
                                              ).format(
                                                item.createdAt!.toLocal(),
                                              ), // Format as needed
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return controller.isLastPage
                                    ? SizedBox.shrink()
                                    : Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                              }
                            },
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
