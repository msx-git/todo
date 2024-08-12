import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final String id;
  final String title;
  final DateTime dateTime;
  final bool isDone;
  final int rating;

  const Todo({
    required this.id,
    required this.title,
    required this.dateTime,
    this.isDone = false,
    this.rating = 0,
  });

  @override
  String toString() {
    return 'Todo{id: $id, title: $title, dateTime: $dateTime, isDone: $isDone, rating: $rating}';
  }

  @override
  List<Object> get props => [id, title, dateTime, isDone, rating];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'dateTime': dateTime.toIso8601String(),
      'isDone': isDone,
      'rating': rating,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as String,
      title: json['title'] as String,
      dateTime: DateTime.parse(json['dateTime']),
      isDone: json['isDone'] as bool,
      rating: json['rating'] as int,
    );
  }

  Todo copyWith({
    String? id,
    String? title,
    DateTime? dateTime,
    bool? isDone,
    int? rating,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      dateTime: dateTime ?? this.dateTime,
      isDone: isDone ?? this.isDone,
      rating: rating ?? this.rating,
    );
  }
}
