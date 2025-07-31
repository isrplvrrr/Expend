// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TasksAdapter extends TypeAdapter<Tasks> {
  @override
  final int typeId = 0;

  @override
  Tasks read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tasks(value: fields[0] as String?, notes: []);
  }

  @override
  void write(BinaryWriter writer, Tasks obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TasksAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ListsAdapter extends TypeAdapter<Lists> {
  @override
  final int typeId = 1;

  @override
  Lists read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Lists(list: (fields[0] as List).cast<String>());
  }

  @override
  void write(BinaryWriter writer, Lists obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.list);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SaveDBAdapter extends TypeAdapter<SaveDB> {
  @override
  final int typeId = 2;

  @override
  SaveDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SaveDB(tasks: fields[0] as Tasks);
  }

  @override
  void write(BinaryWriter writer, SaveDB obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.tasks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaveDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
