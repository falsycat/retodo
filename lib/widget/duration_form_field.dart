import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DurationFormField extends StatefulWidget {
  final Duration? initial;
  final void Function(Duration dur) onChanged;

  const DurationFormField({super.key, this.initial, required this.onChanged});

  @override
  State<DurationFormField> createState() => _DurationFormFieldState();
}

class _DurationFormFieldState extends State<DurationFormField> {
  final _day = TextEditingController();
  final _hour = TextEditingController();
  final _min = TextEditingController();

  @override
  void initState() {
    super.initState();

    final initial = widget.initial;
    if (null != initial) {
      _day.text = initial.inDays.toString();
      _hour.text = (initial.inHours % 24).toString();
      _min.text = (initial.inMinutes % 60).toString();
    } else {
      _day.text = "0";
      _hour.text = "0";
      _min.text = "10";
    }

    _day.addListener(() => _notify());
    _hour.addListener(() => _notify());
    _min.addListener(() => _notify());
  }

  @override
  void dispose() {
    super.dispose();
    _day.dispose();
    _hour.dispose();
    _min.dispose();
  }

  @override
  Widget build(BuildContext context) {
    textField(TextEditingController controller, String unit) => Expanded(
          child: TextFormField(
            controller: controller,
            textAlign: TextAlign.right,
            textAlignVertical: TextAlignVertical.bottom,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) => v == "" ? "empty" : null,
            decoration: InputDecoration(
              suffix: Text(unit),
            ),
          ),
        );
    return Row(
      children: [
        textField(_day, "days"),
        const SizedBox(width: 8),
        textField(_hour, "hours"),
        const SizedBox(width: 8),
        textField(_min, "mins"),
      ],
    );
  }

  Duration _parse() => Duration(
        days: int.parse(_day.text),
        hours: int.parse(_hour.text),
        minutes: int.parse(_min.text),
      );

  void _notify() {
    late final Duration dur;
    try {
      dur = _parse();
    } catch (e) {
      return;
    }
    widget.onChanged(dur);
  }
}
