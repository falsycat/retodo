import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/feature/task_list/task_list_repository.dart';
import 'package:todo/model/task.dart';

class TaskListCubit extends Cubit<List<Task>> {
  final TaskListRepository _repository;

  TaskListCubit(this._repository) : super([]);

  void fetchAndSort() {
    final tasks = _repository.fetch();

    final sortedTasks = tasks.toList();
    sortedTasks.sort((a, b) => a.title.compareTo(b.title));
    emit(sortedTasks);
  }

  void replace(int index, Task? task) {
    if (null == task) {
      return;
    }
    _repository.remove(state[index]);
    _repository.add(task);
    fetchAndSort();
  }

  void add(Task? task) {
    if (null == task) {
      return;
    }
    _repository.add(task);
    fetchAndSort();
  }

  void remove(int index) {
    _repository.remove(state[index]);
    fetchAndSort();
  }
}
