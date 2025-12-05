import 'package:bathao/Controllers/ListenerController/ListenerController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'UserCardWidget.dart';

class ListenerListWidget extends StatelessWidget {
  final ScrollController? scrollController; // Add this parameter

  const ListenerListWidget({
    super.key,
    this.scrollController, // Optional parameter
  });

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
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        // Show empty state when no listeners found
        if (!controller.isLoading && controller.listenerData.isEmpty) {
          return SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_search,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No specialists found',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try selecting different languages or filters',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final user = controller.listenerData[index];

              // Show loading indicator at the bottom when loading more
              if (index == controller.listenerData.length - 1 &&
                  controller.isLoading) {
                return Column(
                  children: [
                    Padding(
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
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  ],
                );
              }

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