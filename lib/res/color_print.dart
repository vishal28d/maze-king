import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import '../utils/utils.dart';

/// Ok Status Massage Green Color --------- >>>
void printOkStatus(dynamic text) => Platform.isIOS ? log(text.toString()) : debugPrint('\x1B[92m${text.toString()}\x1B[0m');

/// <<< Yellow Massage Yellow Color --------- >>>
void printYellow(dynamic text) => Platform.isIOS ? log(text.toString()) : debugPrint('\x1B[93m${text.toString()}\x1B[0m');

/// <<< Warning Massage Red Color --------- >>>
void printWarning(dynamic text) => Platform.isIOS ? log(text.toString()) : debugPrint("\x1B[91m${text.toString()}\x1B[0m");

/// <<< Error Massage Red Color --------- >>>
void printErrors({dynamic errText, dynamic type}) => Platform.isIOS ? log("$type: $errText") : debugPrint("\x1B[97m${type.toString()}\x1B[0m \x1B[91m${errText.toString()}\x1B[0m");

/// <<< Print Massage Green and White Color --------- >>>
void printMess(dynamic title, {dynamic data}) => Platform.isIOS ? log("$title: $data") : debugPrint("\x1B[97m${title.toString()}:\x1B[0m \x1B[92m${data.toString()}\x1B[0m");

/// <<< Action Massage Blue Color --------- >>>
void printAction(dynamic text) => Platform.isIOS ? log(text.toString()) : debugPrint('\x1B[101m${text.toString()}\x1B[0m');

/// <<< Cancel Massage Gray Color --------- >>>
void printCancel(dynamic text) => Platform.isIOS ? log(text.toString()) : debugPrint('\x1B[96m${text.toString()}\x1B[0m');

/// <<< Title Message --------- >>>
void printTitle(dynamic text) => Platform.isIOS ? log(text.toString()) : debugPrint("\x1B[40m-=-=-=-=-=-=-=-= ${text.toString()} -=-=-=-=-=-=-=-=\x1B[0m");

/// <<< Date Message --------- >>>
void printDate(dynamic date) => Platform.isIOS ? log(date.toString()) : debugPrint("\x1B[96m-=-=-=Date=-=-= ${date.toString()} -=-=-=Date=-=-=\x1B[0m");

/// <<< SubTitle Massage Red color --------- >>>
void printWhite(dynamic text) => Platform.isIOS ? log(text.toString()) : debugPrint('\x1B[97m${text.toString()}\x1B[0m');

void printData({dynamic key, dynamic value}) => Platform.isIOS ? log("$key: $value") : debugPrint('\x1B[97m${key.toString()}:\x1B[0m' ' ${key.toString().contains("warning") ? "\x1B[91m${value.toString()}\x1B[0m" : "\x1B[92m${value.toString()}\x1B[0m"}');

void printAPIData(dynamic text) => Platform.isIOS ? log(text.toString()) : debugPrint("\x1B[100m${text.toString()}\x1B[0m");

/// <<< List Massage colors --------- >>>
Future? printLoop(List? list, {String? title, bool? isJsonList}) async {
  if (list == null) {
    return printWhite('${!isValEmpty(title) ? title : "List"} is Null');
  }
  debugPrint('\x1B[97m${title ?? "List"} of length:\x1B[0m \x1B[92m${list.length.toInt()}\x1B[97m');
  for (var i = 0; i < list.length; i++) {
    isJsonList != false ? debugPrint('\x1B[97mIndex[\x1B[0m\x1B[92m${i.toString()}\x1B[97m]:\x1B[0m\x1B[0m \x1B[96m${list[i].toString()}\x1B[0m') : debugPrint('\x1B[97mIndex[\x1B[0m\x1B[92m${i.toString()}\x1B[97m]:\x1B[0m\x1B[0m \x1B[96m${jsonEncode(list[i]).toString()}\x1B[0m');
  }
  // ! Random Color
  for (var i = 0; i < list.length; i++) {
    isJsonList == false ? debugPrint('\x1B[9${i + 2}m${list[i].toString()}\x1B[0m') : debugPrint('\x1B[9${i + 2}m${jsonEncode(list[i]).toString()}\x1B[0m');
  }
}
