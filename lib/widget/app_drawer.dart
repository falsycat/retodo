import 'package:flutter/material.dart';
import 'package:todo/feature/task_list/task_list_page.dart';
import 'package:todo/feature/weekly_view/weekly_view_page.dart';

enum AppRootPage {
  taskList,
  weeklyView,
}

class AppDrawer extends StatelessWidget {
  final AppRootPage page;

  const AppDrawer({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          InkWell(
            onTap: AppRootPage.taskList != page
                ? () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const TaskListPage(),
                      ),
                    )
                : null,
            child: const ListTile(
              title: Text("task list"),
            ),
          ),
          InkWell(
            onTap: AppRootPage.weeklyView != page
                ? () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const WeeklyViewPage(),
                      ),
                    )
                : null,
            child: const ListTile(
              title: Text("weekly view"),
            ),
          ),
        ],
      ),
    );
  }
}
