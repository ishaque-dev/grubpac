T sanitizeWithType<T>(dynamic value, {T? defaultValue}) {
  try {
    if (value == null || (value is String && value.trim().isEmpty)) {
      return defaultValue ?? _defaultValue<T>();
    }
    if (value is T) {
      return value;
    }
    if (T == String) return value.toString() as T;
    if (T == int) {
      return int.tryParse(value.toString()) as T? ?? defaultValue ?? 0 as T;
    }
    if (T == double) {
      return double.tryParse(value.toString()) as T? ??
          defaultValue ??
          0.0 as T;
    }
    if (T == num) {
      return num.tryParse(value.toString()) as T? ?? defaultValue ?? 0 as T;
    }
    if (T == bool) return (_parseBool(value)) as T;
    if (T == DateTime) {
      return DateTime.tryParse(value.toString()) as T? ??
          defaultValue ??
          DateTime.fromMillisecondsSinceEpoch(0) as T;
    }
    if (T == (Map<String, dynamic>) && value is Map) {
      return Map<String, dynamic>.from(value) as T;
    }
    if (T == (List<dynamic>) && value is List) {
      return List<dynamic>.from(value) as T;
    }
  } catch (_) {
    return defaultValue ?? _defaultValue<T>();
  }
  return defaultValue ?? _defaultValue<T>();
}

T _defaultValue<T>() {
  if (T == String) return '' as T;
  if (T == int) return 0 as T;
  if (T == double) return 0.0 as T;
  if (T == num) return 0 as T;
  if (T == bool) return false as T;
  if (T == DateTime) return DateTime.fromMillisecondsSinceEpoch(0) as T;
  throw UnsupportedError('No default value for type $T');
}

bool _parseBool(dynamic value) {
  final str = value.toString().toLowerCase().trim();
  return str == 'true' || str == '1' || str == 'yes';
}

String sanitize(dynamic value) {
  try {
    if (value == null || value == "null" || value.toString().isEmpty) return '';
    return value.toString();
  } catch (e) {
    return '';
  }
}
