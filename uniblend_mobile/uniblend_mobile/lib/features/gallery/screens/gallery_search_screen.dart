import 'package:flutter/material.dart';

class GallerySearchScreen extends StatefulWidget {
  const GallerySearchScreen({super.key});

  @override
  State<GallerySearchScreen> createState() => _GallerySearchScreenState();
}

class _GallerySearchScreenState extends State<GallerySearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> _allPosts = const [
    {
      'imageUrl': 'https://example.com/image1.jpg',
      'caption': 'Beautiful sunset at the beach',
      'user': 'user123',
    },
    {
      'imageUrl': 'https://example.com/image2.jpg',
      'caption': 'Delicious homemade pizza',
      'user': 'foodie42',
    },
    {
      'imageUrl': 'https://example.com/image3.jpg',
      'caption': 'Hiking adventures in the mountains',
      'user': 'naturelover',
    },
  ];
  List<Map<String, String>> _filteredPosts = [];

  @override
  void initState() {
    super.initState();
    _filteredPosts = List.from(_allPosts);
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPosts = _allPosts
          .where((post) =>
              post['caption']!.toLowerCase().contains(query) ||
              post['user']!.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Gallery')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search posts',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredPosts.isEmpty
                  ? const Center(child: Text('No posts found'))
                  : ListView.builder(
                      itemCount: _filteredPosts.length,
                      itemBuilder: (context, index) {
                        final post = _filteredPosts[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                post['imageUrl']!,
                                height: 250,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  post['caption']!,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Text(
                                  'Posted by @${post['user']}',
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
