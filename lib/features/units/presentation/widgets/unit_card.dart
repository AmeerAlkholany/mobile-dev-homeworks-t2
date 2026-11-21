import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../domain/entities/unit_entity.dart';
import 'unit_status_badge.dart';
import 'unit_type_avatar.dart';

class UnitCard extends StatelessWidget {
  const UnitCard({super.key, required this.unit, required this.onTap});

  final UnitEntity unit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    final List<String> specs = <String>[
      '${'floor'.tr} ${unit.floor}',
      if (unit.bedrooms > 0) '${unit.bedrooms} ${'bedrooms'.tr}',
      if (unit.areaSqm > 0) '${AppFormatters.amount(unit.areaSqm)} ${'sqm'.tr}',
    ];

    return AppCard(
      padding: const EdgeInsets.all(14),
      onTap: onTap,
      child: Row(
        children: <Widget>[
          UnitTypeAvatar(type: unit.type),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        '${'unit'.tr} ${unit.unitNumber}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.titleSmall,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        unit.type.localizationKey.tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  specs.join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              UnitStatusBadge(status: unit.status),
              const SizedBox(height: 8),
              Text(
                AppFormatters.price(unit.monthlyRent),
                style: text.titleSmall?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
