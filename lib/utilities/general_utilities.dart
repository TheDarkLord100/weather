import 'package:flutter/material.dart';

class GeneralUtils {
  static const primaryColor = Color(0xFF002E59);

  static void showSnackbar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      behavior: SnackBarBehavior.floating,
    ));
  }

  static String convertDate(DateTime date) {
    String dateString = '';
    dateString = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'June',
      'July',
      'Aug',
      'Sept',
      'Oct',
      'Nov',
      'Dec'
    ].elementAt(date.month - 1);
    dateString = '$dateString ${date.day < 10? '0' : ''}${date.day}';
    return dateString;
  }
}
