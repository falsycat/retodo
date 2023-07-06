import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:todo/feature/task_edit/task_edit_page.dart';
import 'package:todo/feature/task_list/task_list_cubit.dart';
import 'package:todo/feature/task_list/task_list_repository.dart';
import 'package:todo/model/task.dart';
import 'package:todo/widget/app_drawer.dart';
import 'package:todo/widget/task_list_tile.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskListCubit(Provider.of<TaskListRepository>(context))
        ..fetchAndSort(),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Task List"),
          ),
          body: BlocBuilder<TaskListCubit, List<Task>>(
            builder: (context, state) => ListView.builder(
              itemCount: state.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () async =>
                    BlocProvider.of<TaskListCubit>(context).replace(
                  index,
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TaskEditPage(initial: state[index]),
                    ),
                  ),
                ),
                child: TaskListTile(
                  task: state[index],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async => BlocProvider.of<TaskListCubit>(context).add(
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const TaskEditPage(),
                ),
              ),
            ),
            child: const Icon(Icons.add),
          ),
          drawer: const AppDrawer(
            page: AppRootPage.taskList,
          ),
        ),
      ),
    );
  }
}
