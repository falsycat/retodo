import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/feature/weekly_view/weekly_view_repository.dart';
import 'package:todo/model/occurrence.dart';
import 'package:todo/model/task.dart';

class WeeklyViewCubit extends Cubit<Map<DateTime, List<FixedTask>>> {
  final WeeklyViewRepository _repository;

  WeeklyViewCubit(this._repository) : super({});

  void fetch() {
    final now = Occurrence.strip(DateTime.now());
    final today = now.copyWith(hour: 0, minute: 0);

    final newState = <DateTime, List<FixedTask>>{};

    final tasks = _repository.fetch();
    for (var i = 0; i < 7; ++i) {
      final begin = today.add(Duration(days: i));
      final end = begin.add(const Duration(days: 1));
      final dayTasks = tasks
          .expand((task) => task.occurrence
              .calcAllNextUntil(begin.subtract(Occurrence.delta), end)
              .map((e) => FixedTask(task, e))
              .where((e) => !e.completed(now)))
          .toList();
      if (0 == i) {
        dayTasks.addAll(tasks
            .where((e) => null != e.occurrence.prev(begin))
            .where((e) => dayTasks.every((x) => !identical(e, x.task)))
            .map((e) => FixedTask(e, e.occurrence.prev(begin)!))
            .where((e) => !e.completed(now)));
      }
      dayTasks.sort((a, b) => a.deadline.compareTo(b.deadline));
      newState[begin] = dayTasks;
    }
    emit(newState);
  }

  void complete(FixedTask fixed) {
    _repository.remove(fixed.task);
    _repository.add(fixed.task.complete(fixed.occurs));
    fetch();
  }
}
