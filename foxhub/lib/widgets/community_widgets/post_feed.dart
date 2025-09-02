import 'package:flutter/material.dart';
import '../../../config/supabase_config.dart';
import 'reply_dialog.dart';
import 'date_format.dart';

class PostFeed extends StatelessWidget {
  final List<Map<String, dynamic>> posts;
  final bool isLoading;
  final String currentUserName;
  final Function() refreshPosts;

  const PostFeed({
    super.key,
    required this.posts,
    required this.isLoading,
    required this.currentUserName,
    required this.refreshPosts,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (posts.isEmpty) {
      return const Center(child: Text("No posts yet."));
    }

    return RefreshIndicator(
      onRefresh: () async => refreshPosts(),
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          final authorName = post['author_name'] ?? "Anonymous";
          final replies = post['replies'] as List<dynamic>? ?? [];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Post Author Row
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.orange.shade100,
                        child: Text(
                          authorName.isNotEmpty ? authorName[0].toUpperCase() : "?",
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authorName,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                            Text(
                              formatDate(post['created_at']),
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_horiz, color: Colors.grey),
                        onPressed: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  Text(
                    post['content'] ?? "",
                    style: const TextStyle(fontSize: 15, height: 1.4),
                  ),
                  const SizedBox(height: 8),

                  if (post['image_url'] != null && post['image_url'].toString().isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        post['image_url'],
                        fit: BoxFit.cover,
                      ),
                    ),

                  const SizedBox(height: 12),
                  Divider(color: Colors.grey[300]),

                  // Post Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _action(Icons.thumb_up_alt_outlined, "Like"),
                      _action(Icons.mode_comment_outlined, "Reply", onTap: () {
                        showReplyDialog(context, post['id'], currentUserName, refreshPosts);
                      }),
                      _action(Icons.share_outlined, "Share"),
                    ],
                  ),

                  // Replies Section
                  if (replies.isNotEmpty) const Divider(color: Colors.grey),
                  if (replies.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: replies.map<Widget>((reply) {
                          final replyAuthor = reply['author_name'] ?? "Anonymous";
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.grey.shade300,
                                  child: Text(
                                    replyAuthor.isNotEmpty ? replyAuthor[0].toUpperCase() : "?",
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "$replyAuthor: ",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: reply['content'] ?? "",
                                          style: const TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _action(IconData icon, String label, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[700]),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
