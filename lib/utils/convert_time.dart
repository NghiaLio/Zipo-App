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
}
