import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions for the app bar (e.g., clear button)
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon on the left of the app bar (e.g., back button)
    return IconButton(
      icon: const Icon(FontAwesomeIcons.arrowLeft),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Build the results based on the search query
    // You can display search results here
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Suggestions that appear when the user types in the search bar
    // You can display search suggestions here
    return Container();
  }
}
