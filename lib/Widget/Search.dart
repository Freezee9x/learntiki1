import 'package:flutter/material.dart';
import 'package:tikidemo/Model/Products.dart';

class ProductSearch extends SearchDelegate<Album?> {
  final Future<List<Album>> products;

  ProductSearch({required this.products});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Album>>(
      future: products,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final results = snapshot.data!
              .where((album) =>
                  album.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final album = results[index];
              return ListTile(
                title: Text(album.name),
                onTap: () {
                  close(context, album);
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Album>>(
      future: query.isNotEmpty ? products : Future<List<Album>>.value([]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final results = snapshot.data!
              .where((album) =>
                  album.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final album = results[index];
              return ListTile(
                title: Text(album.name),
                onTap: () {
                  query = album.name;
                  showResults(context);
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
