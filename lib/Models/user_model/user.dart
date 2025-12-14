class User {
  String? id;
  String? phone;
  String? countryCode;
  String? name;
  String? email;
  String? profilePic;
  List<dynamic>? langs;
  DateTime? lastLogin;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    this.id,
    this.phone,
    this.countryCode,
    this.name,
    this.email,
    this.langs,
    this.lastLogin,
    this.createdAt,
    this.updatedAt,
    this.profilePic,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['_id'] as String?,
    phone: json['phone'] as String?,
    countryCode: json['countryCode'] as String?,
    name: json['name'] as String?,
    email: json['email'] as String?,
    langs: json['langs'] as List<dynamic>?,
    profilePic: json['profilePic'] as String?,
    lastLogin:
        json['lastLogin'] == null
            ? null
            : DateTime.parse(json['lastLogin'] as String),
    createdAt:
        json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
    updatedAt:
        json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'phone': phone,
    'countryCode': countryCode,
    'name': name,
    'email': email,
    'langs': langs,
    'profilePic': profilePic,
    'lastLogin': lastLogin?.toIso8601String(),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}
