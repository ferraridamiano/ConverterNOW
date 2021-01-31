import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:units_converter/units_converter.dart';

String getPropertyTranslation(BuildContext context, PROPERTY property) {
  Map<PROPERTY, String> propertyTranslationMap = {
    PROPERTY.ANGLE: AppLocalizations.of(context).angles,
    PROPERTY.AREA: AppLocalizations.of(context).area,
    PROPERTY.DIGITAL_DATA: AppLocalizations.of(context).digitalData,
    PROPERTY.ENERGY: AppLocalizations.of(context).energy,
    PROPERTY.FORCE: AppLocalizations.of(context).force,
    PROPERTY.FUEL_CONSUMPTION: AppLocalizations.of(context).fuelConsumption,
    PROPERTY.LENGTH: AppLocalizations.of(context).length,
    PROPERTY.MASS: AppLocalizations.of(context).mass,
    PROPERTY.NUMERAL_SYSTEMS: AppLocalizations.of(context).numeralSystems,
    PROPERTY.POWER: AppLocalizations.of(context).power,
    PROPERTY.PRESSURE: AppLocalizations.of(context).pressure,
    PROPERTY.SHOE_SIZE: AppLocalizations.of(context).shoeSize,
    PROPERTY.SI_PREFIXES: AppLocalizations.of(context).siPrefixes,
    PROPERTY.SPEED: AppLocalizations.of(context).speed,
    PROPERTY.TEMPERATURE: AppLocalizations.of(context).temperature,
    PROPERTY.TIME: AppLocalizations.of(context).time,
    PROPERTY.TORQUE: AppLocalizations.of(context).torque,
    PROPERTY.VOLUME: AppLocalizations.of(context).volume,
  };
  return propertyTranslationMap[property];
}

String getUnitTranslation(BuildContext context, var unit) {
  Map<dynamic, String> translationMap = {
    LENGTH.meters: AppLocalizations.of(context).meters,
    LENGTH.centimeters: AppLocalizations.of(context).centimeters,
    LENGTH.inches: AppLocalizations.of(context).inches,
    LENGTH.feet: AppLocalizations.of(context).feet,
    LENGTH.nautical_miles: AppLocalizations.of(context).nauticalMiles,
    LENGTH.yards: AppLocalizations.of(context).yards,
    LENGTH.miles: AppLocalizations.of(context).miles,
    LENGTH.millimeters: AppLocalizations.of(context).millimeters,
    LENGTH.micrometers: AppLocalizations.of(context).micrometers,
    LENGTH.nanometers: AppLocalizations.of(context).nanometers,
    LENGTH.angstroms: AppLocalizations.of(context).angstroms,
    LENGTH.picometers: AppLocalizations.of(context).picometers,
    LENGTH.kilometers: AppLocalizations.of(context).kilometers,
    LENGTH.astronomical_units: AppLocalizations.of(context).astronomicalUnits,
    LENGTH.light_years: AppLocalizations.of(context).lightYears,
    LENGTH.parsec: AppLocalizations.of(context).parsec,
  };
  return translationMap[unit];
}
