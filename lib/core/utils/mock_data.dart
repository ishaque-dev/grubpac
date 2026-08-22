import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:grubpac/core/constants/app_strings.dart';
import 'package:grubpac/core/utils/parsing_santizer.dart';

abstract final class MockApiResponse {
  static Future<Map<String, dynamic>>? _dataFuture;

  static Future<Map<String, dynamic>> load() {
    return _dataFuture ??= _read();
  }

  static Future<Map<String, dynamic>> _read() async {
    final jsonString = await rootBundle.loadString(
      AppInternalStrings.mockDataAsset,
    );

    try {
      return sanitizeWithType<Map<String, dynamic>>(
        jsonDecode(jsonString),
        defaultValue: <String, dynamic>{},
      );
    } on FormatException {
      return <String, dynamic>{};
    }
  }
}
