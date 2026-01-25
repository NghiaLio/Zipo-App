class ConvertTime {
  static String formatTimestamp(DateTime timestamp) {
    // Convert cả hai về UTC để so sánh chính xác
    final now = DateTime.now().toUtc();
    final timestampUtc = timestamp.toUtc();
    final difference = now.difference(timestampUtc);

    if (difference.inDays > 7) {
      // Hiển thị theo local time
      final local = timestamp.toLocal();
      return '${local.day}/${local.month}/${local.year}';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} d';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} h ';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} p';
    } else {
      return 'Vừa xong';
    }
  }

  static String formatDuration(Duration duration) {
    if (duration.inDays > 7) {
      final timestamp = DateTime.now().subtract(duration);
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    } else if (duration.inDays >= 1) {
      return '${duration.inDays} d';
    } else if (duration.inHours >= 1) {
      return '${duration.inHours} h';
    } else if (duration.inMinutes >= 1) {
      return '${duration.inMinutes} p';
    } else {
      return 'Vừa xong';
    }
  }
}
