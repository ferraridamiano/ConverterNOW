import 'package:units_converter/models/property.dart';
import 'package:units_converter/models/unit.dart';

/// Consolidated timezone units grouped by UTC offset
enum TIMEZONE {
  utcMinus12,
  utcMinus11,
  utcMinus10,
  utcMinus9_30,
  utcMinus9,
  utcMinus8,
  utcMinus7,
  utcMinus6,
  utcMinus5,
  utcMinus4,
  utcMinus3_30,
  utcMinus3,
  utcMinus2,
  utcMinus1,
  utc0,
  utcPlus1,
  utcPlus2,
  utcPlus3,
  utcPlus3_30,
  utcPlus4,
  utcPlus4_30,
  utcPlus5,
  utcPlus5_30,
  utcPlus5_45,
  utcPlus6,
  utcPlus6_30,
  utcPlus7,
  utcPlus8,
  utcPlus8_45,
  utcPlus9,
  utcPlus9_30,
  utcPlus10,
  utcPlus10_30,
  utcPlus11,
  utcPlus12,
  utcPlus12_45,
  utcPlus13,
  utcPlus14,
}

class TimeZoneProperty extends Property<TIMEZONE, String> {
  static const Map<TIMEZONE, String> mapSymbols = {
    TIMEZONE.utcMinus12: 'UTC-12',
    TIMEZONE.utcMinus11: 'UTC-11',
    TIMEZONE.utcMinus10: 'UTC-10',
    TIMEZONE.utcMinus9_30: 'UTC-09:30',
    TIMEZONE.utcMinus9: 'UTC-09',
    TIMEZONE.utcMinus8: 'UTC-08',
    TIMEZONE.utcMinus7: 'UTC-07',
    TIMEZONE.utcMinus6: 'UTC-06',
    TIMEZONE.utcMinus5: 'UTC-05',
    TIMEZONE.utcMinus4: 'UTC-04',
    TIMEZONE.utcMinus3_30: 'UTC-03:30',
    TIMEZONE.utcMinus3: 'UTC-03',
    TIMEZONE.utcMinus2: 'UTC-02',
    TIMEZONE.utcMinus1: 'UTC-01',
    TIMEZONE.utc0: 'UTC+0',
    TIMEZONE.utcPlus1: 'UTC+01',
    TIMEZONE.utcPlus2: 'UTC+02',
    TIMEZONE.utcPlus3: 'UTC+03',
    TIMEZONE.utcPlus3_30: 'UTC+03:30',
    TIMEZONE.utcPlus4: 'UTC+04',
    TIMEZONE.utcPlus4_30: 'UTC+04:30',
    TIMEZONE.utcPlus5: 'UTC+05',
    TIMEZONE.utcPlus5_30: 'UTC+05:30',
    TIMEZONE.utcPlus5_45: 'UTC+05:45',
    TIMEZONE.utcPlus6: 'UTC+06',
    TIMEZONE.utcPlus6_30: 'UTC+06:30',
    TIMEZONE.utcPlus7: 'UTC+07',
    TIMEZONE.utcPlus8: 'UTC+08',
    TIMEZONE.utcPlus8_45: 'UTC+08:45',
    TIMEZONE.utcPlus9: 'UTC+09',
    TIMEZONE.utcPlus9_30: 'UTC+09:30',
    TIMEZONE.utcPlus10: 'UTC+10',
    TIMEZONE.utcPlus10_30: 'UTC+10:30',
    TIMEZONE.utcPlus11: 'UTC+11',
    TIMEZONE.utcPlus12: 'UTC+12',
    TIMEZONE.utcPlus12_45: 'UTC+12:45',
    TIMEZONE.utcPlus13: 'UTC+13',
    TIMEZONE.utcPlus14: 'UTC+14',
  };

  /// Offset from UTC in minutes
  static const Map<TIMEZONE, int> _offsetMinutes = {
    TIMEZONE.utcMinus12: -720,
    TIMEZONE.utcMinus11: -660,
    TIMEZONE.utcMinus10: -600,
    TIMEZONE.utcMinus9_30: -570,
    TIMEZONE.utcMinus9: -540,
    TIMEZONE.utcMinus8: -480,
    TIMEZONE.utcMinus7: -420,
    TIMEZONE.utcMinus6: -360,
    TIMEZONE.utcMinus5: -300,
    TIMEZONE.utcMinus4: -240,
    TIMEZONE.utcMinus3_30: -210,
    TIMEZONE.utcMinus3: -180,
    TIMEZONE.utcMinus2: -120,
    TIMEZONE.utcMinus1: -60,
    TIMEZONE.utc0: 0,
    TIMEZONE.utcPlus1: 60,
    TIMEZONE.utcPlus2: 120,
    TIMEZONE.utcPlus3: 180,
    TIMEZONE.utcPlus3_30: 210,
    TIMEZONE.utcPlus4: 240,
    TIMEZONE.utcPlus4_30: 270,
    TIMEZONE.utcPlus5: 300,
    TIMEZONE.utcPlus5_30: 330,
    TIMEZONE.utcPlus5_45: 345,
    TIMEZONE.utcPlus6: 360,
    TIMEZONE.utcPlus6_30: 390,
    TIMEZONE.utcPlus7: 420,
    TIMEZONE.utcPlus8: 480,
    TIMEZONE.utcPlus8_45: 525,
    TIMEZONE.utcPlus9: 540,
    TIMEZONE.utcPlus9_30: 570,
    TIMEZONE.utcPlus10: 600,
    TIMEZONE.utcPlus10_30: 630,
    TIMEZONE.utcPlus11: 660,
    TIMEZONE.utcPlus12: 720,
    TIMEZONE.utcPlus12_45: 765,
    TIMEZONE.utcPlus13: 780,
    TIMEZONE.utcPlus14: 840,
  };

  final List<Unit> _unitList = [];

  TimeZoneProperty({dynamic name}) {
    this.name = name;
    size = TIMEZONE.values.length;
    mapSymbols.forEach(
      (key, value) => _unitList.add(Unit(key, symbol: value)),
    );
  }

  @override
  void convert(TIMEZONE name, String? value) {
    if (value == null) {
      for (Unit unit in _unitList) {
        unit.value = null;
        unit.stringValue = null;
      }
      return;
    }

    final parts = value.split(':');
    if (parts.length != 2) return;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null ||
        minute == null ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59) {
      return;
    }

    final sourceTotalMinutes = hour * 60 + minute;
    final sourceOffset = _offsetMinutes[name]!;

    for (var unit in _unitList) {
      if (unit.name == name) {
        unit.stringValue = value;
      } else {
        final targetOffset = _offsetMinutes[unit.name as TIMEZONE]!;
        var targetTotalMinutes =
            sourceTotalMinutes + (targetOffset - sourceOffset);
        targetTotalMinutes = targetTotalMinutes % (24 * 60);
        if (targetTotalMinutes < 0) {
          targetTotalMinutes += 24 * 60;
        }
        final targetHour = targetTotalMinutes ~/ 60;
        final targetMinute = targetTotalMinutes % 60;
        unit.stringValue =
            '${targetHour.toString().padLeft(2, '0')}:${targetMinute.toString().padLeft(2, '0')}';
      }
    }
  }

  @override
  List<Unit> getAll() => _unitList;

  @override
  Unit getUnit(var name) =>
      _unitList.where((element) => element.name == name).single;
}
