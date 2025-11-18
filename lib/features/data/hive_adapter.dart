import 'package:hive/hive.dart';
import 'habit.dart';

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 0;

  @override
  Habit read(BinaryReader reader) {
    return Habit(
      habitId: reader.readString(),
      name: reader.readString(),
      description: reader.read(),
      reminderTime: reader.read(),
      isCompleted: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer.writeString(obj.habitId);
    writer.writeString(obj.name);
    writer.write(obj.description);
    writer.write(obj.reminderTime);
    writer.writeBool(obj.isCompleted);
  }
}
