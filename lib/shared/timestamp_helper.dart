class TimeStampHelper {
  // Helper function
  static String getMessageDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final msgDate = DateTime(date.year, date.month, date.day);

    if (msgDate == today) return "Today";
    if (msgDate == yesterday) return "Yesterday";
    return "${date.day}/${date.month}/${date.year}"; // or format as you like
  }
}
