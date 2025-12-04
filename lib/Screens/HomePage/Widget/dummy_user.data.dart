

final List<DummyUserModel> dummyListeners = [
  DummyUserModel(
    name: "Aisha Thomas",
    age: "24",
    gender: "female",
    imageUrl: null,
    callType: "both",
    status: "online",
    userId: "dummy_001",
    audioRate: 10,
    videoRate: 20,
  ),
  DummyUserModel(
    name: "Rahul Menon",
    age: "28",
    gender: "male",
    imageUrl: null,
    callType: "audio",
    status: "busy",
    userId: "dummy_002",
    audioRate: 8,
    videoRate: 0,
  ),
  DummyUserModel(
    name: "Sara Ali",
    age: "22",
    gender: "female",
    imageUrl: null,
    callType: "video",
    status: "offline",
    userId: "dummy_003",
    audioRate: 0,
    videoRate: 15,
  ),
];

class DummyUserModel {
  final String name;
  final String age;
  final String gender;
  final String? imageUrl;
  final String callType;
  final String status;
  final String userId;
  final int audioRate;
  final int videoRate;

  DummyUserModel({
    required this.name,
    required this.age,
    required this.gender,
    required this.imageUrl,
    required this.callType,
    required this.status,
    required this.userId,
    required this.audioRate,
    required this.videoRate,
  });
}
