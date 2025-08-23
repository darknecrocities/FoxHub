import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/supabase_config.dart';
import '../widgets/customize_appbar.dart';
import '../widgets/customize_navbar.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  List<Map<String, dynamic>> posts = [];
  bool isLoading = true;
  final TextEditingController _postController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  // Load posts from Supabase
  Future<void> _loadPosts() async {
    try {
      final response = await SupabaseConfig.client
          .from('posts')
          .select('id, author_name, content, image_url, created_at')
          .order('created_at', ascending: false);

      setState(() {
        posts = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching posts: $e");
      setState(() => isLoading = false);
    }
  }

  // Add a new post
  Future<void> _addPost() async {
    final content = _postController.text.trim();
    if (content.isEmpty) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      final displayName = user?.displayName ?? "Anonymous User";

      await SupabaseConfig.client.from('posts').insert({
        'author_name': displayName,
        'content': content,
        'image_url': '',
      });



      _postController.clear();
      _loadPosts(); // reload after adding
    } catch (e) {
      print("Error adding post: $e");
    }
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return '';
    final date = DateTime.parse(isoDate);
    return DateFormat('MMM d, yyyy • hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomizeAppBar(title: "FoxHub Community"),
      body: Column(
        children: [
          // New Post Input
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _postController,
                    decoration: const InputDecoration(
                      hintText: "What's on your mind?",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addPost,
                  child: const Text("Post"),
                )
              ],
            ),
          ),

          // Posts Feed
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: _loadPosts,
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User header row
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 22,
                                backgroundImage: AssetImage(
                                    'assets/images/default_user.png'),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  post['author_name'] ?? "Anonymous User",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Text(
                                _formatDate(post['created_at']),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Post content
                          Text(
                            post['content'] ?? "",
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(height: 8),

                          // Optional image
                          if (post['image_url'] != null &&
                              post['image_url'].toString().isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                post['image_url'],
                                fit: BoxFit.cover,
                              ),
                            ),

                          const SizedBox(height: 10),

                          // Action buttons row
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                            children: [
                              _buildAction(
                                  Icons.thumb_up_alt_outlined, "Like"),
                              _buildAction(
                                  Icons.mode_comment_outlined, "Comment"),
                              _buildAction(Icons.share_outlined, "Share"),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomizeNavBar(currentIndex: 1),
    );
  }

  Widget _buildAction(IconData icon, String label) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
