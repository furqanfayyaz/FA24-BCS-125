class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? 'User',
      createdAt: map['createdAt'] ?? '',
    );
  }
}
