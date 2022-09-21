import 'dart:convert';

class WalletModel {
  final int id;
  final int userId;
  final String? posterImage;
  final String points;
  final String amount;
  final String specialty;
  final String isApproved;
  final String catgory;
  final String createdAt;
  final String message;

  const WalletModel({
    required this.id,
    required this.userId,
    this.posterImage,
    required this.points,
    required this.amount,
    required this.specialty,
    required this.isApproved,
    required this.catgory,
    required this.createdAt,
    required this.message,
  });

  WalletModel copyWith({
    int? id,
    int? user_id,
    String? poster_image,
    String? points,
    String? amount,
    String? specialty,
    String? is_approved,
    String? catgory,
    String? created_at,
    String? message,
  }) {
    return WalletModel(
      id: id ?? this.id,
      userId: user_id ?? this.userId,
      posterImage: poster_image ?? this.posterImage,
      points: points ?? this.points,
      amount: amount ?? this.amount,
      specialty: specialty ?? this.specialty,
      isApproved: is_approved ?? this.isApproved,
      catgory: catgory ?? this.catgory,
      createdAt: created_at ?? this.createdAt,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'poster_image': posterImage,
      'points': points,
      'amount': amount,
      'specialty': specialty,
      'is_approved': isApproved,
      'catgory': catgory,
      'created_at': createdAt,
      'message': message,
    };
  }

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
      id: map['id']?.toInt() ?? map['redemtion_id']?.toInt(),
      userId: map['user_id']?.toInt() ?? 0,
      posterImage: map['poster_image'],
      points: map['points'].toString(),
      amount: map['amount'] ?? '',
      specialty: map['specialty'] ?? '',
      isApproved: map['is_approved'] ?? '',
      catgory: map['catgory'] ?? '',
      createdAt: map['created_at'] ?? '',
      message: map['message'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory WalletModel.fromJson(String source) => WalletModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'WalletModel(id: $id, user_id: $userId, poster_image: $posterImage, points: $points, amount: $amount, specialty: $specialty, is_approved: $isApproved, catgory: $catgory, created_at: $createdAt, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WalletModel &&
        other.id == id &&
        other.userId == userId &&
        other.posterImage == posterImage &&
        other.points == points &&
        other.amount == amount &&
        other.specialty == specialty &&
        other.isApproved == isApproved &&
        other.catgory == catgory &&
        other.createdAt == createdAt &&
        other.message == message;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        posterImage.hashCode ^
        points.hashCode ^
        amount.hashCode ^
        specialty.hashCode ^
        isApproved.hashCode ^
        catgory.hashCode ^
        createdAt.hashCode ^
        message.hashCode;
  }
}
