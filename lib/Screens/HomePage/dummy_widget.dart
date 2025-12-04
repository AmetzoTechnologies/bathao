// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../Controllers/ListenerController/ListenerController.dart';
// import 'Widget/UserCardWidget.dart';
// import 'Widget/dummy_user.data.dart';
//
//
// class ListenerListWidget extends StatelessWidget {
//   const ListenerListWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     const bool useDummy = true;
//
//     final controller = Get.put(ListenerController());
//
//     // ------------------- DUMMY MODE -------------------
//     if (useDummy) {
//       return SliverList(
//         delegate: SliverChildBuilderDelegate(
//               (context, index) {
//             final DummyUserModel user = dummyListeners[index];
//
//             return UserCard(
//               name: user.name,
//               age: user.age,
//               gender: user.gender,
//               imageUrl: user.imageUrl,
//               callType: user.callType,
//               coins: 3,
//               status: user.status,
//               userId: user.userId,
//               audioRate: user.audioRate,
//               videoRate: user.videoRate,
//             );
//           },
//           childCount: dummyListeners.length,
//         ),
//       );
//     }
//
//     // ------------------- REAL API MODE -------------------
//     return Obx(() {
//       if (controller.isLoading && controller.listenerData.isEmpty) {
//         return const SliverToBoxAdapter(
//           child: Padding(
//             padding: EdgeInsets.all(20),
//             child: Center(child: CircularProgressIndicator()),
//           ),
//         );
//       }
//
//       return SliverList(
//         delegate: SliverChildBuilderDelegate(
//               (context, index) {
//             final item = controller.listenerData[index];
//
//             String age = "N/A";
//             if (item.dateOfBirth != null) {
//               final now = DateTime.now();
//               int a = now.year - item.dateOfBirth!.year;
//               if (now.month < item.dateOfBirth!.month ||
//                   (now.month == item.dateOfBirth!.month &&
//                       now.day < item.dateOfBirth!.day)) {
//                 a--;
//               }
//               age = a.toString();
//             }
//
//             return UserCard(
//               name: item.displayName ?? "",
//               age: age,
//               gender: item.gender ?? "N/A",
//               imageUrl: item.profilePic,
//               audioRate: audioRate.value,
//               videoRate: videoRate.value,
//               callType: item.callType ?? "both",
//               coins: 3,
//               status: item.status ?? "offline",
//               userId: item.id ?? "",
//             );
//           },
//           childCount: controller.listenerData.length,
//         ),
//       );
//     });
//   }
// }
