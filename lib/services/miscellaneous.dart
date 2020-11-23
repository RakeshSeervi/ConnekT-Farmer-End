class Utilities {
  static String getDate(DateTime date) {
    return date.day.toString() +
        ' / ' +
        date.month.toString() +
        ' / ' +
        date.year.toString();
  }
}
