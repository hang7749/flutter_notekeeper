class Notes {
  final int? id;
  final String title;
  final String content;
  final String color;
  final String dateTime;

  Notes({
    this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'color': color,
      'dateTime': dateTime,
    };
  }

  factory Notes.fromMap(Map<String, dynamic> map) {
    return Notes(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
      color: map['color'] as String,
      dateTime: map['dateTime'] as String,
    );
  }

  @override
  String toString() {
    return 'Notes{id: $id, title: $title, content: $content, color: $color, dateTime: $dateTime}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Notes &&
        other.id == id &&
        other.title == title &&
        other.content == content &&
        other.color == color &&
        other.dateTime == dateTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ content.hashCode ^ color.hashCode ^ dateTime.hashCode;
  }


}