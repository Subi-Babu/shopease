import 'package:flutter/material.dart';
import '../model/countrycode.dart';

class CountryPickerWidget extends StatelessWidget {
  final List<CountryCode>? countries;
  final String? selectedValue;
  final Function(String?)? onChanged;
  final bool isLoading;
  final bool isError;

  const CountryPickerWidget({
    super.key,
    required this.countries,
    required this.selectedValue,
    this.onChanged,
    this.isLoading = false,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    final String? value =
        selectedValue ??
        (countries != null && countries!.isNotEmpty
            ? countries!.first.label
            : null);

    return Container(
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(10),
      //   border: Border.all(color: Colors.black12),
      // ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : isError
          ? const Text("Error")
          : DropdownButton<String>(
              value: value,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              icon: const Icon(Icons.keyboard_arrow_down),
              items: countries?.map((CountryCode item) {
                return DropdownMenuItem<String>(
                  value: item.label,
                  child: Text(
                    item.label ?? "",
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
    );
  }
}
