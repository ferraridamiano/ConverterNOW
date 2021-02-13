import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:units_converter/units_converter.dart';
import 'Utils.dart';

/// This will return the list of [PropertyUi], an objext that contains all the data regarding the displaying of the
/// property all over the app. From this List depends also other functions.
List<PropertyUi> getPropertyUiList(BuildContext context) {
  const String basePath = 'resources/images/';

  List<PropertyUi> propertyUiList = [];
  //The order is important!
  propertyUiList.add(PropertyUi(PROPERTYX.LENGTH, AppLocalizations.of(context).length, basePath + 'length.png'));
  propertyUiList.add(PropertyUi(PROPERTYX.AREA, AppLocalizations.of(context).area, basePath + 'area.png'));
  propertyUiList.add(PropertyUi(PROPERTYX.VOLUME, AppLocalizations.of(context).volume, basePath + 'volume.png'));
  propertyUiList.add(PropertyUi(PROPERTYX.CURRENCIES, AppLocalizations.of(context).currencies, basePath + 'currencies.png'));
  propertyUiList.add(PropertyUi(PROPERTYX.TIME, AppLocalizations.of(context).time, basePath + 'time.png'));
  propertyUiList.add(PropertyUi(PROPERTYX.TEMPERATURE, AppLocalizations.of(context).temperature, basePath + 'temperature.png'));
  propertyUiList.add(PropertyUi(PROPERTYX.SPEED, AppLocalizations.of(context).speed, basePath + 'speed.png'));
  propertyUiList.add(PropertyUi(PROPERTYX.MASS, AppLocalizations.of(context).mass, basePath + 'mass.png'));
  propertyUiList.add(PropertyUi(PROPERTYX.FORCE, AppLocalizations.of(context).force, basePath + 'force.png'));
  propertyUiList.add(PropertyUi(PROPERTYX.FUEL_CONSUMPTION, AppLocalizations.of(context).fuelConsumption, basePath + 'fuel.png'));
  propertyUiList.add(PropertyUi(PROPERTYX.NUMERAL_SYSTEMS, AppLocalizations.of(context).numeralSystems, basePath + 'num_systems.png'));
  propertyUiList.add(PropertyUi(PROPERTYX.PRESSURE, AppLocalizations.of(context).pressure, basePath + 'pressure.png'));
  propertyUiList.add(PropertyUi(PROPERTYX.ENERGY, AppLocalizations.of(context).energy, basePath + 'energy.png'));
  propertyUiList.add(PropertyUi(PROPERTYX.POWER, AppLocalizations.of(context).power, basePath + 'power.png'));
  propertyUiList.add(PropertyUi(PROPERTYX.ANGLE, AppLocalizations.of(context).angles, basePath + 'angles.png'));
  propertyUiList.add(PropertyUi(PROPERTYX.SHOE_SIZE, AppLocalizations.of(context).shoeSize, basePath + 'shoe_size.png'));
  propertyUiList.add(PropertyUi(PROPERTYX.DIGITAL_DATA, AppLocalizations.of(context).digitalData, basePath + 'data.png'));
  propertyUiList.add(PropertyUi(PROPERTYX.SI_PREFIXES, AppLocalizations.of(context).siPrefixes, basePath + 'prefixes.png'));
  propertyUiList.add(PropertyUi(PROPERTYX.TORQUE, AppLocalizations.of(context).torque, basePath + 'torque.png'));

  return propertyUiList;
}

/// This method will return a map of Property name translated: {PROPERTYX.LENGTH: 'Length', ...}
Map<PROPERTYX, String> getPropertyTranslationMap(BuildContext context) {
  List<PropertyUi> propertyUiList = getPropertyUiList(context);
  Map<PROPERTYX, String> propertyTranslationMap = {};

  for (PropertyUi propertyUi in propertyUiList) {
    propertyTranslationMap.putIfAbsent(propertyUi.property, () => propertyUi.name);
  }

  return propertyTranslationMap;
}

/// This method will return the list of Property name translated: ['Length', 'Area', 'Volume', ...]
List<String> getPropertyNameList(BuildContext context) {
  return getPropertyTranslationMap(context).values.toList();
}

/// This will return the list of [UnitUi], an objext that contains all the data regarding the displaying of the
/// units all over the app. From this List depends also other functions.
List<UnitUi> getUnitUiList(BuildContext context) {
  const String basePath = 'resources/images/';
  List<UnitUi> unitUiList = [];

  unitUiList.add(UnitUi(LENGTH.meters, AppLocalizations.of(context).meters, basePath + 'length.png', PROPERTYX.LENGTH));
  unitUiList.add(UnitUi(LENGTH.centimeters, AppLocalizations.of(context).centimeters, basePath + 'length.png', PROPERTYX.LENGTH));
  unitUiList.add(UnitUi(LENGTH.inches, AppLocalizations.of(context).inches, basePath + 'length.png', PROPERTYX.LENGTH));
  unitUiList.add(UnitUi(LENGTH.feet, AppLocalizations.of(context).feet, basePath + 'length.png', PROPERTYX.LENGTH));
  unitUiList.add(UnitUi(LENGTH.nautical_miles, AppLocalizations.of(context).nauticalMiles, basePath + 'length.png', PROPERTYX.LENGTH));
  unitUiList.add(UnitUi(LENGTH.yards, AppLocalizations.of(context).yards, basePath + 'length.png', PROPERTYX.LENGTH));
  unitUiList.add(UnitUi(LENGTH.miles, AppLocalizations.of(context).miles, basePath + 'length.png', PROPERTYX.LENGTH));
  unitUiList.add(UnitUi(LENGTH.millimeters, AppLocalizations.of(context).millimeters, basePath + 'length.png', PROPERTYX.LENGTH));
  unitUiList.add(UnitUi(LENGTH.micrometers, AppLocalizations.of(context).micrometers, basePath + 'length.png', PROPERTYX.LENGTH));
  unitUiList.add(UnitUi(LENGTH.nanometers, AppLocalizations.of(context).nanometers, basePath + 'length.png', PROPERTYX.LENGTH));
  unitUiList.add(UnitUi(LENGTH.angstroms, AppLocalizations.of(context).angstroms, basePath + 'length.png', PROPERTYX.LENGTH));
  unitUiList.add(UnitUi(LENGTH.picometers, AppLocalizations.of(context).picometers, basePath + 'length.png', PROPERTYX.LENGTH));
  unitUiList.add(UnitUi(LENGTH.kilometers, AppLocalizations.of(context).kilometers, basePath + 'length.png', PROPERTYX.LENGTH));
  unitUiList.add(UnitUi(LENGTH.astronomical_units, AppLocalizations.of(context).astronomicalUnits, basePath + 'length.png', PROPERTYX.LENGTH));
  unitUiList.add(UnitUi(LENGTH.light_years, AppLocalizations.of(context).lightYears, basePath + 'length.png', PROPERTYX.LENGTH));
  unitUiList.add(UnitUi(LENGTH.parsec, AppLocalizations.of(context).parsec, basePath + 'length.png', PROPERTYX.LENGTH));
  unitUiList.add(UnitUi(AREA.square_meters, AppLocalizations.of(context).squareMeters, basePath + 'area.png', PROPERTYX.AREA));
  unitUiList.add(UnitUi(AREA.square_centimeters, AppLocalizations.of(context).squareCentimeters, basePath + 'area.png', PROPERTYX.AREA));
  unitUiList.add(UnitUi(AREA.square_inches, AppLocalizations.of(context).squareInches, basePath + 'area.png', PROPERTYX.AREA));
  unitUiList.add(UnitUi(AREA.square_feet, AppLocalizations.of(context).squareFeet, basePath + 'area.png', PROPERTYX.AREA));
  unitUiList.add(UnitUi(AREA.square_miles, AppLocalizations.of(context).squareMiles, basePath + 'area.png', PROPERTYX.AREA));
  unitUiList.add(UnitUi(AREA.square_yard, AppLocalizations.of(context).squareYard, basePath + 'area.png', PROPERTYX.AREA));
  unitUiList.add(UnitUi(AREA.square_millimeters, AppLocalizations.of(context).squareMillimeters, basePath + 'area.png', PROPERTYX.AREA));
  unitUiList.add(UnitUi(AREA.square_kilometers, AppLocalizations.of(context).squareKilometers, basePath + 'area.png', PROPERTYX.AREA));
  unitUiList.add(UnitUi(AREA.hectares, AppLocalizations.of(context).hectares, basePath + 'area.png', PROPERTYX.AREA));
  unitUiList.add(UnitUi(AREA.acres, AppLocalizations.of(context).acres, basePath + 'area.png', PROPERTYX.AREA));
  unitUiList.add(UnitUi(AREA.are, AppLocalizations.of(context).are, basePath + 'area.png', PROPERTYX.AREA));
  unitUiList.add(UnitUi(VOLUME.cubic_meters, AppLocalizations.of(context).cubicMeters, basePath + 'volume.png', PROPERTYX.VOLUME));
  unitUiList.add(UnitUi(VOLUME.liters, AppLocalizations.of(context).liters, basePath + 'volume.png', PROPERTYX.VOLUME));
  unitUiList.add(UnitUi(VOLUME.imperial_gallons, AppLocalizations.of(context).imperialGallons, basePath + 'volume.png', PROPERTYX.VOLUME));
  unitUiList.add(UnitUi(VOLUME.us_gallons, AppLocalizations.of(context).usGallons, basePath + 'volume.png', PROPERTYX.VOLUME));
  unitUiList.add(UnitUi(VOLUME.imperial_pints, AppLocalizations.of(context).imperialPints, basePath + 'volume.png', PROPERTYX.VOLUME));
  unitUiList.add(UnitUi(VOLUME.us_pints, AppLocalizations.of(context).usPints, basePath + 'volume.png', PROPERTYX.VOLUME));
  unitUiList.add(UnitUi(VOLUME.milliliters, AppLocalizations.of(context).milliliters, basePath + 'volume.png', PROPERTYX.VOLUME));
  unitUiList.add(UnitUi(VOLUME.tablespoons_us, AppLocalizations.of(context).tablespoonUs, basePath + 'volume.png', PROPERTYX.VOLUME));
  unitUiList.add(UnitUi(VOLUME.australian_tablespoons, AppLocalizations.of(context).tablespoonAustralian, basePath + 'volume.png', PROPERTYX.VOLUME));
  unitUiList.add(UnitUi(VOLUME.cups, AppLocalizations.of(context).cups, basePath + 'volume.png', PROPERTYX.VOLUME));
  unitUiList.add(UnitUi(VOLUME.cubic_centimeters, AppLocalizations.of(context).cubicCentimeters, basePath + 'volume.png', PROPERTYX.VOLUME));
  unitUiList.add(UnitUi(VOLUME.cubic_feet, AppLocalizations.of(context).cubicFeet, basePath + 'volume.png', PROPERTYX.VOLUME));
  unitUiList.add(UnitUi(VOLUME.cubic_inches, AppLocalizations.of(context).cubicInches, basePath + 'volume.png', PROPERTYX.VOLUME));
  unitUiList.add(UnitUi(VOLUME.cubic_millimeters, AppLocalizations.of(context).cubicMillimeters, basePath + 'volume.png', PROPERTYX.VOLUME));
  unitUiList.add(UnitUi(CURRENCIES.EUR, AppLocalizations.of(context).eur, basePath + 'currencies.png', PROPERTYX.CURRENCIES));
  unitUiList.add(UnitUi(CURRENCIES.CAD, AppLocalizations.of(context).cad, basePath + 'currencies.png', PROPERTYX.CURRENCIES));
  unitUiList.add(UnitUi(CURRENCIES.HKD, AppLocalizations.of(context).hkd, basePath + 'currencies.png', PROPERTYX.CURRENCIES));
  unitUiList.add(UnitUi(CURRENCIES.RUB, AppLocalizations.of(context).rub, basePath + 'currencies.png', PROPERTYX.CURRENCIES));
  unitUiList.add(UnitUi(CURRENCIES.PHP, AppLocalizations.of(context).php, basePath + 'currencies.png', PROPERTYX.CURRENCIES));
  unitUiList.add(UnitUi(CURRENCIES.DKK, AppLocalizations.of(context).dkk, basePath + 'currencies.png', PROPERTYX.CURRENCIES));
  unitUiList.add(UnitUi(CURRENCIES.NZD, AppLocalizations.of(context).nzd, basePath + 'currencies.png', PROPERTYX.CURRENCIES));
  unitUiList.add(UnitUi(CURRENCIES.CNY, AppLocalizations.of(context).cny, basePath + 'currencies.png', PROPERTYX.CURRENCIES));
  unitUiList.add(UnitUi(CURRENCIES.AUD, AppLocalizations.of(context).aud, basePath + 'currencies.png', PROPERTYX.CURRENCIES));
  unitUiList.add(UnitUi(CURRENCIES.RON, AppLocalizations.of(context).ron, basePath + 'currencies.png', PROPERTYX.CURRENCIES));
  unitUiList.add(UnitUi(CURRENCIES.SEK, AppLocalizations.of(context).sek, basePath + 'currencies.png', PROPERTYX.CURRENCIES));
  unitUiList.add(UnitUi(CURRENCIES.IDR, AppLocalizations.of(context).idr, basePath + 'currencies.png', PROPERTYX.CURRENCIES));
  unitUiList.add(UnitUi(CURRENCIES.INR, AppLocalizations.of(context).inr, basePath + 'currencies.png', PROPERTYX.CURRENCIES));
  unitUiList.add(UnitUi(CURRENCIES.BRL, AppLocalizations.of(context).brl, basePath + 'currencies.png', PROPERTYX.CURRENCIES));
  unitUiList.add(UnitUi(CURRENCIES.USD, AppLocalizations.of(context).usd, basePath + 'currencies.png', PROPERTYX.CURRENCIES));
  unitUiList.add(UnitUi(CURRENCIES.ILS, AppLocalizations.of(context).ils, basePath + 'currencies.png', PROPERTYX.CURRENCIES));
  unitUiList.add(UnitUi(CURRENCIES.JPY, AppLocalizations.of(context).jpy, basePath + 'currencies.png', PROPERTYX.CURRENCIES));
  unitUiList.add(UnitUi(CURRENCIES.THB, AppLocalizations.of(context).thb, basePath + 'currencies.png', PROPERTYX.CURRENCIES));
  unitUiList.add(UnitUi(CURRENCIES.CHF, AppLocalizations.of(context).chf, basePath + 'currencies.png', PROPERTYX.CURRENCIES));
  unitUiList.add(UnitUi(CURRENCIES.CZK, AppLocalizations.of(context).czk, basePath + 'currencies.png', PROPERTYX.CURRENCIES));
  unitUiList.add(UnitUi(CURRENCIES.MYR, AppLocalizations.of(context).myr, basePath + 'currencies.png', PROPERTYX.CURRENCIES));
  unitUiList.add(UnitUi(CURRENCIES.TRY, AppLocalizations.of(context).trY, basePath + 'currencies.png', PROPERTYX.CURRENCIES));
  unitUiList.add(UnitUi(CURRENCIES.MXN, AppLocalizations.of(context).mxn, basePath + 'currencies.png', PROPERTYX.CURRENCIES));
  unitUiList.add(UnitUi(CURRENCIES.NOK, AppLocalizations.of(context).nok, basePath + 'currencies.png', PROPERTYX.CURRENCIES));
  unitUiList.add(UnitUi(CURRENCIES.HUF, AppLocalizations.of(context).huf, basePath + 'currencies.png', PROPERTYX.CURRENCIES));
  unitUiList.add(UnitUi(CURRENCIES.ZAR, AppLocalizations.of(context).zar, basePath + 'currencies.png', PROPERTYX.CURRENCIES));
  unitUiList.add(UnitUi(CURRENCIES.SGD, AppLocalizations.of(context).sgd, basePath + 'currencies.png', PROPERTYX.CURRENCIES));
  unitUiList.add(UnitUi(CURRENCIES.GBP, AppLocalizations.of(context).gbp, basePath + 'currencies.png', PROPERTYX.CURRENCIES));
  unitUiList.add(UnitUi(CURRENCIES.KRW, AppLocalizations.of(context).krw, basePath + 'currencies.png', PROPERTYX.CURRENCIES));
  unitUiList.add(UnitUi(CURRENCIES.PLN, AppLocalizations.of(context).pln, basePath + 'currencies.png', PROPERTYX.CURRENCIES));
  unitUiList.add(UnitUi(TIME.seconds, AppLocalizations.of(context).seconds, basePath + 'time.png', PROPERTYX.TIME));
  unitUiList.add(UnitUi(TIME.deciseconds, AppLocalizations.of(context).deciseconds, basePath + 'time.png', PROPERTYX.TIME));
  unitUiList.add(UnitUi(TIME.centiseconds, AppLocalizations.of(context).centiseconds, basePath + 'time.png', PROPERTYX.TIME));
  unitUiList.add(UnitUi(TIME.milliseconds, AppLocalizations.of(context).milliseconds, basePath + 'time.png', PROPERTYX.TIME));
  unitUiList.add(UnitUi(TIME.microseconds, AppLocalizations.of(context).microseconds, basePath + 'time.png', PROPERTYX.TIME));
  unitUiList.add(UnitUi(TIME.nanoseconds, AppLocalizations.of(context).nanoseconds, basePath + 'time.png', PROPERTYX.TIME));
  unitUiList.add(UnitUi(TIME.minutes, AppLocalizations.of(context).minutes, basePath + 'time.png', PROPERTYX.TIME));
  unitUiList.add(UnitUi(TIME.hours, AppLocalizations.of(context).hours, basePath + 'time.png', PROPERTYX.TIME));
  unitUiList.add(UnitUi(TIME.days, AppLocalizations.of(context).days, basePath + 'time.png', PROPERTYX.TIME));
  unitUiList.add(UnitUi(TIME.weeks, AppLocalizations.of(context).weeks, basePath + 'time.png', PROPERTYX.TIME));
  unitUiList.add(UnitUi(TIME.years_365, AppLocalizations.of(context).years, basePath + 'time.png', PROPERTYX.TIME));
  unitUiList.add(UnitUi(TIME.lustrum, AppLocalizations.of(context).lustrum, basePath + 'time.png', PROPERTYX.TIME));
  unitUiList.add(UnitUi(TIME.decades, AppLocalizations.of(context).decades, basePath + 'time.png', PROPERTYX.TIME));
  unitUiList.add(UnitUi(TIME.centuries, AppLocalizations.of(context).centuries, basePath + 'time.png', PROPERTYX.TIME));
  unitUiList.add(UnitUi(TIME.millennium, AppLocalizations.of(context).millennium, basePath + 'time.png', PROPERTYX.TIME));
  unitUiList.add(UnitUi(TEMPERATURE.fahrenheit, AppLocalizations.of(context).fahrenheit, basePath + 'temperature.png', PROPERTYX.TEMPERATURE));
  unitUiList.add(UnitUi(TEMPERATURE.celsius, AppLocalizations.of(context).celsius, basePath + 'temperature.png', PROPERTYX.TEMPERATURE));
  unitUiList.add(UnitUi(TEMPERATURE.kelvin, AppLocalizations.of(context).kelvin, basePath + 'temperature.png', PROPERTYX.TEMPERATURE));
  unitUiList.add(UnitUi(TEMPERATURE.reamur, AppLocalizations.of(context).reamur, basePath + 'temperature.png', PROPERTYX.TEMPERATURE));
  unitUiList.add(UnitUi(TEMPERATURE.romer, AppLocalizations.of(context).romer, basePath + 'temperature.png', PROPERTYX.TEMPERATURE));
  unitUiList.add(UnitUi(TEMPERATURE.delisle, AppLocalizations.of(context).delisle, basePath + 'temperature.png', PROPERTYX.TEMPERATURE));
  unitUiList.add(UnitUi(TEMPERATURE.rankine, AppLocalizations.of(context).rankine, basePath + 'temperature.png', PROPERTYX.TEMPERATURE));
  unitUiList.add(UnitUi(SPEED.meters_per_second, AppLocalizations.of(context).metersSecond, basePath + 'speed.png', PROPERTYX.SPEED));
  unitUiList.add(UnitUi(SPEED.kilometers_per_hour, AppLocalizations.of(context).kilometersHour, basePath + 'speed.png', PROPERTYX.SPEED));
  unitUiList.add(UnitUi(SPEED.miles_per_hour, AppLocalizations.of(context).milesHour, basePath + 'speed.png', PROPERTYX.SPEED));
  unitUiList.add(UnitUi(SPEED.knots, AppLocalizations.of(context).knots, basePath + 'speed.png', PROPERTYX.SPEED));
  unitUiList.add(UnitUi(SPEED.feets_per_second, AppLocalizations.of(context).feetSecond, basePath + 'speed.png', PROPERTYX.SPEED));
  unitUiList.add(UnitUi(MASS.grams, AppLocalizations.of(context).grams, basePath + 'mass.png', PROPERTYX.MASS));
  unitUiList.add(UnitUi(MASS.ettograms, AppLocalizations.of(context).ettograms, basePath + 'mass.png', PROPERTYX.MASS));
  unitUiList.add(UnitUi(MASS.kilograms, AppLocalizations.of(context).kilograms, basePath + 'mass.png', PROPERTYX.MASS));
  unitUiList.add(UnitUi(MASS.pounds, AppLocalizations.of(context).pounds, basePath + 'mass.png', PROPERTYX.MASS));
  unitUiList.add(UnitUi(MASS.ounces, AppLocalizations.of(context).ounces, basePath + 'mass.png', PROPERTYX.MASS));
  unitUiList.add(UnitUi(MASS.quintals, AppLocalizations.of(context).quintals, basePath + 'mass.png', PROPERTYX.MASS));
  unitUiList.add(UnitUi(MASS.tons, AppLocalizations.of(context).tons, basePath + 'mass.png', PROPERTYX.MASS));
  unitUiList.add(UnitUi(MASS.milligrams, AppLocalizations.of(context).milligrams, basePath + 'mass.png', PROPERTYX.MASS));
  unitUiList.add(UnitUi(MASS.uma, AppLocalizations.of(context).uma, basePath + 'mass.png', PROPERTYX.MASS));
  unitUiList.add(UnitUi(MASS.carats, AppLocalizations.of(context).carats, basePath + 'mass.png', PROPERTYX.MASS));
  unitUiList.add(UnitUi(MASS.centigrams, AppLocalizations.of(context).centigrams, basePath + 'mass.png', PROPERTYX.MASS));
  unitUiList.add(UnitUi(FORCE.newton, AppLocalizations.of(context).newton, basePath + 'force.png', PROPERTYX.FORCE));
  unitUiList.add(UnitUi(FORCE.dyne, AppLocalizations.of(context).dyne, basePath + 'force.png', PROPERTYX.FORCE));
  unitUiList.add(UnitUi(FORCE.pound_force, AppLocalizations.of(context).poundForce, basePath + 'force.png', PROPERTYX.FORCE));
  unitUiList.add(UnitUi(FORCE.kilogram_force, AppLocalizations.of(context).kilogramForce, basePath + 'force.png', PROPERTYX.FORCE));
  unitUiList.add(UnitUi(FORCE.poundal, AppLocalizations.of(context).poundal, basePath + 'force.png', PROPERTYX.FORCE));
  unitUiList
      .add(UnitUi(FUEL_CONSUMPTION.kilometers_per_liter, AppLocalizations.of(context).kilometersLiter, basePath + 'fuel.png', PROPERTYX.FUEL_CONSUMPTION));
  unitUiList.add(UnitUi(FUEL_CONSUMPTION.liters_per_100_km, AppLocalizations.of(context).liters100km, basePath + 'fuel.png', PROPERTYX.FUEL_CONSUMPTION));
  unitUiList.add(UnitUi(FUEL_CONSUMPTION.miles_per_US_gallon, AppLocalizations.of(context).milesUsGallon, basePath + 'fuel.png', PROPERTYX.FUEL_CONSUMPTION));
  unitUiList.add(
      UnitUi(FUEL_CONSUMPTION.miles_per_imperial_gallon, AppLocalizations.of(context).milesImperialGallon, basePath + 'fuel.png', PROPERTYX.FUEL_CONSUMPTION));
  unitUiList.add(UnitUi(NUMERAL_SYSTEMS.decimal, AppLocalizations.of(context).decimal, basePath + 'num_systems.png', PROPERTYX.NUMERAL_SYSTEMS));
  unitUiList.add(UnitUi(NUMERAL_SYSTEMS.hexadecimal, AppLocalizations.of(context).hexadecimal, basePath + 'num_systems.png', PROPERTYX.NUMERAL_SYSTEMS));
  unitUiList.add(UnitUi(NUMERAL_SYSTEMS.octal, AppLocalizations.of(context).octal, basePath + 'num_systems.png', PROPERTYX.NUMERAL_SYSTEMS));
  unitUiList.add(UnitUi(NUMERAL_SYSTEMS.binary, AppLocalizations.of(context).binary, basePath + 'num_systems.png', PROPERTYX.NUMERAL_SYSTEMS));
  unitUiList.add(UnitUi(PRESSURE.pascal, AppLocalizations.of(context).pascal, basePath + 'pressure.png', PROPERTYX.PRESSURE));
  unitUiList.add(UnitUi(PRESSURE.atmosphere, AppLocalizations.of(context).atmosphere, basePath + 'pressure.png', PROPERTYX.PRESSURE));
  unitUiList.add(UnitUi(PRESSURE.bar, AppLocalizations.of(context).bar, basePath + 'pressure.png', PROPERTYX.PRESSURE));
  unitUiList.add(UnitUi(PRESSURE.millibar, AppLocalizations.of(context).millibar, basePath + 'pressure.png', PROPERTYX.PRESSURE));
  unitUiList.add(UnitUi(PRESSURE.psi, AppLocalizations.of(context).psi, basePath + 'pressure.png', PROPERTYX.PRESSURE));
  unitUiList.add(UnitUi(PRESSURE.torr, AppLocalizations.of(context).torr, basePath + 'pressure.png', PROPERTYX.PRESSURE));
  unitUiList.add(UnitUi(ENERGY.joules, AppLocalizations.of(context).joule, basePath + 'energy.png', PROPERTYX.ENERGY));
  unitUiList.add(UnitUi(ENERGY.calories, AppLocalizations.of(context).calorie, basePath + 'energy.png', PROPERTYX.ENERGY));
  unitUiList.add(UnitUi(ENERGY.kilowatt_hours, AppLocalizations.of(context).kilowattHour, basePath + 'energy.png', PROPERTYX.ENERGY));
  unitUiList.add(UnitUi(ENERGY.electronvolts, AppLocalizations.of(context).electronvolt, basePath + 'energy.png', PROPERTYX.ENERGY));
  unitUiList.add(UnitUi(POWER.watt, AppLocalizations.of(context).watt, basePath + 'power.png', PROPERTYX.POWER));
  unitUiList.add(UnitUi(POWER.milliwatt, AppLocalizations.of(context).milliwatt, basePath + 'power.png', PROPERTYX.POWER));
  unitUiList.add(UnitUi(POWER.kilowatt, AppLocalizations.of(context).kilowatt, basePath + 'power.png', PROPERTYX.POWER));
  unitUiList.add(UnitUi(POWER.megawatt, AppLocalizations.of(context).megawatt, basePath + 'power.png', PROPERTYX.POWER));
  unitUiList.add(UnitUi(POWER.gigawatt, AppLocalizations.of(context).gigawatt, basePath + 'power.png', PROPERTYX.POWER));
  unitUiList.add(UnitUi(POWER.european_horse_power, AppLocalizations.of(context).europeanHorsePower, basePath + 'power.png', PROPERTYX.POWER));
  unitUiList.add(UnitUi(POWER.imperial_horse_power, AppLocalizations.of(context).imperialHorsePower, basePath + 'power.png', PROPERTYX.POWER));
  unitUiList.add(UnitUi(ANGLE.degree, AppLocalizations.of(context).degree, basePath + 'angles.png', PROPERTYX.ANGLE));
  unitUiList.add(UnitUi(ANGLE.minutes, AppLocalizations.of(context).minutesDegree, basePath + 'angles.png', PROPERTYX.ANGLE));
  unitUiList.add(UnitUi(ANGLE.seconds, AppLocalizations.of(context).secondsDegree, basePath + 'angles.png', PROPERTYX.ANGLE));
  unitUiList.add(UnitUi(ANGLE.radians, AppLocalizations.of(context).radiansDegree, basePath + 'angles.png', PROPERTYX.ANGLE));
  unitUiList.add(UnitUi(SHOE_SIZE.centimeters, AppLocalizations.of(context).centimeters, basePath + 'shoe_size.png', PROPERTYX.SHOE_SIZE));
  unitUiList.add(UnitUi(SHOE_SIZE.inches, AppLocalizations.of(context).inches, basePath + 'shoe_size.png', PROPERTYX.SHOE_SIZE));
  unitUiList.add(UnitUi(SHOE_SIZE.eu_china, AppLocalizations.of(context).euChina, basePath + 'shoe_size.png', PROPERTYX.SHOE_SIZE));
  unitUiList.add(UnitUi(SHOE_SIZE.uk_india_child, AppLocalizations.of(context).ukIndiaChild, basePath + 'shoe_size.png', PROPERTYX.SHOE_SIZE));
  unitUiList.add(UnitUi(SHOE_SIZE.uk_india_man, AppLocalizations.of(context).ukIndiaMan, basePath + 'shoe_size.png', PROPERTYX.SHOE_SIZE));
  unitUiList.add(UnitUi(SHOE_SIZE.uk_india_woman, AppLocalizations.of(context).ukIndiaWoman, basePath + 'shoe_size.png', PROPERTYX.SHOE_SIZE));
  unitUiList.add(UnitUi(SHOE_SIZE.usa_canada_child, AppLocalizations.of(context).usaCanadaChild, basePath + 'shoe_size.png', PROPERTYX.SHOE_SIZE));
  unitUiList.add(UnitUi(SHOE_SIZE.usa_canada_man, AppLocalizations.of(context).usaCanadaMan, basePath + 'shoe_size.png', PROPERTYX.SHOE_SIZE));
  unitUiList.add(UnitUi(SHOE_SIZE.usa_canada_woman, AppLocalizations.of(context).usaCanadaWoman, basePath + 'shoe_size.png', PROPERTYX.SHOE_SIZE));
  unitUiList.add(UnitUi(SHOE_SIZE.japan, AppLocalizations.of(context).japan, basePath + 'shoe_size.png', PROPERTYX.SHOE_SIZE));
  unitUiList.add(UnitUi(DIGITAL_DATA.bit, AppLocalizations.of(context).bit, basePath + 'data.png', PROPERTYX.DIGITAL_DATA));
  unitUiList.add(UnitUi(DIGITAL_DATA.nibble, AppLocalizations.of(context).nibble, basePath + 'data.png', PROPERTYX.DIGITAL_DATA));
  unitUiList.add(UnitUi(DIGITAL_DATA.kilobit, AppLocalizations.of(context).kilobit, basePath + 'data.png', PROPERTYX.DIGITAL_DATA));
  unitUiList.add(UnitUi(DIGITAL_DATA.megabit, AppLocalizations.of(context).megabit, basePath + 'data.png', PROPERTYX.DIGITAL_DATA));
  unitUiList.add(UnitUi(DIGITAL_DATA.gigabit, AppLocalizations.of(context).gigabit, basePath + 'data.png', PROPERTYX.DIGITAL_DATA));
  unitUiList.add(UnitUi(DIGITAL_DATA.terabit, AppLocalizations.of(context).terabit, basePath + 'data.png', PROPERTYX.DIGITAL_DATA));
  unitUiList.add(UnitUi(DIGITAL_DATA.petabit, AppLocalizations.of(context).petabit, basePath + 'data.png', PROPERTYX.DIGITAL_DATA));
  unitUiList.add(UnitUi(DIGITAL_DATA.exabit, AppLocalizations.of(context).exabit, basePath + 'data.png', PROPERTYX.DIGITAL_DATA));
  unitUiList.add(UnitUi(DIGITAL_DATA.kibibit, AppLocalizations.of(context).kibibit, basePath + 'data.png', PROPERTYX.DIGITAL_DATA));
  unitUiList.add(UnitUi(DIGITAL_DATA.mebibit, AppLocalizations.of(context).mebibit, basePath + 'data.png', PROPERTYX.DIGITAL_DATA));
  unitUiList.add(UnitUi(DIGITAL_DATA.gibibit, AppLocalizations.of(context).gibibit, basePath + 'data.png', PROPERTYX.DIGITAL_DATA));
  unitUiList.add(UnitUi(DIGITAL_DATA.tebibit, AppLocalizations.of(context).tebibit, basePath + 'data.png', PROPERTYX.DIGITAL_DATA));
  unitUiList.add(UnitUi(DIGITAL_DATA.pebibit, AppLocalizations.of(context).pebibit, basePath + 'data.png', PROPERTYX.DIGITAL_DATA));
  unitUiList.add(UnitUi(DIGITAL_DATA.exbibit, AppLocalizations.of(context).exbibit, basePath + 'data.png', PROPERTYX.DIGITAL_DATA));
  unitUiList.add(UnitUi(DIGITAL_DATA.byte, AppLocalizations.of(context).byte, basePath + 'data.png', PROPERTYX.DIGITAL_DATA));
  unitUiList.add(UnitUi(DIGITAL_DATA.kilobyte, AppLocalizations.of(context).kilobyte, basePath + 'data.png', PROPERTYX.DIGITAL_DATA));
  unitUiList.add(UnitUi(DIGITAL_DATA.megabyte, AppLocalizations.of(context).megabyte, basePath + 'data.png', PROPERTYX.DIGITAL_DATA));
  unitUiList.add(UnitUi(DIGITAL_DATA.gigabyte, AppLocalizations.of(context).gigabyte, basePath + 'data.png', PROPERTYX.DIGITAL_DATA));
  unitUiList.add(UnitUi(DIGITAL_DATA.terabyte, AppLocalizations.of(context).terabyte, basePath + 'data.png', PROPERTYX.DIGITAL_DATA));
  unitUiList.add(UnitUi(DIGITAL_DATA.petabyte, AppLocalizations.of(context).petabyte, basePath + 'data.png', PROPERTYX.DIGITAL_DATA));
  unitUiList.add(UnitUi(DIGITAL_DATA.exabyte, AppLocalizations.of(context).exabyte, basePath + 'data.png', PROPERTYX.DIGITAL_DATA));
  unitUiList.add(UnitUi(DIGITAL_DATA.kibibyte, AppLocalizations.of(context).kibibyte, basePath + 'data.png', PROPERTYX.DIGITAL_DATA));
  unitUiList.add(UnitUi(DIGITAL_DATA.mebibyte, AppLocalizations.of(context).mebibyte, basePath + 'data.png', PROPERTYX.DIGITAL_DATA));
  unitUiList.add(UnitUi(DIGITAL_DATA.gibibyte, AppLocalizations.of(context).gibibyte, basePath + 'data.png', PROPERTYX.DIGITAL_DATA));
  unitUiList.add(UnitUi(DIGITAL_DATA.tebibyte, AppLocalizations.of(context).tebibyte, basePath + 'data.png', PROPERTYX.DIGITAL_DATA));
  unitUiList.add(UnitUi(DIGITAL_DATA.pebibyte, AppLocalizations.of(context).pebibyte, basePath + 'data.png', PROPERTYX.DIGITAL_DATA));
  unitUiList.add(UnitUi(DIGITAL_DATA.exbibyte, AppLocalizations.of(context).exbibyte, basePath + 'data.png', PROPERTYX.DIGITAL_DATA));
  unitUiList.add(UnitUi(SI_PREFIXES.base, AppLocalizations.of(context).base, basePath + 'prefixes.png', PROPERTYX.SI_PREFIXES));
  unitUiList.add(UnitUi(SI_PREFIXES.deca, AppLocalizations.of(context).deca, basePath + 'prefixes.png', PROPERTYX.SI_PREFIXES));
  unitUiList.add(UnitUi(SI_PREFIXES.hecto, AppLocalizations.of(context).hecto, basePath + 'prefixes.png', PROPERTYX.SI_PREFIXES));
  unitUiList.add(UnitUi(SI_PREFIXES.kilo, AppLocalizations.of(context).kilo, basePath + 'prefixes.png', PROPERTYX.SI_PREFIXES));
  unitUiList.add(UnitUi(SI_PREFIXES.mega, AppLocalizations.of(context).mega, basePath + 'prefixes.png', PROPERTYX.SI_PREFIXES));
  unitUiList.add(UnitUi(SI_PREFIXES.giga, AppLocalizations.of(context).giga, basePath + 'prefixes.png', PROPERTYX.SI_PREFIXES));
  unitUiList.add(UnitUi(SI_PREFIXES.tera, AppLocalizations.of(context).tera, basePath + 'prefixes.png', PROPERTYX.SI_PREFIXES));
  unitUiList.add(UnitUi(SI_PREFIXES.peta, AppLocalizations.of(context).peta, basePath + 'prefixes.png', PROPERTYX.SI_PREFIXES));
  unitUiList.add(UnitUi(SI_PREFIXES.exa, AppLocalizations.of(context).exa, basePath + 'prefixes.png', PROPERTYX.SI_PREFIXES));
  unitUiList.add(UnitUi(SI_PREFIXES.zetta, AppLocalizations.of(context).zetta, basePath + 'prefixes.png', PROPERTYX.SI_PREFIXES));
  unitUiList.add(UnitUi(SI_PREFIXES.yotta, AppLocalizations.of(context).yotta, basePath + 'prefixes.png', PROPERTYX.SI_PREFIXES));
  unitUiList.add(UnitUi(SI_PREFIXES.deci, AppLocalizations.of(context).deci, basePath + 'prefixes.png', PROPERTYX.SI_PREFIXES));
  unitUiList.add(UnitUi(SI_PREFIXES.centi, AppLocalizations.of(context).centi, basePath + 'prefixes.png', PROPERTYX.SI_PREFIXES));
  unitUiList.add(UnitUi(SI_PREFIXES.milli, AppLocalizations.of(context).milli, basePath + 'prefixes.png', PROPERTYX.SI_PREFIXES));
  unitUiList.add(UnitUi(SI_PREFIXES.micro, AppLocalizations.of(context).micro, basePath + 'prefixes.png', PROPERTYX.SI_PREFIXES));
  unitUiList.add(UnitUi(SI_PREFIXES.nano, AppLocalizations.of(context).nano, basePath + 'prefixes.png', PROPERTYX.SI_PREFIXES));
  unitUiList.add(UnitUi(SI_PREFIXES.pico, AppLocalizations.of(context).pico, basePath + 'prefixes.png', PROPERTYX.SI_PREFIXES));
  unitUiList.add(UnitUi(SI_PREFIXES.femto, AppLocalizations.of(context).femto, basePath + 'prefixes.png', PROPERTYX.SI_PREFIXES));
  unitUiList.add(UnitUi(SI_PREFIXES.atto, AppLocalizations.of(context).atto, basePath + 'prefixes.png', PROPERTYX.SI_PREFIXES));
  unitUiList.add(UnitUi(SI_PREFIXES.zepto, AppLocalizations.of(context).zepto, basePath + 'prefixes.png', PROPERTYX.SI_PREFIXES));
  unitUiList.add(UnitUi(SI_PREFIXES.yocto, AppLocalizations.of(context).yocto, basePath + 'prefixes.png', PROPERTYX.SI_PREFIXES));
  unitUiList.add(UnitUi(TORQUE.newton_meter, AppLocalizations.of(context).newtonMeter, basePath + 'torque.png', PROPERTYX.TORQUE));
  unitUiList.add(UnitUi(TORQUE.dyne_meter, AppLocalizations.of(context).dyneMeter, basePath + 'torque.png', PROPERTYX.TORQUE));
  unitUiList.add(UnitUi(TORQUE.pound_force_feet, AppLocalizations.of(context).poundForceFeet, basePath + 'torque.png', PROPERTYX.TORQUE));
  unitUiList.add(UnitUi(TORQUE.kilogram_force_meter, AppLocalizations.of(context).kilogramForceMeter, basePath + 'torque.png', PROPERTYX.TORQUE));
  unitUiList.add(UnitUi(TORQUE.poundal_meter, AppLocalizations.of(context).poundalMeter, basePath + 'torque.png', PROPERTYX.TORQUE));

  return unitUiList;
}

/// This method will return a map of Unit name translated: {LENGTH.meters: 'Meters', ...}
Map<dynamic, String> getUnitTranslationMap(BuildContext context) {
  List<UnitUi> unitUiList = getUnitUiList(context);

  Map<dynamic, String> unitTranslationMap = {};

  for (UnitUi unitUi in unitUiList) {
    unitTranslationMap.putIfAbsent(unitUi.unit, () => unitUi.name);
  }

  return unitTranslationMap;
}

/// This method will return a List of [SearchUnit], needed in order to display the tiles in the search
List<SearchUnit> getSearchUnitsList(Function onTap, BuildContext context) {
  List<SearchUnit> searchUnitsList = [];
  List<UnitUi> unitUiList = getUnitUiList(context);

  int propertyNumber = 0;
  PROPERTYX previousProperty = PROPERTYX.LENGTH;

  for (UnitUi unitUi in unitUiList) {
    if (previousProperty != unitUi.property) {
      propertyNumber++;
      previousProperty = unitUi.property;
    }
    int currentNumber = propertyNumber;
    searchUnitsList.add(SearchUnit(
      iconAsset: unitUi.imagePath,
      unitName: unitUi.name,
      onTap: () {
        onTap(currentNumber);
      },
    ));
  }
  return searchUnitsList;
}

/// This method will return a List of [SearchGridTile], needed in order to display the gridtiles in the search
List<SearchGridTile> initializeGridSearch(Function onTap, BuildContext context, bool darkMode, List<int> orderList) {
  List<PropertyUi> propertyUiList = getPropertyUiList(context);
  final int propertyCount = propertyUiList.length;
  List<SearchGridTile> searchGridTileList = List.filled(propertyCount, null);

  for (int i = 0; i < propertyCount; i++) {
    PropertyUi propertyUi = propertyUiList[i];
    searchGridTileList[orderList[i]] = SearchGridTile(
      iconAsset: propertyUi.imagePath,
      footer: propertyUi.name,
      onTap: () {
        onTap(i);
      },
      darkMode: darkMode,
    );
  }

  return searchGridTileList;
}
