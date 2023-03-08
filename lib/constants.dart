class Constants {
  static const appTitle = 'Simple Time Tracker';
  static const appBarTitle = 'One Life Luxuries Time Tracker';


  static String getKeyWithDateTimeNowFormat() {
    DateTime now = DateTime.now();
    return '${now.month}:${now.day}:${now.year}';
  }
}
