/*
 * @Author: 21克的爱情
 * @Date: 2019-11-01 14:57:48
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2019-11-01 16:02:43
 * @Description: 日期选择插件多语言支持
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class DatePickerLocalizations {
  final Locale locale;

  DatePickerLocalizations(this.locale);

  Map<String, DatePickerString> values = {
    'en': EnDatePickerString(),
    'zh': ChDatePickerString()
  };

  DatePickerString get currentLocalization {
    if (values.containsKey(locale.languageCode)) {
      return values[locale.languageCode];
    }
    return values["zh"];
  }

  static const DatePickerLocalizationsDelegate delegate = DatePickerLocalizationsDelegate();

  static DatePickerLocalizations of(BuildContext context) {
    return Localizations.of(context, DatePickerLocalizations);
  }
}

class DatePickerLocalizationsDelegate extends LocalizationsDelegate<DatePickerLocalizations> {
  const DatePickerLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<DatePickerLocalizations> load(Locale locale) {
    return SynchronousFuture<DatePickerLocalizations>(
      DatePickerLocalizations(locale)
    );
  }

  @override
  bool shouldReload(LocalizationsDelegate<DatePickerLocalizations> old) {
    return false;
  }
}

abstract class DatePickerString {
  // 取消按钮
  String cancelText;

  // 确定按钮
  String doneText;

  // 月份
  List<String> getMonths;

  // 星期完整
  List<String> getWeeksFull;

  // 星期简写
  List<String> getWeeksShort;
}

class ChDatePickerString implements DatePickerString {
  @override
  String cancelText = '取消';

  @override
  String doneText = '确定';

  @override
  List<String> getMonths = [
    "01",
    "02",
    "03",
    "04",
    "05",
    "06",
    "07",
    "08",
    "09",
    "10",
    "11",
    "12"
  ];

  @override
  List<String> getWeeksFull = [
    "星期一",
    "星期二",
    "星期三",
    "星期四",
    "星期五",
    "星期六",
    "星期日",
  ];

  @override
  List<String> getWeeksShort = [
    "周一",
    "周二",
    "周三",
    "周四",
    "周五",
    "周六",
    "周日",
  ];
}

class EnDatePickerString implements DatePickerString {
  @override
  String cancelText= 'Cancel';

  @override
  String doneText= 'Done';

  @override
  List<String> getMonths = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  @override
  List<String> getWeeksFull = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  @override
  List<String> getWeeksShort = [
    "Mon",
    "Tue",
    "Wed",
    "Thur",
    "Fri",
    "Sat",
    "Sun",
  ];
}