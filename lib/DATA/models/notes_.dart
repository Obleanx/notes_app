class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final bool isPinned;
  final String category;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.modifiedAt,
    this.isPinned = false,
    this.category = 'All',
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? modifiedAt,
    bool? isPinned,
    String? category,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      isPinned: isPinned ?? this.isPinned,
      category: category ?? this.category,
    );
  }
}
