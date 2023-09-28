import 'dart:convert';

class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String link;
  final DateTime created_at;
  final DateTime updated_at;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.link,
    required this.created_at,
    required this.updated_at,
  });

  NotificationModel copyWith({
    int? id,
    String? title,
    String? message,
    String? link,
    DateTime? created_at,
    DateTime? updated_at,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      link: link ?? this.link,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'message': message,
      'link': link,
      'created_at': created_at.millisecondsSinceEpoch,
      'updated_at': updated_at.millisecondsSinceEpoch,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as int,
      title: map['title'] as String,
      message: map['message'] as String,
      link: map['link'] as String,
      created_at: DateTime.parse(map['created_at'] as String),
      updated_at: DateTime.parse(map['updated_at'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, message: $message, link: $link, created_at: $created_at, updated_at: $updated_at)';
  }

  @override
  bool operator ==(covariant NotificationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.message == message &&
        other.link == link &&
        other.created_at == created_at &&
        other.updated_at == updated_at;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ message.hashCode ^ link.hashCode ^ created_at.hashCode ^ updated_at.hashCode;
  }
}
