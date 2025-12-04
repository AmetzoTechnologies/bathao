import 'package:bathao/Controllers/ListenerController/ListenerController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'UserCardWidget.dart';

class ListenerListWidget extends StatelessWidget {
  const ListenerListWidget({super.key});

  // Age calculation moved OUTSIDE build for efficiency
  String getAgeOrNA(DateTime? birthDate) {
    if (birthDate == null) return 'N/A';

    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age.toString();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ListenerController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final cardSpacing = screenWidth * 0.01;

    return GetBuilder<ListenerController>(
      builder: (controller) {
        if (controller.isLoading && controller.listenerData.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final user = controller.listenerData[index];

              return Padding(
                padding: EdgeInsets.only(
                  bottom: cardSpacing,
                  left: 16,
                  right: 16,
                ),
                child: UserCard(
                  name: user.displayName ?? "Unknown",
                  age: getAgeOrNA(user.dateOfBirth),
                  gender: user.gender ?? "",
                  imageUrl: user.profilePic,
                  audioRate: audioRate.value,
                  videoRate: videoRate.value,
                  callType: user.callType ?? "",
                  coins: 3,
                  status: user.status ?? "",
                  userId: user.id ?? "",
                ),
              );
            },
            childCount: controller.listenerData.length,
          ),
        );
      },
    );
  }
}