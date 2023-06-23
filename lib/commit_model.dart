class Commit {
  final String id;
  final String message;
  final String avatar;
  final String name;
  final String dateTime;

  Commit({
    required this.id,
    required this.message,
    required this.avatar,
    required this.name,
    required this.dateTime,
  });

  factory Commit.fromJson(Map<String, dynamic> json) {
    return Commit(
      id: json['node_id'],
      message: json['commit']['message'],
      avatar: json['author']['avatar_url'],
      name: json['commit']['author']['name'],
      dateTime: json['commit']['author']['date'],
    );
  }
}
