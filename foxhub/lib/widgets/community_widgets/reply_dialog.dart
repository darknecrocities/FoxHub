import 'package:flutter/material.dart';
import '../../../config/supabase_config.dart';

void showReplyDialog(
    BuildContext context,
    String postId, // ✅ change to String for UUID
    String currentUserName,
    Function() refreshPosts,
    ) {
  final replyController = TextEditingController();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        "Reply to ${currentUserName.isNotEmpty ? currentUserName : "post"}",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: TextField(
            controller: replyController,
            maxLines: null,
            minLines: 3,
            decoration: InputDecoration(
              hintText: "Write your reply...",
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            final replyText = replyController.text.trim();
            if (replyText.isEmpty) return;

            try {
              await SupabaseConfig.client.from('replies').insert({
                'post_id': postId,
                'author_name': currentUserName,
                'content': replyText,
                'created_at': DateTime.now().toIso8601String(),
              });

              Navigator.pop(context);
              refreshPosts();
            } catch (e) {
              print("Error adding reply: $e");
            }
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text("Reply"),
        ),
      ],
    ),
  );
}
