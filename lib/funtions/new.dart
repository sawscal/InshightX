import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchNews() async {
  final response = await http.get(Uri.parse(
      'https://newsapi.org/v2/top-headlines?country=us&apiKey=cedd17cdd9dc477e9260c8d3c85c3896')); 
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data["articles"];
  } else {
    throw Exception('Failed to load news');
  }
}

Future<List<dynamic>> fetchtrending() async {
  final response = await http.get(Uri.parse(
      'https://newsapi.org/v2/top-headlines?q=food&apiKey=cedd17cdd9dc477e9260c8d3c85c3896'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data["articles"];
  } else {
    throw Exception('Failed to load news');
  }
}

Future<List<dynamic>> fetchbusniess() async {
  final response = await http.get(Uri.parse(
      'https://newsapi.org/v2/top-headlines?q=football&apiKey=cedd17cdd9dc477e9260c8d3c85c3896')); 
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data["articles"];
  } else {
    throw Exception('Failed to load news');
  }
}

Future<List<dynamic>> fetchentertainment() async {
  final response = await http.get(Uri.parse(
      'https://newsapi.org/v2/top-headlines?q=movie&apiKey=cedd17cdd9dc477e9260c8d3c85c3896')); 
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data["articles"];
  } else {
    throw Exception('Failed to load news');
  }
}

Future<List<dynamic>> fetchsports() async {
  final response = await http.get(Uri.parse(
      'https://newsapi.org/v2/top-headlines?q=money&apiKey=cedd17cdd9dc477e9260c8d3c85c3896')); 
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data["articles"];
  } else {
    throw Exception('Failed to load news');
  }
}

Future<List<dynamic>> fetchSearchResults(String query) async {
  final encodedQuery = Uri.encodeQueryComponent(query);
  final url = Uri.parse(
    'https://newsapi.org/v2/top-headlines?q=$encodedQuery&apiKey=cedd17cdd9dc477e9260c8d3c85c3896',
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['articles'];
  } else {
    throw Exception('Failed to load search results');
  }
}