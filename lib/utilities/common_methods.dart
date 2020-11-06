class CommonMethods {
  static String getDistanceinFormat(int distanceInMeters) {
    if (distanceInMeters == null) return "NA";
    String displayText;
    if (distanceInMeters < 1000) {
      displayText = '$distanceInMeters Meter';
    } else {
      double kms = distanceInMeters / 1000;
      displayText = '${kms.toStringAsFixed(2)} Km' + (kms > 1 ? "s" : "");
    }
    return displayText;
  }
}
