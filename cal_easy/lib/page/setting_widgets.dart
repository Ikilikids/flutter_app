import 'package:common/common.dart';
import 'package:flutter/material.dart';

Widget buildNumberButtonTile(
    BuildContext context, String currentValue, Function onChanged) {
  final value = currentValue;

  String label;
  switch (value) {
    case 'calculator':
      label = l10n(context, "calculatorMode");
      break;
    case 'mobile':
    default:
      label = l10n(context, "mobileMode");
  }

  return ListTile(
    leading: const Icon(Icons.onetwothree),
    title: Text(l10n(context, "buttonLayout")),
    subtitle: Text(label),
    onTap: () => _showNumberPicker(context, onChanged),
  );
}

Future<void> _showNumberPicker(BuildContext context, Function onChanged) async {
  final result = await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(l10n(context, "selectButtonLayout")),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => Navigator.pop(context, 'mobile'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n(context, "mobileMode")),
                  const SizedBox(height: 8),
                  _numberLayoutPreview(mobileLayout),
                ],
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => Navigator.pop(context, 'calculator'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n(context, "calculatorMode")),
                  const SizedBox(height: 8),
                  _numberLayoutPreview(calculatorLayout),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );

  if (result != null) {
    onChanged(result);
  }
}

Widget _numberLayoutPreview(List<int?> layout) {
  return Table(
    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
    children: List.generate(4, (row) {
      return TableRow(
        children: List.generate(3, (col) {
          final value = layout[row * 3 + col];
          return Padding(
            padding: const EdgeInsets.all(4),
            child: Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: value == null
                  ? const SizedBox.shrink()
                  : Text(
                      value.toString(),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          );
        }),
      );
    }),
  );
}

final mobileLayout = [
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  null,
  0,
  null,
];

final calculatorLayout = [
  7,
  8,
  9,
  4,
  5,
  6,
  1,
  2,
  3,
  null,
  0,
  null,
];
Widget buildSectionHeader(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 8.0),
    child: Text(
      l10n(context, "detailSetting"),
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
