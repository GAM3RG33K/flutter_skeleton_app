import 'package:intl/intl.dart';

/// This number formatter instance can be used to format a [num] value
/// to #.## display format, floating point value format
NumberFormat numberFormatDouble = NumberFormat('#.##');

/// This number formatter instance can be used to format a [num] value
/// to # display format, integer value format
NumberFormat numberFormatInt = NumberFormat('#');

/// returns [INTRA_DAY_DATE_FORMAT] if [isIntradayDateFormat] is true,
/// [EOD_DATE_FORMAT] otherwise.
DateFormat getDateFormat(bool isIntradayDateFormat) =>
    isIntradayDateFormat ? INTRA_DAY_DATE_FORMAT : EOD_DATE_FORMAT;

///
DateFormat getDateFormat2(bool isIntradayDateFormat) =>
    isIntradayDateFormat ? INTRA_DAY_DATE_FORMAT2 : EOD_DATE_FORMAT2;

/// Date formatter instance for Intraday candles
final DateFormat INTRA_DAY_DATE_FORMAT = DateFormat('yyyy-MM-dd HH:mm:ss');

///
final DateFormat INTRA_DAY_DATE_FORMAT2 = DateFormat('dd-MMM-yy  hh:mm:ss a');

/// Date formatter instance for EOD candles
final DateFormat EOD_DATE_FORMAT = DateFormat('yyyy-MM-dd');

///
final DateFormat EOD_DATE_FORMAT2 = DateFormat('dd-MMM-yy');

/// returns true if the value of time is not 00:00:00 in date time false otherwise.
bool containsTime(DateTime date) =>
    date.hour != 0 || date.minute != 0 || date.second != 0;

/// This method will remove unnecessary decimal point from double value and
/// will return it in string format.
///
/// For e.g
/// input: 2.0 output: 2
/// input: 2.1 output: 2.1
/// Author: Kalpesh Kundanani.
String numToString(num value) =>
    ((value.toInt() < value) ? value : value.toInt()).toString();

/// This method will format the given [dateTime] with given [dateFormat]
/// instance
String formatDate(DateTime dateTime, DateFormat dateFormat) =>
    dateFormat.format(dateTime);

/// This method will format the given [dateTime] with given [dateFormat]
/// instance
String formatDateString(String dateTime, DateFormat dateFormat) {
  if (isEmpty(dateTime)) {
    return '';
  }
  return dateFormat.format(DateTime.parse(dateTime));
}

/// Method to get a double formatted value, #.##
double getFormattedValDouble(double value) {
  final formattedValString = numberFormatDouble.format(value);

  if (formattedValString.isEmpty) return null;
  return double.parse(formattedValString);
}

/// Method to get proper format
String getFormattedDate(DateTime dateTime) {
  final dateFormat = getDateFormat(containsTime(dateTime));
  return dateFormat.format(dateTime);
}

/// Method is an extension to check if the provided
/// [data] is null or empty
bool isEmpty(dynamic data) {
  if (data is Iterable || data is Map || data is String) {
    return data?.isEmpty ?? true;
  } else {
    return data == null;
  }
}

/// Method is an extension to check if the provided
/// [data] is not null and empty
bool isNotEmpty(dynamic data) {
  return !isEmpty(data);
}

/// Method to add only those values from [newList] which are not already added in the
/// [sourceList]
List<T> addNonRepeatingValues<T>(List<T> sourceList, List<T> newList) {
  for (final value in newList) {
    if (!sourceList.contains(value)) {
      sourceList.add(value);
    }
  }
  return sourceList;
}

/// Method to throw an exception if the given [data] contains HTML text
void throwErrorIfContainsHTML(String data) {
  final hasHtml = containsHtml(data);
  if (hasHtml) {
    throw ArgumentError('''
        
        HTML tags are not expected in response. response.body: $data
        
        ''');
  }
}

/// Method to check if the given string contains any HTML type text.
///
/// This method is still not 100% full proof because the XML format also fits in
/// this reg ex
bool containsHtml(String body) {
  final findHtmlTags = RegExp(r'<[^>]*>');
  final containsHtml = findHtmlTags.hasMatch(body);
  return containsHtml;
}

/// this method allows trimming the stack trace to relevant stack
/// for current application which is 10-20 call traces
///
/// defaults:
///   [stackTrace] : StackTrace.current
///   [count] : 15
///   [skip] : 1
String getTrimmedStackTrace(
    {StackTrace stackTrace, int count = 15, int skip = 1}) {
  stackTrace ??= StackTrace.current;
  return stackTrace
      .toString()
      .split('\n')
      .take(count + skip)
      .skip(skip)
      .join('\n');
}

/// Getter for easy access
StackTrace get trimmedStackTrace =>
    StackTrace.fromString(getTrimmedStackTrace(skip: 2));

/// Method to remove time after minutes part from the given [dateTime]
DateTime dateTimeUptoMinutes(DateTime dateTime) {
  return DateTime.fromMillisecondsSinceEpoch(dateTime.millisecondsSinceEpoch)
      .subtract(Duration(
    seconds: dateTime.second,
  ));
}
