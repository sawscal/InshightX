// lib/features/search/presentation/search_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news_app/funtions/new.dart';
import 'package:news_app/view/home/detail.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  String _error = '';

  // Call this when user types, with debounce to avoid excessive API calls
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        setState(() {
          _searchResults.clear();
          _error = '';
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _isLoading = true;
        _error = '';
      });

      try {
        final results = await fetchSearchResults(query);
        setState(() {
          _searchResults = results;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
  appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8), // Padding inside AppBar
          decoration: BoxDecoration(
            color: Colors.grey[900], // Slightly lighter background for input
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: 'Search by keyword...',
              hintStyle: TextStyle(color: Colors.white70),
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.search, color: Colors.white70),
              isDense: true, // Compact height
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onChanged: _onSearchChanged,
          ),
        ),
      ),


     body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Removed old TextField from here

            const SizedBox(height: 8), // Reduced spacing since search is in AppBar

            if (_isLoading)
              const Center(child: CircularProgressIndicator()),

            if (_error.isNotEmpty)
              Text(_error, style: const TextStyle(color: Colors.red)),

            if (!_isLoading && _error.isEmpty)
              Expanded(
                child: _searchResults.isEmpty
                    ? const Center(child: Text('No results', style: TextStyle(color: Colors.white70)))
                    : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final article = _searchResults[index];
                          return Card(
                            color: Colors.grey[900],
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(8),
                              leading: article['urlToImage'] != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        article['urlToImage'],
                                        width: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : null,
                              title: Text(
                                article['title'] ?? 'No Title',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                article['description'] ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white70),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Detailscreen(
                                      image: article['urlToImage'] ?? '',
                                      source: article['source']['name'] ?? 'Unknown',
                                      author: article['author'] ?? 'Unknown',
                                      title: article['title'] ?? '',
                                      description: article['content'] ?? article['description'] ?? '',
                                    ),
                                  ),
                                );
                              },
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