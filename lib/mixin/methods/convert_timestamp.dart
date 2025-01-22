import 'package:cloud_firestore/cloud_firestore.dart';

mixin Methods {
  String calculateTimeFromNow(DateTime time) {
    var now = DateTime.now();
    var date = time;
    var diff = now.difference(date);
    var timeString = '';

    if (diff.inSeconds <= 0) {
      timeString = 'Mới đây';
    } else if (diff.inMinutes == 0) {
      timeString = 'Mới đây';
    } else if (diff.inHours == 0) {
      timeString = '${diff.inMinutes} phút trước';
    } else if (diff.inDays == 0) {
      timeString = '${diff.inHours} giờ trước';
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      timeString = '${diff.inDays} ngày trước';
    } else {
      timeString = '${(diff.inDays / 7).floor()} tuần trước';
    }

    return timeString;
  }
}