// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../Controllers/CallHistoryController/CallHiistoryController.dart';
// import '../../Theme/Colors.dart';
//
// class CallHistoryPage extends StatefulWidget {
//   const CallHistoryPage({Key? key}) : super(key: key);
//
//   @override
//   State<CallHistoryPage> createState() => _CallHistoryPageState();
// }
//
// class _CallHistoryPageState extends State<CallHistoryPage> {
//   final CallHistoryController controller = Get.put(CallHistoryController());
//   final ScrollController scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//
//     scrollController.addListener(() {
//       if (!controller.isLoading.value &&
//           controller.hasMore.value &&
//           scrollController.position.pixels >=
//               scrollController.position.maxScrollExtent - 200) {
//         controller.getHistory();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     scrollController.dispose();
//     super.dispose();
//   }
//
//   /// Stable random color - same initial always gets same color
//   Color avatarColor(String text) {
//     final hash = text.codeUnits.fold(0, (p, c) => p + c);
//     final rand = Random(hash);
//     return Color.fromARGB(
//       255,
//       rand.nextInt(256),
//       rand.nextInt(256),
//       rand.nextInt(256),
//     );
//   }
//
//   String formatCallDate(DateTime callDate) {
//     final now = DateTime.now();
//     final diff = now.difference(callDate).inDays;
//
//     if (diff == 0) return "Today";
//     if (diff == 1) return "Yesterday";
//     if (diff <= 6) return "$diff days ago";
//
//     return "${callDate.day.toString().padLeft(2, '0')}/"
//         "${callDate.month.toString().padLeft(2, '0')}/"
//         "${callDate.year}";
//   }
//
//   Future<void> _refresh() async {
//     await controller.refreshHistory();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final bottomPadding = MediaQuery.of(context).padding.bottom + 90;
//
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldColor,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // === Header ===
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//               child: Row(
//                 children: const [
//                   Text(
//                     "Call History",
//                     style: TextStyle(
//                       fontWeight: FontWeight.w700,
//                       fontSize: 18,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // === List Area ===
//             Expanded(
//               child: Obx(() {
//                 final data = controller.historyData;
//
//                 // 1) Initial Load
//                 if (controller.isLoading.value && data.isEmpty) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//
//                 // 2) Empty Page
//                 if (!controller.isLoading.value && data.isEmpty) {
//                   return RefreshIndicator(
//                     onRefresh: _refresh,
//                     child: ListView(
//                       padding: EdgeInsets.only(bottom: bottomPadding),
//                       physics: const AlwaysScrollableScrollPhysics(),
//                       children: const [
//                         SizedBox(height: 200),
//                         Center(
//                           child: Text(
//                             "No call history yet",
//                             style: TextStyle(
//                               color: Colors.white70,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//
//                 // 3) List + Pagination
//                 return RefreshIndicator(
//                   onRefresh: _refresh,
//                   child: ListView.builder(
//                     controller: scrollController,
//                     physics: const AlwaysScrollableScrollPhysics(),
//                     padding: EdgeInsets.only(bottom: bottomPadding),
//                     itemCount: data.length + (controller.hasMore.value ? 1 : 0),
//                     itemBuilder: (context, index) {
//                       // Pagination Loader
//                       if (index == data.length) {
//                         return const Padding(
//                           padding: EdgeInsets.symmetric(vertical: 16),
//                           child: Center(child: CircularProgressIndicator()),
//                         );
//                       }
//
//                       final history = data[index];
//                       final name = history.receiver?.displayName ?? 'Unknown';
//                       final type = history.callType?.toLowerCase() ?? 'audio';
//                       final mins = history.minutesCharged ?? "";
//                       final created = DateTime.tryParse(
//                         history.createdAt.toString(),
//                       )?.toLocal() ?? DateTime.now();
//
//                       return Container(
//                         margin: const EdgeInsets.symmetric(
//                             vertical: 6, horizontal: 16),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF2D2A2A),
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: AppColors.borderColor),
//                         ),
//                         child: ListTile(
//                           contentPadding: const EdgeInsets.all(12),
//                           leading: CircleAvatar(
//                             radius: 26,
//                             backgroundColor: avatarColor(name),
//                             child: Text(
//                               name.isNotEmpty
//                                   ? name[0].toUpperCase()
//                                   : "?",
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ),
//
//                           title: Text(
//                             name,
//                             style: TextStyle(
//                               color: AppColors.textColor,
//                               fontSize: 15,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//
//                           subtitle: Text(
//                             "$type • $mins min${mins == "1" ? "" : "s"}",
//                             style: TextStyle(
//                               color: AppColors.borderColor,
//                               fontSize: 13,
//                             ),
//                           ),
//
//                           trailing: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 formatCallDate(created),
//                                 style: TextStyle(
//                                   color: AppColors.textColor,
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 13,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 TimeOfDay.fromDateTime(created)
//                                     .format(context),
//                                 style: const TextStyle(
//                                   color: Colors.red,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../Controllers/CallHistoryController/CallHiistoryController.dart';
// import '../../Services/ApiService.dart';
// import '../../Theme/Colors.dart';
//
// class CallHistoryPage extends StatefulWidget {
//   const CallHistoryPage({Key? key}) : super(key: key);
//
//   @override
//   State<CallHistoryPage> createState() => _CallHistoryPageState();
// }
//
// class _CallHistoryPageState extends State<CallHistoryPage> {
//   final CallHistoryController callHistoryControllercontroller = Get.put(CallHistoryController());
//   final ScrollController scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//
//     scrollController.addListener(() {
//       final max = scrollController.position.maxScrollExtent;
//       final cur = scrollController.position.pixels;
//
//       if (!callHistoryControllercontroller.isLoading.value &&
//           callHistoryControllercontroller.hasMore.value &&
//           cur >= max * 0.9) {
//         callHistoryControllercontroller.getHistory();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     scrollController.dispose();
//     super.dispose();
//   }
//
//   String formatCallDate(DateTime callDate) {
//     final now = DateTime.now();
//     final diff = now.difference(callDate).inDays;
//
//     if (diff == 0) return "Today";
//     if (diff == 1) return "Yesterday";
//     if (diff <= 7) return "$diff days ago";
//
//     return "${callDate.day.toString().padLeft(2, '0')}/"
//         "${callDate.month.toString().padLeft(2, '0')}/"
//         "${callDate.year}";
//   }
//
//   Color getRandomColor() {
//     final random = Random();
//     return Color.fromARGB(
//       255,
//       random.nextInt(256),
//       random.nextInt(256),
//       random.nextInt(256),
//     );
//   }
//
//   Future<void> _refresh() async {
//     await callHistoryControllercontroller.refreshHistory();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(50), // Default is 56, so make it smaller
//         child: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF000D64), Color(0xFF081DAA)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.vertical(
//               bottom: Radius.circular(30),
//             ),
//           ),
//           child: AppBar(
//             backgroundColor:Color(0xFF000D64),
//             centerTitle: true,
//             title: Text(
//               "Call History",
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18, // Slightly smaller font
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//       ),
//
//       backgroundColor: AppColors.scaffoldColor,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Center(
//               //   child: Container(
//               //     color: Colors.indigo,
//               //     child: Text(
//               //
//               //       "Call History",
//               //       style: TextStyle(
//               //
//               //         fontWeight: FontWeight.bold,
//               //         fontSize: 20,
//               //         color: Colors.white,
//               //       ),
//               //     ),
//               //   ),
//               // ),
//               // const SizedBox(height: 10),
//
//               Expanded(
//                 child: Obx(() {
//                   final data = callHistoryControllercontroller.historyData;
//
//                   // first load loader
//                   if (callHistoryControllercontroller.isLoading.value && data.isEmpty) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//
//                   // empty state
//                   if (!callHistoryControllercontroller.isLoading.value && data.isEmpty) {
//                     return RefreshIndicator(
//                       onRefresh: _refresh,
//                       child: ListView(
//                         physics: const AlwaysScrollableScrollPhysics(),
//
//                         padding: EdgeInsets.only(
//                           bottom: MediaQuery.of(context).padding.bottom + 90,
//                           top: 0,
//                           left: 0,
//                           right: 0,
//                         ),
//
//
//                         children: const [
//                           SizedBox(height: 200),
//                           Center(
//                             child: Text(
//                               "No call history yet",
//                               style: TextStyle(
//                                 color: Colors.white70,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }
//
//                   // list with pagination
//                   return RefreshIndicator(
//                     onRefresh: _refresh,
//                     child: ListView.builder(
//                       controller: scrollController,
//                       physics: const AlwaysScrollableScrollPhysics(),
//
//                       padding: EdgeInsets.only(
//                         bottom: MediaQuery.of(context).padding.bottom + 90,
//                         top: 0,
//                         left: 0,
//                         right: 0,
//                       ),
//
//                       itemCount: data.length +
//                           (callHistoryControllercontroller.hasMore.value ? 1 : 0),
//                       itemBuilder: (context, index) {
//                         if (index == data.length) {
//                           return const Padding(
//                             padding: EdgeInsets.symmetric(vertical: 16),
//                             child: Center(
//                               child: CircularProgressIndicator(),
//                             ),
//                           );
//                         }
//
//                         final history = data[index];
//                         final rec = history.receiver;
//                         final name = rec?.displayName ?? 'Unknown';
//                         final pic  = rec?.profilePic ?? '';
//
//                         final type = history.callType ?? 'N/A';
//                         final mins = history.minutesCharged ?? '';
//                         final dateUtc =
//                             DateTime.tryParse(history.createdAt.toString())
//                                 ?.toLocal() ??
//                                 DateTime.now();
//                         final formattedTime =
//                         TimeOfDay.fromDateTime(dateUtc).format(context);
//
//                         return Container(
//                           margin: const EdgeInsets.only(bottom: 6),
//                           padding: const EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [
//                                 Color(0xFF000000),
//                                 Color(0xFF0a192f),
//                                 Color(0xFF112240),
//                               ],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                           child: ListTile(
//                             title: Text(
//                               name,
//                               style: TextStyle(color: AppColors.textColor),
//                             ),
//                             subtitle: Text(
//                               "$type • $mins mins",
//                               style: TextStyle(color: AppColors.borderColor),
//                             ),
//                             leading: CircleAvatar(
//                             radius: 28,
//                             backgroundColor: Colors.transparent,
//                             child: ClipOval(
//                               child: (pic != null && pic.isNotEmpty)
//                                   ? Image.network(
//                                 "$baseImageUrl$pic",
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) {
//                                   return Container(
//                                     color: getRandomColor(),
//                                     alignment: Alignment.center,
//                                     child: Text(
//                                       name.isNotEmpty ? name[0].toUpperCase() : '?',
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 24,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               )
//                                   : Container(
//                                 color: getRandomColor(),
//                                 alignment: Alignment.center,
//                                 child: Text(
//                                   name.isNotEmpty ? name[0].toUpperCase() : '?',
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 24,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//
//                             trailing: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   formatCallDate(dateUtc),
//                                   style: TextStyle(
//                                     color: AppColors.textColor,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   formattedTime,
//                                   style: const TextStyle(
//                                     color: Colors.red,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 }),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/CallHistoryController/CallHiistoryController.dart';
import '../../Services/ApiService.dart';
import '../../Theme/Colors.dart';

class CallHistoryPage extends StatefulWidget {
  const CallHistoryPage({Key? key}) : super(key: key);

  @override
  State<CallHistoryPage> createState() => _CallHistoryPageState();
}

class _CallHistoryPageState extends State<CallHistoryPage> {
  final CallHistoryController controller = Get.put(CallHistoryController());
  final ScrollController scrollController = ScrollController();

  final double radius = 30;
  final double padding = 12;
  final double marginBottom = 6;
  final double fontMain = 15;
  final double fontSub = 12;
  final double dotSize = 12;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (!controller.isLoading.value &&
          controller.hasMore.value &&
          scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200) {
        controller.getHistory();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await controller.refreshHistory();
  }

  Color randomColor() {
    final r = Random();
    return Color.fromARGB(
      255,
      r.nextInt(256),
      r.nextInt(256),
      r.nextInt(256),
    );
  }

  String formatCallDate(DateTime callDate) {
    final now = DateTime.now();
    final diff = now.difference(callDate).inDays;

    if (diff == 0) return "Today";
    if (diff == 1) return "Yesterday";
    if (diff <= 7) return "$diff days ago";

    return "${callDate.day.toString().padLeft(2, '0')}/"
        "${callDate.month.toString().padLeft(2, '0')}/"
        "${callDate.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF494D7C),
          Color(0xff5787b8),
            Color(0xFF596BC3),

          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),

      child: Scaffold(
        backgroundColor: AppColors.scaffoldColor,

        appBar: AppBar(
          backgroundColor: const Color(0xFF000D64),
          centerTitle: true,
          title: const Text(
            "Call History",
            style: TextStyle(fontSize: 18,color:  Colors.white),
          ),
        ),

        body: Obx(() {
          final data = controller.historyData;

          if (controller.isLoading.value && data.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!controller.isLoading.value && data.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 200),
                  Center(
                    child: Text(
                      "No call history yet",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 90 ,top: 10),

              itemCount: data.length + (controller.hasMore.value ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == data.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final h = data[index];
                final rec = h.receiver;
                final name = rec?.displayName ?? "Unknown";
                final pic = rec?.profilePic ?? "";

                final type = h.callType ?? "";
                final mins = h.minutesCharged ?? "";
                final dt = DateTime.tryParse(h.createdAt.toString())?.toLocal() ?? DateTime.now();
                final time = TimeOfDay.fromDateTime(dt).format(context);

                return Container(
                  margin: EdgeInsets.only(
                    bottom: marginBottom,
                    left: 16,
                    right: 16,
                  ),
                  padding: EdgeInsets.all(padding),
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
                  ),

                  child: Row(
                    children: [
                      // --- Avatar
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: radius,
                            backgroundColor: pic.isEmpty ? randomColor() : Colors.transparent,
                            backgroundImage:
                            pic.isNotEmpty ? NetworkImage("$baseImageUrl$pic") : null,
                            child: pic.isEmpty
                                ? Text(
                              name.isNotEmpty ? name[0].toUpperCase() : "?",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                                : null,
                          ),

                          // dot
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              width: dotSize,
                              height: dotSize,
                              decoration: const BoxDecoration(
                                color: Colors.greenAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 8),

                      // --- Middle Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: fontMain,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 2),
                            Text(
                              "$type • $mins mins",
                              style: TextStyle(
                                fontSize: fontSub,
                                color: AppColors.borderColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // --- Right date/time
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatCallDate(dt),
                            style: TextStyle(
                              fontSize: fontSub,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            time,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}

