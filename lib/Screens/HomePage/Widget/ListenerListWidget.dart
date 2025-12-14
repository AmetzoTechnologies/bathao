import 'package:bathao/Controllers/ListenerController/ListenerController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'UserCardWidget.dart';

class ListenerListWidget extends StatelessWidget {
  final ScrollController? scrollController;

  const ListenerListWidget({
    super.key,
    this.scrollController,
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
    final listenerController = Get.find<ListenerController>();

    return GetBuilder<ListenerController>(
      builder: (controller) {
        // loading first time
        if (controller.isLoading && controller.listenerData.isEmpty) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        // empty state
        if (!controller.isLoading && controller.listenerData.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 100),
                child: Text(
                  "No specialists found",
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
              ),
            ),
          );
        }

        // list
        return SliverPadding(
          padding: const EdgeInsets.only(bottom: 90 ,top: 10,left: 15,right: 15),

          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final user = controller.listenerData[index];

                // bottom loading indicator when pagination runs
                if (index == controller.listenerData.length - 1 &&
                    controller.isLoading) {
                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 2),
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
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  );
                }

                // normal card
                return Container(
                  margin: const EdgeInsets.only(bottom: 2),
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
          ),
        );
      },
    );
  }
}
