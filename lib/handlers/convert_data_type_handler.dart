DateTime convertStringToDateTime(String dateString) {
  List<String> parts = dateString.split('/');
  int year = int.parse(parts[0]);
  int month = int.parse(parts[1]);
  int day = int.parse(parts[2]);
  return DateTime(year, month, day);
}

String dateTimeToString(DateTime dateTime) {
  final formattedDate = '${dateTime.year}/${dateTime.month}/${dateTime.day}';
  return formattedDate;
}
