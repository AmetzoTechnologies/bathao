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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1F264A),
            Color(0xff32659e),
            Color(0xFF1F2C5A),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF000D64),
          centerTitle: true,
          title: Text(
            "Purchase History",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.transparent, // Changed to transparent
        body: RefreshIndicator(
          onRefresh: controller.refreshPurchaseHistory,
            // Customize spinner color


          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                    () => controller.history.isEmpty
                    ? ListView( // Wrap in ListView for pull-to-refresh to work
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(
                        child: Text(
                          "No purchase history found",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                    : ListView.builder(
                  controller: controller.scrollController,
                  physics: AlwaysScrollableScrollPhysics(), // Important for refresh
                  itemCount: controller.history.length + 1, // +1 for loading indicator
                  itemBuilder: (context, index) {
                    if (index < controller.history.length) {
                      final item = controller.history[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 6.0,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
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
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "₹${item.transaction?.amount ?? 0}",
                                    style: TextStyle(
                                      color: Colors.greenAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('dd MMM yyyy, hh:mm a')
                                        .format(
                                      item.createdAt!.toLocal(),
                                    ),
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
                      // Loading indicator for pagination
                      return controller.isLastPage
                          ? SizedBox.shrink()
                          : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF000D64),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}