import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_choice_chip.dart';

/// Value object returned by the filter sheet.
class PropertyFilterSelection {
  const PropertyFilterSelection({this.cityKey, this.maxPrice});

  final String? cityKey;
  final double? maxPrice;
}

/// City + max-price bottom sheet. Applies nothing until the user confirms.
class PropertyFiltersSheet extends StatefulWidget {
  const PropertyFiltersSheet({
    super.key,
    this.initialCityKey,
    this.initialMaxPrice,
  });

  final String? initialCityKey;
  final double? initialMaxPrice;

  @override
  State<PropertyFiltersSheet> createState() => _PropertyFiltersSheetState();
}

class _PropertyFiltersSheetState extends State<PropertyFiltersSheet> {
  static const List<double> _priceOptions = <double>[
    2500,
    4000,
    6000,
    10000,
    20000,
  ];

  String? _cityKey;
  double? _maxPrice;

  @override
  void initState() {
    super.initState();
    _cityKey = widget.initialCityKey;
    _maxPrice = widget.initialMaxPrice;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  height: 4,
                  width: 44,
                  decoration: BoxDecoration(
                    color: scheme.outlineVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text('filters'.tr, style: text.titleLarge),
              const SizedBox(height: 20),
              Text('filter_city'.tr, style: text.titleSmall),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  AppChoiceChip(
                    label: 'any_city'.tr,
                    selected: _cityKey == null,
                    onTap: () => setState(() => _cityKey = null),
                  ),
                  for (final String city in AppConstants.cityKeys)
                    AppChoiceChip(
                      label: 'city_$city'.tr,
                      selected: _cityKey == city,
                      onTap: () => setState(() => _cityKey = city),
                    ),
                ],
              ),
              const SizedBox(height: 22),
              Text('filter_max_price'.tr, style: text.titleSmall),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  AppChoiceChip(
                    label: 'filter_price_any'.tr,
                    selected: _maxPrice == null,
                    onTap: () => setState(() => _maxPrice = null),
                  ),
                  for (final double price in _priceOptions)
                    AppChoiceChip(
                      label: AppFormatters.price(price),
                      selected: _maxPrice == price,
                      onTap: () => setState(() => _maxPrice = price),
                    ),
                ],
              ),
              const SizedBox(height: 26),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back<PropertyFilterSelection>(
                        result: const PropertyFilterSelection(),
                      ),
                      child: Text('reset_filters'.tr),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back<PropertyFilterSelection>(
                        result: PropertyFilterSelection(
                          cityKey: _cityKey,
                          maxPrice: _maxPrice,
                        ),
                      ),
                      child: Text('apply_filters'.tr),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
