import 'package:flutter/material.dart';
import 'package:flutter_application_1/chatbot/chatbot_api.dart';
import 'package:flutter_application_1/chatbot/chatbot_history.dart';
import 'package:flutter_application_1/chatbot/message_type.dart';
import 'package:flutter_application_1/chatbot/new_conv_modal.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

const _accent = Color(0xFF1B3C53);
const _accentLight = Color(0xFF456882);

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController(
    text: 'hello',
  );
  final ScrollController _scrollController = ScrollController();
  final List<MessageType> _messages = [];
  bool _sending = false;
  bool _canSend = true;

  @override
  void initState() {
    super.initState();
    _canSend = _textController.text.trim().isNotEmpty;
    _textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final canSend = _textController.text.trim().isNotEmpty;
    if (canSend != _canSend) {
      setState(() => _canSend = canSend);
    }
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red.shade700),
    );
  }

  Future<void> _sendQuery(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty || _sending) return;

    setState(() => _sending = true);

    try {
      final startTime = DateTime.now();
      final response = await ChatbotApi.sendQuery(
        query: trimmed,
        history: createHistory(_messages),
      );
      final duration =
          DateTime.now().difference(startTime).inMilliseconds / 1000;

      if (!mounted) return;
      setState(() {
        _messages.addAll([
          MessageType(type: MessageSender.human, data: trimmed),
          MessageType(
            type: MessageSender.ai,
            data: response.answer,
            time: duration,
            model: response.model,
          ),
        ]);
        _textController.clear();
        _canSend = false;
      });
      _scrollToBottom();
    } catch (_) {
      if (mounted) _showError('error http');
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _openNewConversation() {
    showNewConversationModal(
      context,
      onSuccess: (msg) {
        setState(() {
          _messages.clear();
          _textController.text = msg;
          _canSend = msg.trim().isNotEmpty;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF4F7F9),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0x141B3C53), Color(0x1888B7C2), Color(0xFFF4F7F9)],
          stops: [0.0, 0.45, 1.0],
        ),
      ),
      child: Column(
        children: [
          _ChatHeader(onNewConversation: _openNewConversation),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: _ChatPanel(
                messages: _messages,
                sending: _sending,
                scrollController: _scrollController,
                textController: _textController,
                canSend: _canSend,
                onSend: () => _sendQuery(_textController.text),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  final VoidCallback onNewConversation;

  const _ChatHeader({required this.onNewConversation});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _accent,
        boxShadow: [
          BoxShadow(
            color: _accent.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.smart_toy_outlined, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Assistant',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                Text(
                  'test responses and agent speed',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          FilledButton.icon(
            onPressed: onNewConversation,
            icon: const Icon(Icons.add_comment_outlined, size: 18),
            label: const Text('new conversation'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: _accent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatPanel extends StatelessWidget {
  final List<MessageType> messages;
  final bool sending;
  final ScrollController scrollController;
  final TextEditingController textController;
  final bool canSend;
  final VoidCallback onSend;

  const _ChatPanel({
    required this.messages,
    required this.sending,
    required this.scrollController,
    required this.textController,
    required this.canSend,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? const _EmptyState()
                : ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length + (sending ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < messages.length) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _MessageBubble(message: messages[index]),
                        );
                      }
                      return const _ThinkingIndicator();
                    },
                  ),
          ),
          const Divider(height: 1),
          _ChatInputBar(
            controller: textController,
            sending: sending,
            canSend: canSend,
            onSend: onSend,
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: _accent.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.smart_toy_outlined,
                size: 40,
                color: _accent,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'start a conversation',
              style: TextStyle(
                color: _accent,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ask a question about error codes, menus or device settings',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final MessageType message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isAi = message.isAi;

    return Align(
      alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: isAi ? TextDirection.ltr : TextDirection.rtl,
        children: [
          _AvatarIcon(
            icon: isAi ? Icons.smart_toy_outlined : Icons.person_outline,
            backgroundColor: isAi
                ? _accent.withValues(alpha: 0.09)
                : const Color(0xFFE3F2FD),
            iconColor: isAi ? _accent : const Color(0xFF1565C0),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isAi ? Colors.white : const Color(0xFFE8F1F8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isAi ? 4 : 16),
                  topRight: Radius.circular(isAi ? 16 : 4),
                  bottomLeft: const Radius.circular(16),
                  bottomRight: const Radius.circular(16),
                ),
                border: isAi ? Border.all(color: Colors.grey.shade300) : null,
                boxShadow: isAi
                    ? [
                        BoxShadow(
                          color: _accent.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.time != null)
                    _InfoChip(label: '${message.time!.toStringAsFixed(1)}s'),
                  if (message.model != null) _InfoChip(label: message.model!),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: MarkdownBody(
                      data: message.data,
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(height: 1.7),
                        code: TextStyle(
                          backgroundColor: Colors.black.withValues(alpha: 0.06),
                          fontSize: 13,
                        ),
                        codeblockDecoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        codeblockPadding: const EdgeInsets.all(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;

  const _InfoChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: _accent,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ThinkingIndicator extends StatelessWidget {
  const _ThinkingIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _AvatarIcon(
            icon: Icons.smart_toy_outlined,
            backgroundColor: _accent.withValues(alpha: 0.09),
            iconColor: _accent,
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: _accent,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'thinking...',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const _AvatarIcon({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 18, color: iconColor),
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool sending;
  final bool canSend;
  final VoidCallback onSend;

  const _ChatInputBar({
    required this.controller,
    required this.sending,
    required this.canSend,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 4,
              enabled: !sending,
              textDirection: TextDirection.rtl,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              decoration: InputDecoration(
                hintText: 'پیام خود را بنویسید...',
                hintTextDirection: TextDirection.rtl,
                filled: true,
                fillColor: const Color(0xFFF8FAFB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: _accentLight),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Material(
            color: sending || !canSend ? Colors.grey.shade300 : _accent,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              onTap: sending || !canSend ? null : onSend,
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 48,
                height: 48,
                child: Icon(
                  Icons.send_rounded,
                  color: sending || !canSend
                      ? Colors.grey.shade500
                      : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
