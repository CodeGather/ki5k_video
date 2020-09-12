import 'dart:math';
 
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../date_time_formatter.dart';
import '../date_picker.dart';
import '../date_picker_theme.dart';
import '../date_picker_constants.dart';
import '../i18n/date_picker_localizations.dart';
import 'date_picker_title_widget.dart';

/// DateTimePicker widget. Can display date and time picker.
///
/// @author dylan wu
/// @since 2019-05-10
class DateTimePickerWidget extends StatefulWidget {
  DateTimePickerWidget({
    Key key,
    this.minDateTime,
    this.maxDateTime,
    this.initDateTime,
    this.dateFormat: DATETIME_PICKER_TIME_FORMAT,
    this.pickerTheme: DateTimePickerTheme.Default,
    this.onCancel,
    this.onChange,
    this.onConfirm,
  }) : super(key: key) {
    DateTime minTime = minDateTime ?? DateTime.parse(DATE_PICKER_MIN_DATETIME);
    DateTime maxTime = maxDateTime ?? DateTime.parse(DATE_PICKER_MAX_DATETIME);
    assert(minTime.compareTo(maxTime) < 0);
  }

  final DateTime minDateTime, maxDateTime, initDateTime;
  final String dateFormat;
  final DateTimePickerTheme pickerTheme;
  final DateVoidCallback onCancel;
  final DateValueCallback onChange, onConfirm;

  @override
  State<StatefulWidget> createState() => _DateTimePickerWidgetState(
      this.minDateTime, this.maxDateTime, this.initDateTime);
}

class _DateTimePickerWidgetState extends State<DateTimePickerWidget> {
  DateTime _minTime, _maxTime;
  int _currYear, _currMonth, _currDay, _currHour, _currMinute, _currSecond;
  List<int> _yearRange, _monthRange, _dayRange, _hourRange, _minuteRange, _secondRange;
  FixedExtentScrollController 
    _yearScrollCtrl,
    _monthScrollCtrl,
    _dayScrollCtrl,
    _hourScrollCtrl,
    _minuteScrollCtrl,
    _secondScrollCtrl;

  /*
  * 每个月对应的天数
  * */
  static const List<int> _daysInMonth = <int>[ 31, -1, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ];

  Map<String, FixedExtentScrollController> _scrollCtrlMap;
  Map<String, List<int>> _valueRangeMap;

  bool _isChangeTimeRange = false;

  final DateTime _baselineDate = DateTime(1900, 1, 1);

  _DateTimePickerWidgetState(
      DateTime minTime, DateTime maxTime, DateTime initTime) {
    // check minTime value
    if (minTime == null) {
      minTime = DateTime.parse(DATE_PICKER_MIN_DATETIME);
    }
    // check maxTime value
    if (maxTime == null) {
      maxTime = DateTime.parse(DATE_PICKER_MAX_DATETIME);
    }
    // check initTime value
    if (initTime == null) {
      initTime = DateTime.now();
    }
    // limit initTime value
    if (initTime.compareTo(minTime) < 0) {
      initTime = minTime;
    }
    if (initTime.compareTo(maxTime) > 0) {
      initTime = maxTime;
    }

    this._minTime = minTime;
    this._maxTime = maxTime;
    this._currYear = initTime.year;
    this._currMonth = initTime.month;
    this._currDay = initTime.day;
    this._currHour = initTime.hour;
    this._currMinute = initTime.minute;
    this._currSecond = initTime.second;

    // limit the range of year
    this._yearRange = _calcYearRange();
    this._currYear = min(max(_yearRange.first, _currYear), _yearRange.last);

    // limit the range of month
    this._monthRange = _calcMonthRange();
    this._currMonth = min(max(_monthRange.first, _currMonth), _monthRange.last);

    // limit the range of day 
    this._dayRange = _calcDayRange();
    this._currDay = min(max(_dayRange.first, _currDay), _dayRange.last);

    // limit the range of hour
    this._hourRange = _calcHourRange();
    this._currHour = min(max(_hourRange.first, _currHour), _hourRange.last);

    // limit the range of minute
    this._minuteRange = _calcMinuteRange();
    this._currMinute = min(max(_minuteRange.first, _currMinute), _minuteRange.last);

    // limit the range of second
    this._secondRange = _calcSecondRange();
    this._currSecond = min(max(_secondRange.first, _currSecond), _secondRange.last);

    // create scroll controller
    _yearScrollCtrl = FixedExtentScrollController(initialItem: _currYear - _yearRange.first);
    _monthScrollCtrl = FixedExtentScrollController(initialItem: _currMonth - _monthRange.first);
    _dayScrollCtrl = FixedExtentScrollController(initialItem: _currDay - _dayRange.first);
    _hourScrollCtrl = FixedExtentScrollController(initialItem: _currHour - _hourRange.first);
    _minuteScrollCtrl = FixedExtentScrollController( initialItem: _currMinute - _minuteRange.first);
    _secondScrollCtrl = FixedExtentScrollController( initialItem: _currSecond - _secondRange.first);

    _scrollCtrlMap = {
      'y': _yearScrollCtrl,
      'M': _monthScrollCtrl,
      'd': _dayScrollCtrl,
      'H': _hourScrollCtrl,
      'm': _minuteScrollCtrl,
      's': _secondScrollCtrl
    };
    _valueRangeMap = {
      'y': _yearRange, 
      'M': _monthRange, 
      'd': _dayRange, 
      'H': _hourRange, 
      'm': _minuteRange, 
      's': _secondRange
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Material(
        color: Colors.transparent, 
        child: _renderPickerView(context)
      ),
    );
  }

  /// render time picker widgets
  Widget _renderPickerView(BuildContext context) {
    Widget pickerWidget = _renderDatePickerWidget();

    // display the title widget
    if (widget.pickerTheme.title != null || widget.pickerTheme.showTitle) {
      Widget titleWidget = DatePickerTitleWidget(
        pickerTheme: widget.pickerTheme,
        onCancel: () => _onPressedCancel(),
        onConfirm: () => _onPressedConfirm(),
      );
      return Column(children: <Widget>[titleWidget, pickerWidget]);
    }
    return pickerWidget;
  }

  /// pressed cancel widget
  void _onPressedCancel() {
    if (widget.onCancel != null) {
      widget.onCancel();
    }
    Navigator.pop(context);
  }

  /// pressed confirm widget
  void _onPressedConfirm() {
    if (widget.onConfirm != null) {
      DateTime day = _baselineDate.add(Duration(days: _currDay));
      DateTime dateTime = DateTime(
        _currYear, _currMonth, _currDay, _currHour, _currMinute, _currSecond
      );
      
      widget.onConfirm(dateTime, _calcSelectIndexList());
    }
    Navigator.pop(context);
  }

  /// notify selected datetime changed
  void _onSelectedChange() {
    if (widget.onChange != null) {
      DateTime day = _baselineDate.add(Duration(days: _currDay));
      DateTime dateTime = DateTime(
        _currYear, _currMonth, _currDay, _currHour, _currMinute, _currSecond
      );
      widget.onChange(dateTime, _calcSelectIndexList());
    }
  }

  /// find scroll controller by specified format
  FixedExtentScrollController _findScrollCtrl(String format) {
    FixedExtentScrollController scrollCtrl;
    _scrollCtrlMap.forEach((key, value) {
      if (format.contains(key)) {
        scrollCtrl = value;
      }
    });
    return scrollCtrl;
  }

  /// find item value range by specified format
  List<int> _findPickerItemRange(String format) {
    List<int> valueRange;
    _valueRangeMap.forEach((key, value) {
      if (format.contains(key)) {
        valueRange = value;
      }
    });
    return valueRange;
  }

  /// render the picker widget of year、month and day
  Widget _renderDatePickerWidget() {
    List<Widget> pickers = List<Widget>();
    List<String> formatArr = DateTimeFormatter.splitDateFormat(
        widget.dateFormat,
        mode: DateTimePickerMode.datetime
    );
    int count = formatArr.length;
    int dayFlex = count > 5 ? count - 1 : count;

    // render day picker column
    // String dayFormat = formatArr.removeAt(0);
    // Widget dayPickerColumn = _renderDatePickerColumnComponent(
    //   scrollCtrl: _dayScrollCtrl,
    //   valueRange: _dayRange,
    //   format: dayFormat,
    //   valueChanged: (value) {
    //     _changeDaySelection(value);
    //   },
    //   flex: dayFlex,
    //   itemBuilder: (BuildContext context, int index) =>
    //       _renderDayPickerItemComponent(_dayRange.first + index, dayFormat),
    // );
    // pickers.add(dayPickerColumn);

    // render time picker column
    formatArr.forEach((format) {
      List<int> valueRange = _findPickerItemRange(format);
      Widget pickerColumn = _renderDatePickerColumnComponent(
        scrollCtrl: _findScrollCtrl(format),
        valueRange: valueRange,
        format: format,
        flex: 1,
        valueChanged: (value) {
          _changeSelect(format, value);
        },
      );
      pickers.add(pickerColumn);
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, 
      children: pickers
    );
  }

  Widget _renderDatePickerColumnComponent({
    @required FixedExtentScrollController scrollCtrl,
    @required List<int> valueRange,
    @required String format,
    @required ValueChanged<int> valueChanged,
    int flex,
    IndexedWidgetBuilder itemBuilder,
  }) {
    Widget columnWidget = Container(
      padding: EdgeInsets.all(8.0),
      width: double.infinity,
      height: widget.pickerTheme.pickerHeight,
      decoration: BoxDecoration(color: widget.pickerTheme.backgroundColor),
      child: CupertinoPicker.builder(
        backgroundColor: widget.pickerTheme.backgroundColor,
        scrollController: scrollCtrl,
        itemExtent: widget.pickerTheme.itemHeight,
        onSelectedItemChanged: valueChanged,
        childCount: valueRange.last - valueRange.first + 1,
        itemBuilder: itemBuilder ??
            (context, index) => _renderDatePickerItemComponent(
                valueRange.first + index, format),
      ),
    );
    return Expanded(
      flex: flex,
      child: columnWidget,
    );
  }

  /// render hour、minute、second picker item
  Widget _renderDatePickerItemComponent(int value, String format) {
    DatePickerString locale = DatePickerLocalizations.of(context)?.currentLocalization ?? ChDatePickerString();
    return Container(
      height: widget.pickerTheme.itemHeight,
      alignment: Alignment.center,
      child: Text(
        DateTimeFormatter.formatDateTime(value, format, locale),
        style: widget.pickerTheme.itemTextStyle ?? DATETIME_PICKER_ITEM_TEXT_STYLE,
      ),
    );
  }

  void _changeSelect( String format, int selectvalue){
    if (format.contains('y')) {
      int value = _yearRange.first + selectvalue;
      if (_currYear != value) {
        _currYear = value;
        _changeTimeRange();
      }
    } else if (format.contains('M')) {
      int value = _monthRange.first + selectvalue;
      if (_currMonth != value) {
        _currMonth = value;
        _changeTimeRange();
      }
    } else if (format.contains('d')) {
      int value = _dayRange.first + selectvalue;
      if (_currDay != value) {
        _currDay = value;
        _changeTimeRange();
      }
    } else if (format.contains('H')) {
      int value = _hourRange.first + selectvalue;
      if (_currHour != value) {
        _currHour = value;
        _changeTimeRange();
      }
    } else if (format.contains('m')) {
      int value = _minuteRange.first + selectvalue;
      if (_currMinute != value) {
        _currMinute = value;
        _changeTimeRange();
      }
    } else if (format.contains('s')) {
      int value = _secondRange.first + selectvalue;
      if (_currSecond != value) {
        _currSecond = value;
      }
    }
    _onSelectedChange();
  }


  /// change range of minute and second
  void _changeTimeRange() {
    if (_isChangeTimeRange) {
      return;
    }
    _isChangeTimeRange = true;

    List<int> yearRange = _calcYearRange();
    bool yearRangeChanged = _yearRange.first != yearRange.first || _yearRange.last != yearRange.last;
    if (yearRangeChanged) {
      // selected day changed
      _currYear = max(min(_currYear, yearRange.last), yearRange.first);
    }

    List<int> monthRange = _calcMonthRange();
    bool monthRangeChanged = _monthRange.first != monthRange.first || _monthRange.last != monthRange.last;
    if (monthRangeChanged) {
      // selected day changed
      _currMonth = max(min(_currMonth, monthRange.last), monthRange.first);
    }

    List<int> dayRange = _calcDayRange();
    bool dayRangeChanged = _dayRange.first != dayRange.first || _dayRange.last != dayRange.last;
    if (dayRangeChanged) {
      // selected day changed
      _currDay = max(min(_currDay, dayRange.last), dayRange.first);
    }

    List<int> hourRange = _calcHourRange();
    bool hourRangeChanged = _hourRange.first != hourRange.first ||  _hourRange.last != hourRange.last;
    if (hourRangeChanged) {
      // selected day changed
      _currHour = max(min(_currHour, hourRange.last), hourRange.first);
    }

    List<int> minuteRange = _calcMinuteRange();
    bool minuteRangeChanged = _minuteRange.first != minuteRange.first || _minuteRange.last != minuteRange.last;
    if (minuteRangeChanged) {
      // selected hour changed
      _currMinute = max(min(_currMinute, minuteRange.last), minuteRange.first);
    }

    List<int> secondRange = _calcSecondRange();
    bool secondRangeChanged = _secondRange.first != secondRange.first || _secondRange.last != secondRange.last;
    if (secondRangeChanged) {
      // second range changed, need limit the value of selected second
      _currSecond = max(min(_currSecond, secondRange.last), secondRange.first);
    }

    setState(() {
      _yearRange = yearRange;
      _monthRange = monthRange;
      _dayRange = dayRange;
      _hourRange = hourRange;
      _minuteRange = minuteRange;
      _secondRange = secondRange;

      _valueRangeMap['y'] = yearRange;
      _valueRangeMap['M'] = monthRange;
      _valueRangeMap['d'] = dayRange;
      _valueRangeMap['H'] = hourRange;
      _valueRangeMap['m'] = minuteRange;
      _valueRangeMap['s'] = secondRange;
    });


    if (yearRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      int currYear = _currYear;
      _yearScrollCtrl.jumpToItem(yearRange.last - yearRange.first); 
      if (currYear < yearRange.last) {
        _yearScrollCtrl.jumpToItem(0);
      }
    }

    if (monthRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      int currMonth = _currMonth;
      _monthScrollCtrl.jumpToItem(monthRange.last - monthRange.first); 
      if (currMonth < monthRange.last) {
        _monthScrollCtrl.jumpToItem(0);
      }
    }

    if (dayRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      int currDay = _currDay;
      _dayScrollCtrl.jumpToItem(dayRange.last - dayRange.first); 
      if (currDay < dayRange.last) {
        _dayScrollCtrl.jumpToItem(0);
      }
    }

    if (hourRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      int currHour = _currHour;
      _hourScrollCtrl.jumpToItem(hourRange.last - hourRange.first); 
      if (currHour < hourRange.last) {
        _hourScrollCtrl.jumpToItem(0);
      }
    }

    if (minuteRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      int currMinute = _currMinute;
      _minuteScrollCtrl.jumpToItem(minuteRange.last - minuteRange.first);
      if (currMinute < minuteRange.last) {
        _minuteScrollCtrl.jumpToItem(0);
      }
    }

    if (secondRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      int currSecond = _currSecond;
      _secondScrollCtrl.jumpToItem(secondRange.last - secondRange.first);
      if (currSecond < secondRange.last) {
        _secondScrollCtrl.jumpToItem(0);
      }
    }

    _isChangeTimeRange = false;
  }

  /// calculate selected index list
  List<int> _calcSelectIndexList() {
    int yearIndex = _currYear - _yearRange.first;
    int monthIndex = _currMonth - _monthRange.first;
    int dayIndex = _currDay - _dayRange.first;
    int hourIndex = _currHour - _hourRange.first;
    int minuteIndex = _currMinute - _minuteRange.first;
    int secondIndex = _currSecond - _secondRange.first;
    return [yearIndex, monthIndex, dayIndex, hourIndex, minuteIndex, secondIndex];
  }

  /// calculate the range of day
  List<int> _calcYearRange() {
    var today = DateTime.now();
    var fiftyDaysFromNow = today.add(new Duration(days: 365));
    int minYears = _minTime.year;
    int maxYears = fiftyDaysFromNow.year;
    return [minYears, maxYears];
  }

  /// calculate the range of day
  List<int> _calcMonthRange() {
    var today = DateTime.now();
    int minMonths = (_currYear==today.year ? today.month : 1 );
    int maxMonths = 12;
    return [minMonths, maxMonths];
  }

  /*
  * 根据年月获取月的天数
  * */
  static int getDaysInMonth(int year, int month) {
    if (month == DateTime.february) {
      final bool isLeapYear = (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      if (isLeapYear) return 29;
      return 28;
    }
    return _daysInMonth[month - 1];
  }

  /// calculate the range of day
  List<int> _calcDayRange() {
    var today = DateTime.now();
    int minDays = ( _currYear == _yearRange.first && _currMonth==today.month ? today.day : 1 );
    int maxDays = getDaysInMonth(_currYear, _currMonth);
    return [minDays, maxDays];
  }

  /// calculate the range of hour
  List<int> _calcHourRange() {
    DateTime dateNow = DateTime.now();
    int minHour = 0, maxHour = 23;
    // 判断是否是选择的初始值
    if (_currYear == dateNow.year && _currMonth ==dateNow.month && _currDay == dateNow.day  ) {
      minHour = _minTime.hour;
    }
    if (_currDay == _dayRange.last) {
      maxHour = _maxTime.hour;
    }
    return [minHour, maxHour];
  }

  /// calculate the range of minute
  List<int> _calcMinuteRange({currHour}) {
    int minMinute = 0, maxMinute = 59;
    if (currHour == null) {
      currHour = _currHour;
    }

    if (_currDay == _dayRange.first && currHour == _minTime.hour) {
      // selected minimum day、hour, limit minute range
      minMinute = _minTime.minute;
    }
    if (_currDay == _dayRange.last && currHour == _maxTime.hour) {
      // selected maximum day、hour, limit minute range
      maxMinute = _maxTime.minute;
    }
    return [minMinute, maxMinute];
  }

  /// calculate the range of second
  List<int> _calcSecondRange({currHour, currMinute}) {
    int minSecond = 0, maxSecond = 59;

    if (currHour == null) {
      currHour = _currHour;
    }
    if (currMinute == null) {
      currMinute = _currMinute;
    }

    if (_currDay == _dayRange.first &&
        currHour == _minTime.hour &&
        currMinute == _minTime.minute) {
      // selected minimum hour and minute, limit second range
      minSecond = _minTime.second;
    }
    if (_currDay == _dayRange.last &&
        currHour == _maxTime.hour &&
        currMinute == _maxTime.minute) {
      // selected maximum hour and minute, limit second range
      maxSecond = _maxTime.second;
    }
    return [minSecond, maxSecond];
  }
}
