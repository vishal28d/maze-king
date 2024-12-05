import 'package:flutter/material.dart';

import '../../exports.dart';
import '../../utils/country_list.dart';

class CountryPickerDialog extends StatefulWidget {
  final List<Country> countryList;
  final Country selectedCountry;
  final ValueChanged<Country> onCountryChanged;

  const CountryPickerDialog({
    super.key,
    required this.countryList,
    required this.onCountryChanged,
    required this.selectedCountry,
  });

  @override
  CountryPickerDialogState createState() => CountryPickerDialogState();
}

class CountryPickerDialogState extends State<CountryPickerDialog> {
  late List<Country> _filteredCountries;
  late Country _selectedCountry;

  @override
  void initState() {
    _selectedCountry = widget.selectedCountry;
    _filteredCountries = widget.countryList;
    super.initState();
  }

  bool isNumeric(String s) => s.isNotEmpty && double.tryParse(s) != null;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 24, horizontal: 30),
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(0),
              child: TextFormField(
                cursorColor: AppColors.primary,
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.search,
                    color: AppColors.primary,
                  ),
                  hintText: "Search Country",
                  hintStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.3),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xffDDDEE1),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(
                      color: Color(0xffDDDEE1),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onChanged: (value) {
                  _filteredCountries = isNumeric(value) ? widget.countryList.where((country) => country.dialCode.contains(value)).toList() : widget.countryList.where((country) => country.name.toLowerCase().contains(value.toLowerCase())).toList();
                  if (mounted) setState(() {});
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _filteredCountries.length,
                separatorBuilder: (ctx, index) {
                  return Container(
                    height: 1,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.1),
                  );
                },
                itemBuilder: (ctx, index) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Text(
                    _filteredCountries[index].flag,
                  ),
                  minLeadingWidth: 15,
                  title: Text(
                    _filteredCountries[index].name,
                  ),
                  trailing: Text(
                    '+${_filteredCountries[index].dialCode}',
                  ),
                  onTap: () {
                    _selectedCountry = _filteredCountries[index];
                    widget.onCountryChanged(_selectedCountry);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
