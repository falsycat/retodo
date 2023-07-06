import 'package:todo/model/task.dart';

abstract class WeeklyViewRepository {
  Set<Task> fetch();
  void add(Task task);
  void remove(Task task);
}
