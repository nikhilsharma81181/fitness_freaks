import 'package:hive/hive.dart';

/// Type adapter for storing Duration objects in Hive
class DurationAdapter extends TypeAdapter<Duration> {
  @override
  final int typeId = 2;

  @override
  Duration read(BinaryReader reader) {
    final microseconds = reader.readInt();
    return Duration(microseconds: microseconds);
  }

  @override
  void write(BinaryWriter writer, Duration obj) {
    writer.writeInt(obj.inMicroseconds);
  }
}
