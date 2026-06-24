enum MessageSender { ai, human }

class MessageType {
  final MessageSender type;
  final String data;
  final double? time;
  final String? model;

  const MessageType({
    required this.type,
    required this.data,
    this.time,
    this.model,
  });

  bool get isAi => type == MessageSender.ai;
}
