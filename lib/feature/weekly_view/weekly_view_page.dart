import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:todo/feature/weekly_view/weekly_view_cubit.dart';
import 'package:todo/feature/weekly_view/weekly_view_repository.dart';
import 'package:todo/model/task.dart';
import 'package:todo/widget/app_drawer.dart';
import 'package:todo/widget/fixed_task_list_tile.dart';

class WeeklyViewPage extends StatelessWidget {
  static const dayNames = <String>[
    "Sun",
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
  ];

  const WeeklyViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return BlocProvider(
      create: (_) =>
          WeeklyViewCubit(Provider.of<WeeklyViewRepository>(context))..fetch(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Weekly View"),
        ),
        body: Column(
          children: [
            Expanded(
              child:
                  BlocBuilder<WeeklyViewCubit, Map<DateTime, List<FixedTask>>>(
                builder: (context, state) => ListView.separated(
                  separatorBuilder: (_, __) => const Divider(
                    height: 0,
                  ),
                  itemCount: state.length,
                  itemBuilder: (context, index) {
                    final date = state.keys.skip(index).first;
                    final tasks = state.values.skip(index).first;
                    return InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                              child: RotatedBox(
                                quarterTurns: 1,
                                child: Text(
                                  dayNames[date.weekday % 7],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: tasks.isNotEmpty
                                    ? tasks
                                        .map(
                                          (e) => InkWell(
                                            onTap: () {},
                                            onLongPress: e.active(now)
                                                ? () => BlocProvider.of<
                                                            WeeklyViewCubit>(
                                                        context)
                                                    .complete(e)
                                                : null,
                                            child: FixedTaskListTile(fixed: e),
                                          ),
                                        )
                                        .toList()
                                    : [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              16.0, 8, 0, 8),
                                          child: Text(
                                            index == 0
                                                ? "ALL DONE! X)"
                                                : "NOTHING",
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        )
                                      ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        drawer: const AppDrawer(
          page: AppRootPage.weeklyView,
        ),
      ),
    );
  }
}
