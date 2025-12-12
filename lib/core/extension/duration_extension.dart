extension DurationExtensions on Duration {
  String toHms() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = twoDigits(inHours);
    final minutes = twoDigits(inMinutes.remainder(60));

    return "$hours:$minutes";
  }
}
