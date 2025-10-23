import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:technical_test_project/data/models/country_model.dart'
    as StatusModel;

class SelectStatePicker extends StatefulWidget {
  final String? initialCountry;
  final String? initialState;
  final String? initialCity;
  final ValueChanged<String> onCountryChanged;
  final ValueChanged<String> onStateChanged;
  final ValueChanged<String> onCityChanged;

  const SelectStatePicker({
    super.key,
    this.initialCountry,
    this.initialState,
    this.initialCity,
    required this.onCountryChanged,
    required this.onStateChanged,
    required this.onCityChanged,
  });

  @override
  State<SelectStatePicker> createState() => _SelectStatePickerState();
}

class _SelectStatePickerState extends State<SelectStatePicker> {
  List<StatusModel.CountryModel> _countries = [];
  List<StatusModel.State> _states = [];
  List<StatusModel.City> _cities = [];

  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;

  bool _loadingCountries = true;
  bool _loadingStates = false;
  bool _loadingCities = false;

  @override
  void initState() {
    super.initState();
    _loadCountries().then((_) {
      // Si viene de edición, precargar datos
      if (widget.initialCountry?.isNotEmpty ?? false) {
        _selectedCountry = widget.initialCountry;
        _loadStates(_selectedCountry!).then((_) {
          if (widget.initialState?.isNotEmpty ?? false) {
            _selectedState = widget.initialState;
            _loadCities(_selectedState!).then((_) {
              if (widget.initialCity?.isNotEmpty ?? false) {
                setState(() => _selectedCity = widget.initialCity);
              }
            });
          }
        });
      }
    });
  }

  Future<void> _loadCountries() async {
    final data = await rootBundle.loadString(
      'assets/json/country.json',
    );
    final List decoded = jsonDecode(data);
    setState(() {
      _countries =
          decoded.map((e) => StatusModel.CountryModel.fromJson(e)).toList();
      _loadingCountries = false;
    });
  }

  Future<void> _loadStates(String countryName) async {
    setState(() {
      _loadingStates = true;
      _states = [];
      _cities = [];
      _selectedState = null;
      _selectedCity = null;
    });

    final country = _countries.firstWhere(
      (c) => c.name == countryName,
      orElse: () => StatusModel.CountryModel(),
    );

    await Future.delayed(const Duration(milliseconds: 150));
    setState(() {
      _states = country.state ?? [];
      _loadingStates = false;
    });
  }

  Future<void> _loadCities(String stateName) async {
    setState(() {
      _loadingCities = true;
      _cities = [];
      _selectedCity = null;
    });

    final state = _states.firstWhere(
      (s) => s.name == stateName,
      orElse: () => StatusModel.State(),
    );

    await Future.delayed(const Duration(milliseconds: 150));
    setState(() {
      _cities = state.city ?? [];
      _loadingCities = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDropdown(
          label: 'País',
          value: _selectedCountry,
          items: _countries.map((e) => e.name ?? '').toList(),
          loading: _loadingCountries,
          onChanged: (value) {
            if (value == null) return;
            setState(() => _selectedCountry = value);
            widget.onCountryChanged(value);
            _loadStates(value);
          },
        ),
        const SizedBox(height: 10),
        _buildDropdown(
          label: 'Estado / Provincia',
          value: _selectedState,
          items: _states.map((e) => e.name ?? '').toList(),
          loading: _loadingStates,
          onChanged: (value) {
            if (value == null) return;
            setState(() => _selectedState = value);
            widget.onStateChanged(value);
            _loadCities(value);
          },
        ),
        const SizedBox(height: 10),
        _buildDropdown(
          label: 'Ciudad',
          value: _selectedCity,
          items: _cities.map((e) => e.name ?? '').toList(),
          loading: _loadingCities,
          onChanged: (value) {
            if (value == null) return;
            setState(() => _selectedCity = value);
            widget.onCityChanged(value);
          },
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required bool loading,
    required ValueChanged<String?> onChanged,
  }) {
    if (loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return DropdownSearch<String>(
      selectedItem: value,
      // ✅ Nuevo parámetro items con firma (String, LoadProps?)
      items: (String filter, LoadProps? props) async {
        // Puedes filtrar los resultados según el texto de búsqueda
        if (filter.isEmpty) return items;
        return items
            .where((item) => item.toLowerCase().contains(filter.toLowerCase()))
            .toList();
      },
      onChanged: onChanged,
      validator: (v) => (v == null || v.isEmpty) ? 'Campo obligatorio' : null,
      popupProps: const PopupProps.menu(
        showSearchBox: true,
        title: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Selecciona una opción',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: 'Buscar...',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ),
      // decoratorProps: DropDownDecoratorProps(
      //   dropdownSearchDecoration: InputDecoration(
      //     labelText: label,
      //     border: const OutlineInputBorder(
      //       borderRadius: BorderRadius.all(Radius.circular(12)),
      //     ),
      //     filled: true,
      //     fillColor: Colors.grey[100],
      //   ),
      // ),
    );
  }

}
