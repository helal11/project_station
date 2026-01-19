import 'package:flutter/material.dart';

class StationAutocomplete extends StatelessWidget {
  final String label;
  final List<String> stations;
  final String? initialValue;
  final ValueChanged<String> onSelected;

  const StationAutocomplete({
    super.key,
    required this.label,
    required this.stations,
    required this.onSelected,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: initialValue ?? '');

    return Autocomplete<String>(
      initialValue: TextEditingValue(text: initialValue ?? ''),
      optionsBuilder: (TextEditingValue value) {
        if (value.text.isEmpty) {
          return const Iterable<String>.empty();
        }

        return stations.where(
          (s) => s.toLowerCase().contains(value.text.toLowerCase()),
        );
      },

      onSelected: (selection) {
        controller.text = selection;
        onSelected(selection);
      },

      fieldViewBuilder: (
        context,
        textEditingController,
        focusNode,
        onFieldSubmitted,
      ) {
        textEditingController.value = controller.value;

        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: const Icon(Icons.search),
            border: const OutlineInputBorder(),
          ),
        );
      },

      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            child: SizedBox(
              height: 220,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return ListTile(
                    title: Text(option),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
