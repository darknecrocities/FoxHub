import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../config/supabase_config.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostInput extends StatefulWidget {
  final String currentUserName;
  final Function() onPostAdded;

  const PostInput({
    super.key,
    required this.currentUserName,
    required this.onPostAdded,
  });

  @override
  State<PostInput> createState() => _PostInputState();
}

class _PostInputState extends State<PostInput> {
  final TextEditingController _postController = TextEditingController();
  bool _isPosting = false;

  Future<void> _addPost() async {
    final content = _postController.text.trim();
    if (content.isEmpty || _isPosting) return;

    setState(() => _isPosting = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch fullName from Firestore
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        final fullName = doc.data()?['fullName'] ?? "Unknown";

        // Insert post into Supabase with author_name
        await SupabaseConfig.client.from('posts').insert({
          'uid': user.uid,
          'author_name': fullName,   // ✅ important
          'content': content,
          'image_url': '',
          'created_at': DateTime.now().toIso8601String(),
        });

        _postController.clear();
        widget.onPostAdded();
      }
    } catch (e) {
      print("Error adding post: $e");
    } finally {
      setState(() => _isPosting = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.grey.shade300,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.orange.shade100,
              child: Text(
                widget.currentUserName.isNotEmpty
                    ? widget.currentUserName[0].toUpperCase()
                    : "?",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _postController,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "What's on your mind, ${widget.currentUserName}?",
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _isPosting
                ? const CircularProgressIndicator(strokeWidth: 2)
                : InkWell(
              onTap: _addPost,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.send, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
