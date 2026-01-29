class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final PostRepository _repository = PostRepository();
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = _repository.fetchPosts(); // Initialize GET request
  }

  // Trigger POST request
  Future<void> _sendPost() async {
    try {
      final Post newPost = Post(
        userId: 1,
        title: "Hello Flutter",
        body: "This is a test post",
      );

      final Post createdPost = await _repository.createPost(newPost);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Success: Created Post ID ${createdPost.id}"),
        ),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error creating post"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter GET & POST"),
      ),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          final posts = snapshot.data!;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                title: Text(post.title),
                subtitle: Text(post.body),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendPost,
        child: const Icon(Icons.add),
      ),
    );
  }
}
