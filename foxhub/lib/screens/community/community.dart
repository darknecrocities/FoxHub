import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../config/supabase_config.dart';
import '../../widgets/customize_appbar.dart';
import '../../widgets/customize_navbar.dart';
import '../../widgets/community_widgets/post_input.dart';
import '../../widgets/community_widgets/post_feed.dart';
import '../../widgets/community_widgets/filter_dialog.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  String currentUserName = "";
  List<Map<String, dynamic>> posts = [];
  bool isLoading = true;
  bool isUserLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadPosts();
  }

  /// Load current user's fullName from Firebase Firestore
  Future<void> _loadCurrentUser() async {
    try {
      final firebaseUser = await SupabaseConfig.client.auth.currentUser;
      if (firebaseUser != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.id)
            .get();

        setState(() {
          currentUserName = doc.data()?['fullName'] ?? "Unknown";
          isUserLoading = false;
        });
      } else {
        setState(() {
          currentUserName = "Unknown";
          isUserLoading = false;
        });
      }
    } catch (e) {
      print("Error loading user: $e");
      setState(() {
        currentUserName = "Unknown";
        isUserLoading = false;
      });
    }
  }

  /// Load posts with optional filter by author
  Future<void> _loadPosts({String? filterAuthor}) async {
    setState(() => isLoading = true);

    try {
      final postResponse = await SupabaseConfig.client
          .from('posts')
          .select('id, uid, content, image_url, created_at')
          .order('created_at', ascending: false);

      final List<Map<String, dynamic>> fetchedPosts =
      List<Map<String, dynamic>>.from(postResponse);

      for (var post in fetchedPosts) {
        // Fetch author name from Firebase
        final postUid = post['uid'];
        if (postUid != null && postUid.isNotEmpty) {
          final doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(postUid)
              .get();
          post['author_name'] = doc.data()?['fullName'] ?? "Unknown";
        } else {
          post['author_name'] = "Unknown";
        }

        // Apply author filter if provided
        if (filterAuthor != null && filterAuthor.isNotEmpty) {
          if (post['author_name'] != filterAuthor) continue;
        }

        // Fetch replies for this post
        final replyResponse = await SupabaseConfig.client
            .from('replies')
            .select()
            .eq('post_id', post['id'])
            .order('created_at', ascending: true);

        post['replies'] = List<Map<String, dynamic>>.from(replyResponse);

        // Add author names to replies
        for (var reply in post['replies']) {
          final replyUid = reply['uid'];
          if (replyUid != null && replyUid.isNotEmpty) {
            final replyDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(replyUid)
                .get();
            reply['author_name'] = replyDoc.data()?['fullName'] ?? "Unknown";
          } else {
            reply['author_name'] = "Unknown";
          }
        }
      }

      setState(() {
        posts = fetchedPosts;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading posts: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isUserLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: const CustomizeAppBar(title: "FoxHub Community"),
      bottomNavigationBar: CustomizeNavBar(currentIndex: 0),
      body: Column(
        children: [
          PostInput(
            currentUserName: currentUserName,
            // matches Function({String? filterAuthor})? type
            onPostAdded: ({String? filterAuthor}) => _loadPosts(filterAuthor: filterAuthor),
          ),
          FilterButton(
            onFilterApplied: ({String? filterAuthor}) => _loadPosts(filterAuthor: filterAuthor),
          ),
          Expanded(
            child: PostFeed(
              posts: posts,
              isLoading: isLoading,
              currentUserName: currentUserName,
              refreshPosts: ({String? filterAuthor}) => _loadPosts(filterAuthor: filterAuthor),
            ),
          ),
        ],
      ),
    );
  }
}
