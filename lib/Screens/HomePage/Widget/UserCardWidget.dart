import 'dart:math';

import 'package:get/get.dart';

import 'package:flutter/material.dart';

import '../../../Controllers/CallController/CallController.dart';
import '../../../Services/ApiService.dart';
import 'CallButton.dart';

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
    final r = Random();
    return Color.fromARGB(
      255,
      r.nextInt(256),
      r.nextInt(256),
      r.nextInt(256),
    );
  }

  Color getStatusColor(String status) {
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


    final radius = 24.0;       // smaller avatar
    final padding = 6.0;       // low padding
    final fontMain = 14.0;     // name
    final fontSub = 11.0;      // age
    final iconSize = 16.0;     // icons
    final dotSize = 10.0;      // status

    final statColor = getStatusColor(status);

    final callController = Get.find<CallController>();

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
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
          Stack(
            children: [
              Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: statColor, width: 3),
      ),
                child: CircleAvatar(

                  radius: radius,
                  backgroundColor: imageUrl == null ? randomColor() : null,
                  backgroundImage:
                  imageUrl != null ? NetworkImage("$baseImageUrl$imageUrl") : null,
                  child: imageUrl == null
                      ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      : null,
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    color: statColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 8),

          // Main text details
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
                Row(
                  children: [
                    Icon(Icons.person, size: iconSize, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      "$age age",
                      style: TextStyle(
                        fontSize: fontSub,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Rate & Buttons
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(Icons.call, size: iconSize, color: Colors.greenAccent),
                  const SizedBox(width: 2),
                  Text(
                    "$audioRate",
                    style: TextStyle(fontSize: fontSub, color: Colors.white),
                  ),
                  const SizedBox(width: 6),
                  Icon(Icons.videocam, size: iconSize, color: Colors.redAccent),
                  const SizedBox(width: 2),
                  Text(
                    "$videoRate",
                    style: TextStyle(fontSize: fontSub, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  MyCustomCallButton(
                    userId: userId,
                    name: name,
                    status: status,
                    isEnabled: callType == "audio" || callType == "both",

                  ),
                  const SizedBox(width: 6),
                  MyCustomCallButton(
                    userId: userId,
                    name: name,
                    status: status,
                    isVideoCall: true,
                    isEnabled: callType == "video" || callType == "both",

                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
