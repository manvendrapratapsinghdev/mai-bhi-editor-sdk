/// Formats a [DateTime] into a human-readable relative time string.
///
/// Examples: "Just now", "2m ago", "3h ago", "Yesterday", "5 Mar"
String formatRelativeTime(DateTime? dateTime) {
  if (dateTime == null) return '';

  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.isNegative) return 'Just now';

  if (difference.inSeconds < 60) return 'Just now';
  if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
  if (difference.inHours < 24) return '${difference.inHours}h ago';
  if (difference.inDays == 1) return 'Yesterday';
  if (difference.inDays < 7) return '${difference.inDays}d ago';

  // For older dates, show the date.
  final months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  if (dateTime.year == now.year) {
    return '${dateTime.day} ${months[dateTime.month - 1]}';
  }

  return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
}
