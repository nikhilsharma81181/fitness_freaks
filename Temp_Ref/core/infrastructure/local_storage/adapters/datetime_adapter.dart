import 'package:hive/hive.dart';

/// Type adapter for storing DateTime objects in Hive
class DateTimeAdapter extends TypeAdapter<DateTime> {
  @override
  final int typeId = 1;

  @override
  DateTime read(BinaryReader reader) {
    final timestamp = reader.readInt();
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  @override
  void write(BinaryWriter writer, DateTime obj) {
    writer.writeInt(obj.millisecondsSinceEpoch);
  }
}
