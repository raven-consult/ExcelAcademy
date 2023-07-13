class NotificationService {
  final String uid;

  const NotificationService(this.uid);

  Future<List<NotificationItem>> getAllNotifications() async {
    return <NotificationItem>[];
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final String type;
  final String createdAt;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
  });
}
