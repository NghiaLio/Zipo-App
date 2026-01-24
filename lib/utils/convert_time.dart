class ConvertTime {
  static String formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} d ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} h ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} min ago';
    } else {
      return 'Just now';
    }
  }

  static String formatDuration(Duration duration) {
    if (duration.inDays > 7) {
      final timestamp = DateTime.now().subtract(duration);
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    } else if (duration.inDays >= 1) {
      return '${duration.inDays} d ago';
    } else if (duration.inHours >= 1) {
      return '${duration.inHours} h ago';
    } else if (duration.inMinutes >= 1) {
      return '${duration.inMinutes} min ago';
    } else {
      return 'Just now';
    }
  }
}
