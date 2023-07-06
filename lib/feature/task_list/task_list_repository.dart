import 'package:todo/model/task.dart';

abstract class TaskListRepository {
  Set<Task> fetch();
  void add(Task task);
  void remove(Task task);
}
