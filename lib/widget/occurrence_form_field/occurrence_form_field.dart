import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/model/occurrence.dart';
import 'package:todo/widget/occurrence_form_field/occurrence_form_field_cubit.dart';

class OccurrenceFormField extends StatelessWidget {
  static final dateFormat = DateFormat("yyyy-MM-dd");
  static final timeFormat = DateFormat("hh:mm");

  final Occurrence? initial;
  final void Function(Occurrence v) onChanged;

  static Occurrence oneshot() => OccurrenceOneshot(DateTime.now());
  static Occurrence daily() => const OccurrenceDaily(Time(0, 0));
  static Occurrence weekly() => const OccurrenceWeekly(0, Time(0, 0));

  static final types = <Type, Function>{
    OccurrenceOneshot: oneshot,
    OccurrenceDaily: daily,
    OccurrenceWeekly: weekly,
  };

  const OccurrenceFormField({super.key, this.initial, required this.onChanged});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => OccurrenceFormFieldCubit(initial ?? oneshot()),
        child: BlocListener<OccurrenceFormFieldCubit, Occurrence>(
          listener: (_, state) => onChanged(state),
          child: BlocBuilder<OccurrenceFormFieldCubit, Occurrence>(
            builder: (context, state) => Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    validator: (a) =>
                        null == a ? "no occurrence selected" : null,
                    value:
                        null != initial ? types[initial.runtimeType] : oneshot,
                    items: const [
                      DropdownMenuItem(
                        value: oneshot,
                        child: Text("oneshot"),
                      ),
                      DropdownMenuItem(
                        value: daily,
                        child: Text("daily"),
                      ),
                      DropdownMenuItem(
                        value: weekly,
                        child: Text("weekly"),
                      ),
                    ],
                    onChanged: (a) => null != a
                        ? BlocProvider.of<OccurrenceFormFieldCubit>(context)
                            .set(a())
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                ...(state is OccurrenceOneshot
                    ? [
                        ElevatedButton(
                          child: Text(dateFormat.format(state.date)),
                          onPressed: () => _showDatePicker(
                            context: context,
                            initial: state.date,
                            factory: OccurrenceOneshot.new,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          child: Text(timeFormat.format(state.date)),
                          onPressed: () => _showTimePicker(
                            context: context,
                            initial: TimeOfDay.fromDateTime(state.date),
                            factory: (a) => OccurrenceOneshot(DateTime(
                                state.date.year,
                                state.date.month,
                                state.date.day,
                                a.hour,
                                a.minute)),
                          ),
                        ),
                      ]
                    : state is OccurrenceDaily
                        ? [
                            ElevatedButton(
                              child: Text(state.time.toString()),
                              onPressed: () => _showTimePicker(
                                context: context,
                                initial: TimeOfDay(
                                  hour: state.time.h,
                                  minute: state.time.m,
                                ),
                                factory: (a) =>
                                    OccurrenceDaily(Time(a.hour, a.minute)),
                              ),
                            ),
                          ]
                        : state is OccurrenceWeekly
                            ? [
                                Expanded(
                                  child: DropdownButtonFormField<int>(
                                    onChanged: (a) => BlocProvider.of<
                                            OccurrenceFormFieldCubit>(context)
                                        .set(OccurrenceWeekly(a!, state.time)),
                                    value: 0,
                                    items: Iterable.generate(7, (i) => i)
                                        .map(
                                          (i) => DropdownMenuItem(
                                              value: i,
                                              child: Text(OccurrenceWeekly
                                                  .weekdayNames[i])),
                                        )
                                        .toList(),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  child: Text(state.time.toString()),
                                  onPressed: () => _showTimePicker(
                                    context: context,
                                    initial: TimeOfDay(
                                      hour: state.time.h,
                                      minute: state.time.m,
                                    ),
                                    factory: (a) => OccurrenceWeekly(
                                        state.weekday, Time(a.hour, a.minute)),
                                  ),
                                ),
                              ]
                            : []),
              ],
            ),
          ),
        ),
      );

  void _showDatePicker({
    required BuildContext context,
    required DateTime initial,
    required Occurrence Function(DateTime date) factory,
  }) async {
    final cubit = BlocProvider.of<OccurrenceFormFieldCubit>(context);
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 100)),
    );
    if (null != date) {
      cubit.set(factory(date));
    }
  }

  void _showTimePicker({
    required BuildContext context,
    required TimeOfDay initial,
    required Occurrence Function(TimeOfDay date) factory,
  }) async {
    final cubit = BlocProvider.of<OccurrenceFormFieldCubit>(context);
    final time = await showTimePicker(
      context: context,
      initialTime: initial,
    );
    if (null != time) {
      cubit.set(factory(time));
    }
  }
}
