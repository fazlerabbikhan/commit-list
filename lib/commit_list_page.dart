import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'commit_model.dart';
import 'package:intl/intl.dart';

class CommitListPage extends StatefulWidget {
  const CommitListPage({super.key});

  @override
  _CommitListPageState createState() => _CommitListPageState();
}

class _CommitListPageState extends State<CommitListPage> {
  List<Commit> commits = [];
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    fetchCommits();
  }

  Future<void> fetchCommits() async {
    final response = await http.get(Uri.parse(
        'https://api.github.com/repos/flutter/flutter/commits?per_page=10&page=$currentPage'));
    final jsonData = json.decode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        final List<Commit> fetchedCommits = (jsonData as List)
            .map((commit) => Commit.fromJson(commit))
            .toList();
        commits = fetchedCommits;
      });
    }
  }

  void nextPage() {
    setState(() {
      currentPage++;
    });
    fetchCommits();
  }

  void previousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
      fetchCommits();
    }
  }

  String getFormattedDateTime(String dateTimeString) {
    DateTime commitDateTime = DateTime.parse(dateTimeString);
    DateTime currentDateTime = DateTime.now();
    DateFormat timeFormat = DateFormat('HH:mm');
    DateFormat dateTimeFormat = DateFormat('dd MMMM yyyy');
    DateFormat dayFormat = DateFormat('EEEE');

    if (commitDateTime.year == currentDateTime.year &&
        commitDateTime.month == currentDateTime.month &&
        commitDateTime.day == currentDateTime.day) {
      return timeFormat.format(commitDateTime);
    } else if (commitDateTime.year == currentDateTime.year &&
        commitDateTime.month == currentDateTime.month &&
        currentDateTime.day - commitDateTime.day == 1) {
      return 'Yesterday';
    } else if (currentDateTime.difference(commitDateTime).inDays <= 7) {
      return dayFormat.format(commitDateTime);
    } else {
      return dateTimeFormat.format(commitDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title:
            const Text('Flutter Commit List', style: TextStyle(fontSize: 20)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.only(bottom: 10),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(
                  'Master',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: commits.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          commits[index].message.split(' (#')[0],
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(commits[index].avatar),
                                    radius: 20,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  commits[index].name,
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Text(
                              getFormattedDateTime(commits[index].dateTime),
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: previousPage,
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Page $currentPage',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                IconButton(
                  onPressed: nextPage,
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
