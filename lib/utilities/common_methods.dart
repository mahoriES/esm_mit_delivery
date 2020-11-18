import 'package:date_format/date_format.dart';

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

  static String convertDateFromString(String strDate) {
    DateTime todayDate = DateTime.parse(strDate);

    return formatDate(
        todayDate, [dd, ' ', M, ' ', yyyy, ' , ', hh, ':', nn, ' ', am]);
  }
}
