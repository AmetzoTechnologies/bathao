import 'dart:math';
import 'package:bathao/Screens/HomePage/Widget/CallButton.dart';
import 'package:bathao/Services/ApiService.dart';
import 'package:get/get.dart';
import 'package:bathao/Controllers/CallController/CallController.dart';
import 'package:bathao/Theme/Colors.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String name;
  final String age;
  final String gender;
  final String? imageUrl;
  final String callType;
  final int coins;
  final String status;
  final String userId;
  final int audioRate;
  final int videoRate;

  const UserCard({
    super.key,
    required this.name,
    required this.age,
    required this.callType,
    required this.gender,
    required this.imageUrl,
    required this.coins,
    required this.status,
    required this.userId,
    required this.audioRate,
    required this.videoRate,
  });

  Color randomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case "online":
        return Colors.green;
      case "offline":
        return Colors.red;
      case "busy":
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final callController = Get.find<CallController>();

    final width = MediaQuery.of(context).size.width;

    // Small, controlled responsive sizes
    final avatarRadius = width * 0.08; // slightly smaller
    final iconSize = width * 0.04;
    final spacing = width * 0.025;
    final fontMain = width * 0.040;
    final fontSub = width * 0.030;
    final statusDot = width * 0.028;

    final Color statColor = statusColor(status);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing,
        vertical: spacing * 0.8,
      ),
      child: Container(
        padding: EdgeInsets.all(spacing),
        decoration: BoxDecoration(
          color: const Color(0xFF2D2A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Row(
          children: [
            // Avatar + Status
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(width * 0.008),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: statColor, width: width * 0.010),
                  ),
                  child: CircleAvatar(
                    radius: avatarRadius,
                    backgroundColor: imageUrl == null ? randomColor() : null,
                    backgroundImage: imageUrl != null
                        ? NetworkImage("$baseImageUrl$imageUrl")
                        : null,
                    child: imageUrl == null
                        ? Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: avatarRadius * 0.65,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                        : null,
                  ),
                ),

                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    width: statusDot,
                    height: statusDot,
                    decoration: BoxDecoration(
                      color: statColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(width: spacing),

            // NAME + GENDER + AGE
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
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: spacing * 0.5),

                  Row(
                    children: [
                      Icon(
                        gender == "male" ? Icons.person : Icons.face_4,
                        size: iconSize,
                        color: Colors.white,
                      ),
                      SizedBox(width: spacing * 0.4),
                      Text(
                        "$age age",
                        style: TextStyle(
                          fontSize: fontSub,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: spacing),

            // RIGHT SIDE: Rates + Buttons
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Audio / Video Rate Row
                Row(
                  children: [
                    Icon(Icons.call,
                        color: Colors.greenAccent, size: iconSize),
                    SizedBox(width: spacing * 0.3),
                    Text("$audioRate",
                        style:
                        TextStyle(color: Colors.white, fontSize: fontSub)),

                    SizedBox(width: spacing),

                    Icon(Icons.videocam,
                        color: Colors.redAccent, size: iconSize),
                    SizedBox(width: spacing * 0.3),
                    Text("$videoRate",
                        style:
                        TextStyle(color: Colors.white, fontSize: fontSub)),
                  ],
                ),

                SizedBox(height: spacing),

                // CALL BUTTONS ROW
                Row(
                  children: [
                    MyCustomCallButton(
                      userId: userId,
                      name: name,
                      status: status,
                      isEnabled:
                      callType == "audio" || callType == "both",
                    ),
                    SizedBox(width: spacing),
                    MyCustomCallButton(
                      userId: userId,
                      name: name,
                      status: status,
                      isVideoCall: true,
                      isEnabled:
                      callType == "video" || callType == "both",
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
