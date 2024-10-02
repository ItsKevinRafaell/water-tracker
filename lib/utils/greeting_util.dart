class GreetingUtil {
  static String getGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour >= 0 && hour < 12) {
      return "Selamat Pagi, Kevin";
    } else if (hour >= 12 && hour < 15) {
      return "Selamat Siang, Kevin";
    } else if (hour >= 15 && hour < 18) {
      return "Selamat Sore, Kevin";
    } else {
      return "Selamat Malam, Kevin";
    }
  }
}
