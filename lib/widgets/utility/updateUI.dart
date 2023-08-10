import 'dart:developer';
import 'package:flutter/material.dart';

class UpdateUI with ChangeNotifier {
  int _screenNo = 0;
  int get screenNo => _screenNo;

  set screenNo(int value) {
    _screenNo = value;
    log("Called Setter====$_screenNo");
  }
}
