import 'package:flutter/cupertino.dart';
import 'package:translations/app_localizations.dart';
import 'package:units_converter/units_converter.dart';
import 'package:converterpro/utils/utils.dart';
import 'utils_widgets.dart';

/// This will return the list of [PropertyUi], an objext that contains all the data regarding the displaying of the
/// property all over the app. From this List depends also other functions.
List<PropertyUi> getPropertyUiList(BuildContext context) {
  const String basePath = 'assets/property_icons';
  var l10n = AppLocalizations.of(context)!;
  //The order is important!
  return [
    PropertyUi(PROPERTYX.length, l10n.length, '$basePath/length.svg.vec'),
    PropertyUi(PROPERTYX.area, l10n.area, '$basePath/area.svg.vec'),
    PropertyUi(PROPERTYX.volume, l10n.volume, '$basePath/volume.svg.vec'),
    PropertyUi(
        PROPERTYX.currencies, l10n.currencies, '$basePath/currencies.svg.vec'),
    PropertyUi(PROPERTYX.time, l10n.time, '$basePath/time.svg.vec'),
    PropertyUi(PROPERTYX.temperature, l10n.temperature,
        '$basePath/temperature.svg.vec'),
    PropertyUi(PROPERTYX.speed, l10n.speed, '$basePath/speed.svg.vec'),
    PropertyUi(PROPERTYX.mass, l10n.mass, '$basePath/mass.svg.vec'),
    PropertyUi(PROPERTYX.force, l10n.force, '$basePath/force.svg.vec'),
    PropertyUi(PROPERTYX.fuelConsumption, l10n.fuelConsumption,
        '$basePath/fuel.svg.vec'),
    PropertyUi(PROPERTYX.numeralSystems, l10n.numeralSystems,
        '$basePath/numeral_systems.svg.vec'),
    PropertyUi(PROPERTYX.pressure, l10n.pressure, '$basePath/pressure.svg.vec'),
    PropertyUi(PROPERTYX.energy, l10n.energy, '$basePath/energy.svg.vec'),
    PropertyUi(PROPERTYX.power, l10n.power, '$basePath/power.svg.vec'),
    PropertyUi(PROPERTYX.angle, l10n.angles, '$basePath/angle.svg.vec'),
    PropertyUi(
        PROPERTYX.shoeSize, l10n.shoeSize, '$basePath/shoe_size.svg.vec'),
    PropertyUi(
        PROPERTYX.digitalData, l10n.digitalData, '$basePath/data.svg.vec'),
    PropertyUi(
        PROPERTYX.siPrefixes, l10n.siPrefixes, '$basePath/si_prefixes.svg.vec'),
    PropertyUi(PROPERTYX.torque, l10n.torque, '$basePath/torque.svg.vec')
  ];
}

/// This method will return a map of Property name translated:
/// {PROPERTYX.LENGTH: 'Length', ...}
Map<PROPERTYX, String> getPropertyTranslationMap(BuildContext context) {
  List<PropertyUi> propertyUiList = getPropertyUiList(context);
  Map<PROPERTYX, String> propertyTranslationMap = {};

  for (PropertyUi propertyUi in propertyUiList) {
    propertyTranslationMap.putIfAbsent(
      propertyUi.property,
      () => propertyUi.name,
    );
  }

  return propertyTranslationMap;
}

/// This method will return the list of Property name translated: ['Length',
/// 'Area', 'Volume', ...]
List<String> getPropertyNameList(BuildContext context) {
  return getPropertyTranslationMap(context).values.toList();
}

/// This will return the list of [UnitUi], an objext that contains all the data
/// regarding the displaying of the units all over the app. From this List
/// depends also other functions.
List<UnitUi> getUnitUiList(BuildContext context) {
  const String basePath = 'assets/property_icons';
  var l10n = AppLocalizations.of(context)!;
  return [
    UnitUi(LENGTH.meters, l10n.meters, '$basePath/length.svg.vec',
        PROPERTYX.length),
    UnitUi(LENGTH.centimeters, l10n.centimeters, '$basePath/length.svg.vec',
        PROPERTYX.length),
    UnitUi(LENGTH.inches, l10n.inches, '$basePath/length.svg.vec',
        PROPERTYX.length),
    UnitUi(
        LENGTH.mils, l10n.mils, '$basePath/length.svg.vec', PROPERTYX.length),
    UnitUi(
        LENGTH.feet, l10n.feet, '$basePath/length.svg.vec', PROPERTYX.length),
    UnitUi(LENGTH.nauticalMiles, l10n.nauticalMiles, '$basePath/length.svg.vec',
        PROPERTYX.length),
    UnitUi(
        LENGTH.yards, l10n.yards, '$basePath/length.svg.vec', PROPERTYX.length),
    UnitUi(
        LENGTH.miles, l10n.miles, '$basePath/length.svg.vec', PROPERTYX.length),
    UnitUi(LENGTH.millimeters, l10n.millimeters, '$basePath/length.svg.vec',
        PROPERTYX.length),
    UnitUi(LENGTH.micrometers, l10n.micrometers, '$basePath/length.svg.vec',
        PROPERTYX.length),
    UnitUi(LENGTH.nanometers, l10n.nanometers, '$basePath/length.svg.vec',
        PROPERTYX.length),
    UnitUi(LENGTH.angstroms, l10n.angstroms, '$basePath/length.svg.vec',
        PROPERTYX.length),
    UnitUi(LENGTH.picometers, l10n.picometers, '$basePath/length.svg.vec',
        PROPERTYX.length),
    UnitUi(LENGTH.kilometers, l10n.kilometers, '$basePath/length.svg.vec',
        PROPERTYX.length),
    UnitUi(LENGTH.astronomicalUnits, l10n.astronomicalUnits,
        '$basePath/length.svg.vec', PROPERTYX.length),
    UnitUi(LENGTH.lightYears, l10n.lightYears, '$basePath/length.svg.vec',
        PROPERTYX.length),
    UnitUi(LENGTH.parsec, l10n.parsec, '$basePath/length.svg.vec',
        PROPERTYX.length),
    UnitUi(LENGTH.feetUs, l10n.feetUsSurvey, '$basePath/length.svg.vec',
        PROPERTYX.length),
    UnitUi(AREA.squareMeters, l10n.squareMeters, '$basePath/area.svg.vec',
        PROPERTYX.area),
    UnitUi(AREA.squareCentimeters, l10n.squareCentimeters,
        '$basePath/area.svg.vec', PROPERTYX.area),
    UnitUi(AREA.squareInches, l10n.squareInches, '$basePath/area.svg.vec',
        PROPERTYX.area),
    UnitUi(AREA.squareFeet, l10n.squareFeet, '$basePath/area.svg.vec',
        PROPERTYX.area),
    UnitUi(AREA.squareMiles, l10n.squareMiles, '$basePath/area.svg.vec',
        PROPERTYX.area),
    UnitUi(AREA.squareYard, l10n.squareYard, '$basePath/area.svg.vec',
        PROPERTYX.area),
    UnitUi(AREA.squareMillimeters, l10n.squareMillimeters,
        '$basePath/area.svg.vec', PROPERTYX.area),
    UnitUi(AREA.squareKilometers, l10n.squareKilometers,
        '$basePath/area.svg.vec', PROPERTYX.area),
    UnitUi(
        AREA.hectares, l10n.hectares, '$basePath/area.svg.vec', PROPERTYX.area),
    UnitUi(AREA.acres, l10n.acres, '$basePath/area.svg.vec', PROPERTYX.area),
    UnitUi(AREA.are, l10n.are, '$basePath/area.svg.vec', PROPERTYX.area),
    UnitUi(AREA.squareFeetUs, l10n.squareFeetUsSurvey, '$basePath/area.svg.vec',
        PROPERTYX.area),
    UnitUi(VOLUME.cubicMeters, l10n.cubicMeters, '$basePath/volume.svg.vec',
        PROPERTYX.volume),
    UnitUi(VOLUME.liters, l10n.liters, '$basePath/volume.svg.vec',
        PROPERTYX.volume),
    UnitUi(VOLUME.imperialGallons, l10n.imperialGallons,
        '$basePath/volume.svg.vec', PROPERTYX.volume),
    UnitUi(VOLUME.usGallons, l10n.usGallons, '$basePath/volume.svg.vec',
        PROPERTYX.volume),
    UnitUi(VOLUME.imperialPints, l10n.imperialPints, '$basePath/volume.svg.vec',
        PROPERTYX.volume),
    UnitUi(VOLUME.usPints, l10n.usPints, '$basePath/volume.svg.vec',
        PROPERTYX.volume),
    UnitUi(VOLUME.milliliters, l10n.milliliters, '$basePath/volume.svg.vec',
        PROPERTYX.volume),
    UnitUi(VOLUME.tablespoonsUs, l10n.tablespoonUs, '$basePath/volume.svg.vec',
        PROPERTYX.volume),
    UnitUi(VOLUME.australianTablespoons, l10n.tablespoonAustralian,
        '$basePath/volume.svg.vec', PROPERTYX.volume),
    UnitUi(
        VOLUME.cups, l10n.cups, '$basePath/volume.svg.vec', PROPERTYX.volume),
    UnitUi(VOLUME.cubicCentimeters, l10n.cubicCentimeters,
        '$basePath/volume.svg.vec', PROPERTYX.volume),
    UnitUi(VOLUME.cubicFeet, l10n.cubicFeet, '$basePath/volume.svg.vec',
        PROPERTYX.volume),
    UnitUi(VOLUME.cubicInches, l10n.cubicInches, '$basePath/volume.svg.vec',
        PROPERTYX.volume),
    UnitUi(VOLUME.cubicMillimeters, l10n.cubicMillimeters,
        '$basePath/volume.svg.vec', PROPERTYX.volume),
    UnitUi(VOLUME.usFluidOunces, l10n.usFluidOunces, '$basePath/volume.svg.vec',
        PROPERTYX.volume),
    UnitUi(VOLUME.imperialFluidOunces, l10n.imperialFluidOunces,
        '$basePath/volume.svg.vec', PROPERTYX.volume),
    UnitUi(VOLUME.usGill, l10n.usGill, '$basePath/volume.svg.vec',
        PROPERTYX.volume),
    UnitUi(VOLUME.imperialGill, l10n.imperialGill, '$basePath/volume.svg.vec',
        PROPERTYX.volume),
    UnitUi(
        'EUR', l10n.eur, '$basePath/currencies.svg.vec', PROPERTYX.currencies),
    UnitUi(
        'CAD', l10n.cad, '$basePath/currencies.svg.vec', PROPERTYX.currencies),
    UnitUi(
        'HKD', l10n.hkd, '$basePath/currencies.svg.vec', PROPERTYX.currencies),
    UnitUi(
        'PHP', l10n.php, '$basePath/currencies.svg.vec', PROPERTYX.currencies),
    UnitUi(
        'DKK', l10n.dkk, '$basePath/currencies.svg.vec', PROPERTYX.currencies),
    UnitUi(
        'NZD', l10n.nzd, '$basePath/currencies.svg.vec', PROPERTYX.currencies),
    UnitUi(
        'CNY', l10n.cny, '$basePath/currencies.svg.vec', PROPERTYX.currencies),
    UnitUi(
        'AUD', l10n.aud, '$basePath/currencies.svg.vec', PROPERTYX.currencies),
    UnitUi(
        'RON', l10n.ron, '$basePath/currencies.svg.vec', PROPERTYX.currencies),
    UnitUi(
        'SEK', l10n.sek, '$basePath/currencies.svg.vec', PROPERTYX.currencies),
    UnitUi(
        'IDR', l10n.idr, '$basePath/currencies.svg.vec', PROPERTYX.currencies),
    UnitUi(
        'INR', l10n.inr, '$basePath/currencies.svg.vec', PROPERTYX.currencies),
    UnitUi(
        'BRL', l10n.brl, '$basePath/currencies.svg.vec', PROPERTYX.currencies),
    UnitUi(
        'USD', l10n.usd, '$basePath/currencies.svg.vec', PROPERTYX.currencies),
    UnitUi(
        'ILS', l10n.ils, '$basePath/currencies.svg.vec', PROPERTYX.currencies),
    UnitUi(
        'JPY', l10n.jpy, '$basePath/currencies.svg.vec', PROPERTYX.currencies),
    UnitUi(
        'THB', l10n.thb, '$basePath/currencies.svg.vec', PROPERTYX.currencies),
    UnitUi(
        'CHF', l10n.chf, '$basePath/currencies.svg.vec', PROPERTYX.currencies),
    UnitUi(
        'CZK', l10n.czk, '$basePath/currencies.svg.vec', PROPERTYX.currencies),
    UnitUi(
        'MYR', l10n.myr, '$basePath/currencies.svg.vec', PROPERTYX.currencies),
    UnitUi(
        'TRY', l10n.trY, '$basePath/currencies.svg.vec', PROPERTYX.currencies),
    UnitUi(
        'MXN', l10n.mxn, '$basePath/currencies.svg.vec', PROPERTYX.currencies),
    UnitUi(
        'NOK', l10n.nok, '$basePath/currencies.svg.vec', PROPERTYX.currencies),
    UnitUi(
        'HUF', l10n.huf, '$basePath/currencies.svg.vec', PROPERTYX.currencies),
    UnitUi(
        'ZAR', l10n.zar, '$basePath/currencies.svg.vec', PROPERTYX.currencies),
    UnitUi(
        'SGD', l10n.sgd, '$basePath/currencies.svg.vec', PROPERTYX.currencies),
    UnitUi(
        'GBP', l10n.gbp, '$basePath/currencies.svg.vec', PROPERTYX.currencies),
    UnitUi(
        'KRW', l10n.krw, '$basePath/currencies.svg.vec', PROPERTYX.currencies),
    UnitUi(
        'PLN', l10n.pln, '$basePath/currencies.svg.vec', PROPERTYX.currencies),
    UnitUi(
        'BGN', l10n.bgn, '$basePath/currencies.svg.vec', PROPERTYX.currencies),
    UnitUi(
        'ISK', l10n.isk, '$basePath/currencies.svg.vec', PROPERTYX.currencies),
    UnitUi(
        TIME.seconds, l10n.seconds, '$basePath/time.svg.vec', PROPERTYX.time),
    UnitUi(TIME.deciseconds, l10n.deciseconds, '$basePath/time.svg.vec',
        PROPERTYX.time),
    UnitUi(TIME.centiseconds, l10n.centiseconds, '$basePath/time.svg.vec',
        PROPERTYX.time),
    UnitUi(TIME.milliseconds, l10n.milliseconds, '$basePath/time.svg.vec',
        PROPERTYX.time),
    UnitUi(TIME.microseconds, l10n.microseconds, '$basePath/time.svg.vec',
        PROPERTYX.time),
    UnitUi(TIME.nanoseconds, l10n.nanoseconds, '$basePath/time.svg.vec',
        PROPERTYX.time),
    UnitUi(
        TIME.minutes, l10n.minutes, '$basePath/time.svg.vec', PROPERTYX.time),
    UnitUi(TIME.hours, l10n.hours, '$basePath/time.svg.vec', PROPERTYX.time),
    UnitUi(TIME.days, l10n.days, '$basePath/time.svg.vec', PROPERTYX.time),
    UnitUi(TIME.weeks, l10n.weeks, '$basePath/time.svg.vec', PROPERTYX.time),
    UnitUi(TIME.years365, l10n.years, '$basePath/time.svg.vec', PROPERTYX.time),
    UnitUi(
        TIME.lustrum, l10n.lustrum, '$basePath/time.svg.vec', PROPERTYX.time),
    UnitUi(
        TIME.decades, l10n.decades, '$basePath/time.svg.vec', PROPERTYX.time),
    UnitUi(TIME.centuries, l10n.centuries, '$basePath/time.svg.vec',
        PROPERTYX.time),
    UnitUi(TIME.millennium, l10n.millennium, '$basePath/time.svg.vec',
        PROPERTYX.time),
    UnitUi(TEMPERATURE.fahrenheit, l10n.fahrenheit,
        '$basePath/temperature.svg.vec', PROPERTYX.temperature),
    UnitUi(TEMPERATURE.celsius, l10n.celsius, '$basePath/temperature.svg.vec',
        PROPERTYX.temperature),
    UnitUi(TEMPERATURE.kelvin, l10n.kelvin, '$basePath/temperature.svg.vec',
        PROPERTYX.temperature),
    UnitUi(TEMPERATURE.reamur, l10n.reamur, '$basePath/temperature.svg.vec',
        PROPERTYX.temperature),
    UnitUi(TEMPERATURE.romer, l10n.romer, '$basePath/temperature.svg.vec',
        PROPERTYX.temperature),
    UnitUi(TEMPERATURE.delisle, l10n.delisle, '$basePath/temperature.svg.vec',
        PROPERTYX.temperature),
    UnitUi(TEMPERATURE.rankine, l10n.rankine, '$basePath/temperature.svg.vec',
        PROPERTYX.temperature),
    UnitUi(SPEED.metersPerSecond, l10n.metersSecond, '$basePath/speed.svg.vec',
        PROPERTYX.speed),
    UnitUi(SPEED.kilometersPerHour, l10n.kilometersHour,
        '$basePath/speed.svg.vec', PROPERTYX.speed),
    UnitUi(SPEED.milesPerHour, l10n.milesHour, '$basePath/speed.svg.vec',
        PROPERTYX.speed),
    UnitUi(SPEED.knots, l10n.knots, '$basePath/speed.svg.vec', PROPERTYX.speed),
    UnitUi(SPEED.feetsPerSecond, l10n.feetSecond, '$basePath/speed.svg.vec',
        PROPERTYX.speed),
    UnitUi(SPEED.minutesPerKilometer, l10n.minutesPerKilometer,
        '$basePath/speed.svg.vec', PROPERTYX.speed),
    UnitUi(MASS.grams, l10n.grams, '$basePath/mass.svg.vec', PROPERTYX.mass),
    UnitUi(MASS.ettograms, l10n.ettograms, '$basePath/mass.svg.vec',
        PROPERTYX.mass),
    UnitUi(MASS.kilograms, l10n.kilograms, '$basePath/mass.svg.vec',
        PROPERTYX.mass),
    UnitUi(MASS.pounds, l10n.pounds, '$basePath/mass.svg.vec', PROPERTYX.mass),
    UnitUi(MASS.ounces, l10n.ounces, '$basePath/mass.svg.vec', PROPERTYX.mass),
    UnitUi(
        MASS.quintals, l10n.quintals, '$basePath/mass.svg.vec', PROPERTYX.mass),
    UnitUi(MASS.tons, l10n.tons, '$basePath/mass.svg.vec', PROPERTYX.mass),
    UnitUi(MASS.milligrams, l10n.milligrams, '$basePath/mass.svg.vec',
        PROPERTYX.mass),
    UnitUi(MASS.uma, l10n.uma, '$basePath/mass.svg.vec', PROPERTYX.mass),
    UnitUi(MASS.carats, l10n.carats, '$basePath/mass.svg.vec', PROPERTYX.mass),
    UnitUi(MASS.centigrams, l10n.centigrams, '$basePath/mass.svg.vec',
        PROPERTYX.mass),
    UnitUi(MASS.pennyweights, l10n.pennyweights, '$basePath/mass.svg.vec',
        PROPERTYX.mass),
    UnitUi(MASS.troyOunces, l10n.troyOunces, '$basePath/mass.svg.vec',
        PROPERTYX.mass),
    UnitUi(MASS.stones, l10n.stones, '$basePath/mass.svg.vec', PROPERTYX.mass),
    UnitUi(
        FORCE.newton, l10n.newton, '$basePath/force.svg.vec', PROPERTYX.force),
    UnitUi(FORCE.dyne, l10n.dyne, '$basePath/force.svg.vec', PROPERTYX.force),
    UnitUi(FORCE.poundForce, l10n.poundForce, '$basePath/force.svg.vec',
        PROPERTYX.force),
    UnitUi(FORCE.kilogramForce, l10n.kilogramForce, '$basePath/force.svg.vec',
        PROPERTYX.force),
    UnitUi(FORCE.poundal, l10n.poundal, '$basePath/force.svg.vec',
        PROPERTYX.force),
    UnitUi(FUEL_CONSUMPTION.kilometersPerLiter, l10n.kilometersLiter,
        '$basePath/fuel.svg.vec', PROPERTYX.fuelConsumption),
    UnitUi(FUEL_CONSUMPTION.litersPer100km, l10n.liters100km,
        '$basePath/fuel.svg.vec', PROPERTYX.fuelConsumption),
    UnitUi(FUEL_CONSUMPTION.milesPerUsGallon, l10n.milesUsGallon,
        '$basePath/fuel.svg.vec', PROPERTYX.fuelConsumption),
    UnitUi(FUEL_CONSUMPTION.milesPerImperialGallon, l10n.milesImperialGallon,
        '$basePath/fuel.svg.vec', PROPERTYX.fuelConsumption),
    UnitUi(NUMERAL_SYSTEMS.decimal, l10n.decimal,
        '$basePath/numeral_systems.svg.vec', PROPERTYX.numeralSystems),
    UnitUi(NUMERAL_SYSTEMS.hexadecimal, l10n.hexadecimal,
        '$basePath/numeral_systems.svg.vec', PROPERTYX.numeralSystems),
    UnitUi(NUMERAL_SYSTEMS.octal, l10n.octal,
        '$basePath/numeral_systems.svg.vec', PROPERTYX.numeralSystems),
    UnitUi(NUMERAL_SYSTEMS.binary, l10n.binary,
        '$basePath/numeral_systems.svg.vec', PROPERTYX.numeralSystems),
    UnitUi(PRESSURE.pascal, l10n.pascal, '$basePath/pressure.svg.vec',
        PROPERTYX.pressure),
    UnitUi(PRESSURE.atmosphere, l10n.atmosphere, '$basePath/pressure.svg.vec',
        PROPERTYX.pressure),
    UnitUi(PRESSURE.bar, l10n.bar, '$basePath/pressure.svg.vec',
        PROPERTYX.pressure),
    UnitUi(PRESSURE.millibar, l10n.millibar, '$basePath/pressure.svg.vec',
        PROPERTYX.pressure),
    UnitUi(PRESSURE.psi, l10n.psi, '$basePath/pressure.svg.vec',
        PROPERTYX.pressure),
    UnitUi(PRESSURE.torr, l10n.torr, '$basePath/pressure.svg.vec',
        PROPERTYX.pressure),
    UnitUi(PRESSURE.inchOfMercury, l10n.inchesOfMercury,
        '$basePath/pressure.svg.vec', PROPERTYX.pressure),
    UnitUi(PRESSURE.hectoPascal, l10n.hectoPascal, '$basePath/pressure.svg.vec',
        PROPERTYX.pressure),
    UnitUi(ENERGY.joules, l10n.joule, '$basePath/energy.svg.vec',
        PROPERTYX.energy),
    UnitUi(ENERGY.calories, l10n.calories, '$basePath/energy.svg.vec',
        PROPERTYX.energy),
    UnitUi(ENERGY.kilowattHours, l10n.kilowattHour, '$basePath/energy.svg.vec',
        PROPERTYX.energy),
    UnitUi(ENERGY.electronvolts, l10n.electronvolt, '$basePath/energy.svg.vec',
        PROPERTYX.energy),
    UnitUi(ENERGY.energyFootPound, l10n.footPound, '$basePath/energy.svg.vec',
        PROPERTYX.energy),
    UnitUi(ENERGY.kilocalories, l10n.kilocalories, '$basePath/energy.svg.vec',
        PROPERTYX.energy),
    UnitUi(ENERGY.kilojoules, l10n.kilojoules, '$basePath/energy.svg.vec',
        PROPERTYX.energy),
    UnitUi(POWER.watt, l10n.watt, '$basePath/power.svg.vec', PROPERTYX.power),
    UnitUi(POWER.milliwatt, l10n.milliwatt, '$basePath/power.svg.vec',
        PROPERTYX.power),
    UnitUi(POWER.kilowatt, l10n.kilowatt, '$basePath/power.svg.vec',
        PROPERTYX.power),
    UnitUi(POWER.megawatt, l10n.megawatt, '$basePath/power.svg.vec',
        PROPERTYX.power),
    UnitUi(POWER.gigawatt, l10n.gigawatt, '$basePath/power.svg.vec',
        PROPERTYX.power),
    UnitUi(POWER.europeanHorsePower, l10n.europeanHorsePower,
        '$basePath/power.svg.vec', PROPERTYX.power),
    UnitUi(POWER.imperialHorsePower, l10n.imperialHorsePower,
        '$basePath/power.svg.vec', PROPERTYX.power),
    UnitUi(
        ANGLE.degree, l10n.degree, '$basePath/angle.svg.vec', PROPERTYX.angle),
    UnitUi(ANGLE.minutes, l10n.minutesDegree, '$basePath/angle.svg.vec',
        PROPERTYX.angle),
    UnitUi(ANGLE.seconds, l10n.secondsDegree, '$basePath/angle.svg.vec',
        PROPERTYX.angle),
    UnitUi(ANGLE.radians, l10n.radiansDegree, '$basePath/angle.svg.vec',
        PROPERTYX.angle),
    UnitUi(SHOE_SIZE.centimeters, l10n.centimeters,
        '$basePath/shoe_size.svg.vec', PROPERTYX.shoeSize),
    UnitUi(SHOE_SIZE.inches, l10n.inches, '$basePath/shoe_size.svg.vec',
        PROPERTYX.shoeSize),
    UnitUi(SHOE_SIZE.euChina, l10n.euChina, '$basePath/shoe_size.svg.vec',
        PROPERTYX.shoeSize),
    UnitUi(SHOE_SIZE.ukIndiaChild, l10n.ukIndiaChild,
        '$basePath/shoe_size.svg.vec', PROPERTYX.shoeSize),
    UnitUi(SHOE_SIZE.ukIndiaMan, l10n.ukIndiaMan, '$basePath/shoe_size.svg.vec',
        PROPERTYX.shoeSize),
    UnitUi(SHOE_SIZE.ukIndiaWoman, l10n.ukIndiaWoman,
        '$basePath/shoe_size.svg.vec', PROPERTYX.shoeSize),
    UnitUi(SHOE_SIZE.usaCanadaChild, l10n.usaCanadaChild,
        '$basePath/shoe_size.svg.vec', PROPERTYX.shoeSize),
    UnitUi(SHOE_SIZE.usaCanadaMan, l10n.usaCanadaMan,
        '$basePath/shoe_size.svg.vec', PROPERTYX.shoeSize),
    UnitUi(SHOE_SIZE.usaCanadaWoman, l10n.usaCanadaWoman,
        '$basePath/shoe_size.svg.vec', PROPERTYX.shoeSize),
    UnitUi(SHOE_SIZE.japan, l10n.japan, '$basePath/shoe_size.svg.vec',
        PROPERTYX.shoeSize),
    UnitUi(DIGITAL_DATA.bit, l10n.bit, '$basePath/data.svg.vec',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.nibble, l10n.nibble, '$basePath/data.svg.vec',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.kilobit, l10n.kilobit, '$basePath/data.svg.vec',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.megabit, l10n.megabit, '$basePath/data.svg.vec',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.gigabit, l10n.gigabit, '$basePath/data.svg.vec',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.terabit, l10n.terabit, '$basePath/data.svg.vec',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.petabit, l10n.petabit, '$basePath/data.svg.vec',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.exabit, l10n.exabit, '$basePath/data.svg.vec',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.kibibit, l10n.kibibit, '$basePath/data.svg.vec',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.mebibit, l10n.mebibit, '$basePath/data.svg.vec',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.gibibit, l10n.gibibit, '$basePath/data.svg.vec',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.tebibit, l10n.tebibit, '$basePath/data.svg.vec',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.pebibit, l10n.pebibit, '$basePath/data.svg.vec',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.exbibit, l10n.exbibit, '$basePath/data.svg.vec',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.byte, l10n.byte, '$basePath/data.svg.vec',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.kilobyte, l10n.kilobyte, '$basePath/data.svg.vec',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.megabyte, l10n.megabyte, '$basePath/data.svg.vec',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.gigabyte, l10n.gigabyte, '$basePath/data.svg.vec',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.terabyte, l10n.terabyte, '$basePath/data.svg.vec',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.petabyte, l10n.petabyte, '$basePath/data.svg.vec',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.exabyte, l10n.exabyte, '$basePath/data.svg.vec',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.kibibyte, l10n.kibibyte, '$basePath/data.svg.vec',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.mebibyte, l10n.mebibyte, '$basePath/data.svg.vec',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.gibibyte, l10n.gibibyte, '$basePath/data.svg.vec',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.tebibyte, l10n.tebibyte, '$basePath/data.svg.vec',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.pebibyte, l10n.pebibyte, '$basePath/data.svg.vec',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.exbibyte, l10n.exbibyte, '$basePath/data.svg.vec',
        PROPERTYX.digitalData),
    UnitUi(SI_PREFIXES.base, l10n.base, '$basePath/si_prefixes.svg.vec',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.deca, l10n.deca, '$basePath/si_prefixes.svg.vec',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.hecto, l10n.hecto, '$basePath/si_prefixes.svg.vec',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.kilo, l10n.kilo, '$basePath/si_prefixes.svg.vec',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.mega, l10n.mega, '$basePath/si_prefixes.svg.vec',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.giga, l10n.giga, '$basePath/si_prefixes.svg.vec',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.tera, l10n.tera, '$basePath/si_prefixes.svg.vec',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.peta, l10n.peta, '$basePath/si_prefixes.svg.vec',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.exa, l10n.exa, '$basePath/si_prefixes.svg.vec',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.zetta, l10n.zetta, '$basePath/si_prefixes.svg.vec',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.yotta, l10n.yotta, '$basePath/si_prefixes.svg.vec',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.deci, l10n.deci, '$basePath/si_prefixes.svg.vec',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.centi, l10n.centi, '$basePath/si_prefixes.svg.vec',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.milli, l10n.milli, '$basePath/si_prefixes.svg.vec',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.micro, l10n.micro, '$basePath/si_prefixes.svg.vec',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.nano, l10n.nano, '$basePath/si_prefixes.svg.vec',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.pico, l10n.pico, '$basePath/si_prefixes.svg.vec',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.femto, l10n.femto, '$basePath/si_prefixes.svg.vec',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.atto, l10n.atto, '$basePath/si_prefixes.svg.vec',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.zepto, l10n.zepto, '$basePath/si_prefixes.svg.vec',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.yocto, l10n.yocto, '$basePath/si_prefixes.svg.vec',
        PROPERTYX.siPrefixes),
    UnitUi(TORQUE.newtonMeter, l10n.newtonMeter, '$basePath/torque.svg.vec',
        PROPERTYX.torque),
    UnitUi(TORQUE.dyneMeter, l10n.dyneMeter, '$basePath/torque.svg.vec',
        PROPERTYX.torque),
    UnitUi(TORQUE.poundForceFeet, l10n.poundForceFeet,
        '$basePath/torque.svg.vec', PROPERTYX.torque),
    UnitUi(TORQUE.kilogramForceMeter, l10n.kilogramForceMeter,
        '$basePath/torque.svg.vec', PROPERTYX.torque),
    UnitUi(TORQUE.poundalMeter, l10n.poundalMeter, '$basePath/torque.svg.vec',
        PROPERTYX.torque)
  ];
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
  List<PropertyUi> propertyUiList = getPropertyUiList(context);

  int propertyNumber = 0;
  PROPERTYX previousProperty = PROPERTYX.length;

  // Add units in searhc
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

  // Add properties in search
  propertyNumber = 0;
  for (PropertyUi properrtyUi in propertyUiList) {
    int currentNumber = propertyNumber;
    searchUnitsList.add(SearchUnit(
      iconAsset: properrtyUi.imagePath,
      unitName: properrtyUi.name,
      onTap: () {
        onTap(currentNumber);
      },
    ));
    propertyNumber++;
  }

  return searchUnitsList;
}

/// This method will return a List of [SearchGridTile], needed in order to display the gridtiles in the search
List<SearchGridTile> initializeGridSearch(
    Function onTap, BuildContext context, bool darkMode, List<int> orderList) {
  List<PropertyUi> propertyUiList = getPropertyUiList(context);
  final int propertyCount = propertyUiList.length;
  List<SearchGridTile> searchGridTileList = List.filled(
    propertyCount,
    SearchGridTile(
      iconAsset: 'assets/app_icons/logo.svg.vec',
      darkMode: darkMode,
      footer: 'None',
      onTap: () {},
    ),
  );

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
