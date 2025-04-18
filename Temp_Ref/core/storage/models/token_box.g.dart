// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_box.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TokenBoxAdapter extends TypeAdapter<TokenBox> {
  @override
  final int typeId = 1;

  @override
  TokenBox read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TokenBox(
      accessToken: fields[0] as String,
      refreshToken: fields[1] as String?,
      expiryTime: fields[2] as DateTime?,
      createdAt: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, TokenBox obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.accessToken)
      ..writeByte(1)
      ..write(obj.refreshToken)
      ..writeByte(2)
      ..write(obj.expiryTime)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TokenBoxAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
