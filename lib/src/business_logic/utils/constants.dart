import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//https://www.mocky.io/v2/5dfccffc310000efc8d2c1ad

const splashDelay = 5;
const baseUrlPrefix = 'https://';
const ip = 'www.mocky.io'; //
const baseUrlSuffix = '/v2/';
const apiUrl = baseUrlPrefix + ip + baseUrlSuffix;

String getUrlOf(String func) {
  return apiUrl + func;
}

int getIntValueOf(String numberString) {
  return int.parse(numberString);
}

double getdoubleValueOf(String numberString) {
  return double.parse(numberString);
}

void flutterToast(String s) {
  Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);
}
