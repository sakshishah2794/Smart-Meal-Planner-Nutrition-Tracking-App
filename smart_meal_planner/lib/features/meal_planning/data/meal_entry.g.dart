// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MealEntryAdapter extends TypeAdapter<MealEntry> {
  @override
  final int typeId = 1;

  @override
  MealEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MealEntry(
      id: fields[0] as String,
      foodItemId: fields[1] as String,
      foodName: fields[2] as String,
      quantity: fields[3] as double,
      mealType: fields[4] as String,
      date: fields[5] as DateTime,
      calories: fields[6] as double,
      protein: fields[7] as double,
      carbs: fields[8] as double,
      fats: fields[9] as double,
      isSynced: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MealEntry obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.foodItemId)
      ..writeByte(2)
      ..write(obj.foodName)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.mealType)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.calories)
      ..writeByte(7)
      ..write(obj.protein)
      ..writeByte(8)
      ..write(obj.carbs)
      ..writeByte(9)
      ..write(obj.fats)
      ..writeByte(10)
      ..write(obj.isSynced);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

  @override
  int get hashCode => typeId.hashCode;
}
