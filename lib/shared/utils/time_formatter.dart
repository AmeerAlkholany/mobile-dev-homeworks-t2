/// Formats the timer's elapsed time as `mm:ss`, or `h:mm:ss` past one hour.
String formatElapsed(Duration elapsed) {
  final int totalSeconds = elapsed.inSeconds;
  final int hours = totalSeconds ~/ 3600;
  final String minutes = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
  final String seconds = (totalSeconds % 60).toString().padLeft(2, '0');

  return hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
}
