enum TicketStatus {
  pending,
  closed;

  static TicketStatus fromJson(dynamic value) {
    switch (value?.toString().toLowerCase()) {
      case 'closed':
        return TicketStatus.closed;
      case 'pending':
      default:
        return TicketStatus.pending;
    }
  }

  String toJson() => name;
}

class TicketModel {
  final String id;
  final String? userId;
  final String question;
  final String answer;
  final TicketStatus status;
  final bool readed;
  final DateTime createdAt;
  final DateTime? closedAt;

  const TicketModel({
    required this.id,
    this.userId,
    required this.question,
    this.answer = '',
    this.status = TicketStatus.pending,
    this.readed = false,
    required this.createdAt,
    this.closedAt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'];

    return TicketModel(
      id: json['id']?.toString() ?? '',
      userId: _readUserId(json, user),
      question: json['question']?.toString() ?? '',
      answer: json['answer']?.toString() ?? '',
      status: TicketStatus.fromJson(json['status']),
      readed: json['readed'] == true,
      createdAt: _parseDateTime(json['createdAt']) ?? DateTime.now(),
      closedAt: _parseDateTime(json['closedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    if (userId != null) 'userId': userId,
    'question': question,
    'answer': answer,
    'status': status.toJson(),
    'readed': readed,
    'createdAt': createdAt.toIso8601String(),
    if (closedAt != null) 'closedAt': closedAt!.toIso8601String(),
  };

  static String? _readUserId(Map<String, dynamic> json, dynamic user) {
    final directId = json['userId']?.toString();
    if (directId != null && directId.isNotEmpty) {
      return directId;
    }

    if (user is Map<String, dynamic>) {
      final nestedId = user['id']?.toString();
      if (nestedId != null && nestedId.isNotEmpty) {
        return nestedId;
      }
    }

    return null;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}
