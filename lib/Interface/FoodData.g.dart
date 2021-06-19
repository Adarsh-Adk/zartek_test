// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FoodData.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DishCurrencyAdapter extends TypeAdapter<DishCurrency> {
  @override
  final int typeId = 1;

  @override
  DishCurrency read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DishCurrency.SAR;
      default:
        return DishCurrency.SAR;
    }
  }

  @override
  void write(BinaryWriter writer, DishCurrency obj) {
    switch (obj) {
      case DishCurrency.SAR:
        writer.writeByte(0);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DishCurrencyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AddonCatAdapter extends TypeAdapter<AddonCat> {
  @override
  final int typeId = 2;

  @override
  AddonCat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddonCat(
      addonCategory: fields[0] as String,
      addonCategoryId: fields[1] as String,
      addonSelection: fields[2] as int,
      nexturl: fields[3] as String,
      addons: (fields[4] as List)?.cast<CategoryDish>(),
    );
  }

  @override
  void write(BinaryWriter writer, AddonCat obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.addonCategory)
      ..writeByte(1)
      ..write(obj.addonCategoryId)
      ..writeByte(2)
      ..write(obj.addonSelection)
      ..writeByte(3)
      ..write(obj.nexturl)
      ..writeByte(4)
      ..write(obj.addons);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddonCatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoryDishAdapter extends TypeAdapter<CategoryDish> {
  @override
  final int typeId = 0;

  @override
  CategoryDish read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryDish(
      dishId: fields[0] as String,
      dishName: fields[1] as String,
      dishPrice: fields[2] as double,
      dishImage: fields[3] as String,
      dishCurrency: fields[4] as DishCurrency,
      dishCalories: fields[5] as double,
      dishDescription: fields[6] as String,
      dishAvailability: fields[7] as bool,
      dishType: fields[8] as int,
      nexturl: fields[9] as String,
      addonCat: (fields[10] as List)?.cast<AddonCat>(),
    );
  }

  @override
  void write(BinaryWriter writer, CategoryDish obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.dishId)
      ..writeByte(1)
      ..write(obj.dishName)
      ..writeByte(2)
      ..write(obj.dishPrice)
      ..writeByte(3)
      ..write(obj.dishImage)
      ..writeByte(4)
      ..write(obj.dishCurrency)
      ..writeByte(5)
      ..write(obj.dishCalories)
      ..writeByte(6)
      ..write(obj.dishDescription)
      ..writeByte(7)
      ..write(obj.dishAvailability)
      ..writeByte(8)
      ..write(obj.dishType)
      ..writeByte(9)
      ..write(obj.nexturl)
      ..writeByte(10)
      ..write(obj.addonCat);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryDishAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EnumValuesAdapter extends TypeAdapter<EnumValues> {
  @override
  final int typeId = 3;

  @override
  EnumValues read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EnumValues(
      (fields[0] as Map)?.cast<String, dynamic>(),
    )..reverseMap = (fields[1] as Map)?.cast<dynamic, String>();
  }

  @override
  void write(BinaryWriter writer, EnumValues obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.map)
      ..writeByte(1)
      ..write(obj.reverseMap)
      ..writeByte(2)
      ..write(obj.reverse);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnumValuesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
