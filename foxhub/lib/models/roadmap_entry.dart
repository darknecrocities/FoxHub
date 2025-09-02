class RoadmapEntry {
  final String id;
  final String title;
  final String description;
  final List<LinkItem> links;

  late final String _lowerTitle;
  late final List<String> _lowerLinkTitles;

  RoadmapEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.links,
  }) {
    _lowerTitle = title.toLowerCase();
    _lowerLinkTitles = links.map((l) => l.title.toLowerCase()).toList();
  }

  bool matches(String keyword) {
    final lowerKeyword = keyword.toLowerCase();
    if (_lowerTitle.contains(lowerKeyword)) return true;
    for (final linkTitle in _lowerLinkTitles) {
      if (linkTitle.contains(lowerKeyword)) return true;
    }
    return false;
  }

  factory RoadmapEntry.fromMap(String id, Map<String, dynamic> map) {
    return RoadmapEntry(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      links: map['links'] != null
          ? List<LinkItem>.from(map['links'].map((x) => LinkItem.fromMap(x)))
          : [],
    );
  }
}

class LinkItem {
  final String title;
  final String url;
  final String type;

  LinkItem({required this.title, required this.url, required this.type});

  factory LinkItem.fromMap(Map<String, dynamic> map) {
    return LinkItem(
      title: map['title'] ?? '',
      url: map['url'] ?? '',
      type: map['type'] ?? 'article',
    );
  }
}
