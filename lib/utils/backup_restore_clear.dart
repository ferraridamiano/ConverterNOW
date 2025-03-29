import 'dart:convert';
import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> exportSettingsBackup(SharedPreferencesWithCache prefs) async {
  final Map<String, dynamic> allPrefs = {};

  for (String key in prefs.keys) {
    final value = prefs.get(key);
    // Determine the type of value and add it to the map
    if (value is String) {
      allPrefs[key] = prefs.getString(key);
    } else if (value is bool) {
      allPrefs[key] = prefs.getBool(key);
    } else if (value is int) {
      allPrefs[key] = prefs.getInt(key);
    } else if (value is double) {
      allPrefs[key] = prefs.getDouble(key);
    } else if (value is List) {
      allPrefs[key] = prefs.getStringList(key);
    }
  }

  // Convert to JSON
  final String jsonData = jsonEncode(allPrefs);

  // Request storage permission
  if (Platform.isAndroid) {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
      if (!(await Permission.storage.status).isGranted) {
        return null;
      }
    }
  }

  final downloadsDir = await getDownloadsDirectory();
  if (downloadsDir == null) {
    return null;
  }
  if (!(await downloadsDir.exists())) {
    downloadsDir.create();
  }
  final fileName =
      '${DateFormat('yyyyMMdd').format(DateTime.now())}_converternow_backup.json';
  final backupFile =
      File("${downloadsDir.path}${Platform.pathSeparator}$fileName");
  if (!backupFile.existsSync()) {
    await backupFile.create();
  }
  await backupFile.writeAsString(jsonData);
  return backupFile.path;
}

Future<void> importSettingsBackup(SharedPreferencesWithCache prefs) async {
  final XFile? file = await openFile(
    acceptedTypeGroups: const [
      XTypeGroup(
        label: 'Backup file',
        extensions: ['json'],
      )
    ],
  );

  if (file == null) {
    return;
  }

  final String jsonData = await file.readAsString();
  final Map<String, dynamic> allPrefs = jsonDecode(jsonData);

  for (final entry in allPrefs.entries) {
    final key = entry.key;
    final value = entry.value;
    if (value is String) {
      prefs.setString(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else if (value is int) {
      prefs.setInt(key, value);
    } else if (value is double) {
      prefs.setDouble(key, value);
    } else if (value is List<String>) {
      prefs.setStringList(key, value);
    } else {
      debugPrint('Invalid entry');
    }
  }
}
