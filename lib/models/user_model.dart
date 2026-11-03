/// كائن بيانات المستخدم (Model).
class UserModel {
  final String id;
  final String fullName;
  final String academicId;
  final String email;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.academicId,
    required this.email,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        id: map['id'] as String,
        fullName: map['fullName'] as String,
        academicId: map['academicId'] as String,
        email: map['email'] as String,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'fullName': fullName,
        'academicId': academicId,
        'email': email,
      };
}
