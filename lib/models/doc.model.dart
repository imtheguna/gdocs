import 'dart:convert';

class DocumentModel {
  final String title;
  final String uid;
  final List contents;
  final DateTime createdAt;
  final String id;
  final List sharedUser;
  DocumentModel({
    required this.title,
    required this.uid,
    required this.contents,
    required this.createdAt,
    required this.id,
    required this.sharedUser,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'title': title});
    result.addAll({'uid': uid});
    result.addAll({'contents': contents});
    result.addAll({'createdAt': createdAt.millisecondsSinceEpoch});
    result.addAll({'id': id});
    result.addAll({'sharedUser': sharedUser});

    return result;
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      title: map['title'] ?? '',
      uid: map['uid'] ?? '',
      contents: List.from(map['contents']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      id: map['_id'] ?? '',
      sharedUser: List.from(map['sharedUser']),
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentModel.fromJson(String source) =>
      DocumentModel.fromMap(json.decode(source));
}


/*DocumentModel({
    required this.title,
    required this.uid,
    required this.contents,
    required this.createdAt,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'title': title});
    result.addAll({'uid': uid});
    result.addAll({'contents': contents});
    result.addAll({'createdAt': createdAt.millisecondsSinceEpoch});
    result.addAll({'id': id});

    return result;
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      title: map['title'] ?? '',
      uid: map['uid'] ?? '',
      contents: List.from(map['contents']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      id: map['_id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentModel.fromJson(String source) =>
      DocumentModel.fromMap(json.decode(source));

  DocumentModel copyWith({
    String? title,
    String? uid,
    List? content,
    DateTime? createdAt,
    String? id,
  }) {
    return DocumentModel(
      title: title ?? this.title,
      uid: uid ?? this.uid,
      contents: content ?? this.contents,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
    );
  }
}
*/