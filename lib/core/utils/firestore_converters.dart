import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// Convierte entre [DateTime] y [Timestamp] de Firestore (o int en tests).
class TimestampConverter implements JsonConverter<DateTime, dynamic> {
  const TimestampConverter();

  @override
  DateTime fromJson(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) return DateTime.parse(value);
    throw ArgumentError('No se puede convertir $value a DateTime');
  }

  @override
  dynamic toJson(DateTime date) => Timestamp.fromDate(date);
}
