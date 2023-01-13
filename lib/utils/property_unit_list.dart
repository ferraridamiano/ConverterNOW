import 'package:flutter/cupertino.dart';
import 'package:translations/app_localizations.dart';
import 'package:units_converter/units_converter.dart';
import 'package:converterpro/utils/utils.dart';
import 'utils_widgets.dart';

/// This will return the list of [PropertyUi], an objext that contains all the data regarding the displaying of the
/// property all over the app. From this List depends also other functions.
List<PropertyUi> getPropertyUiList(BuildContext context) {
  const String basePath = 'resources/images';
  var l10n = AppLocalizations.of(context)!;
  //The order is important!
  return [
    PropertyUi(PROPERTYX.length, l10n.length, '$basePath/length.png'),
    PropertyUi(PROPERTYX.area, l10n.area, '$basePath/area.png'),
    PropertyUi(PROPERTYX.volume, l10n.volume, '$basePath/volume.png'),
    PropertyUi(
        PROPERTYX.currencies, l10n.currencies, '$basePath/currencies.png'),
    PropertyUi(PROPERTYX.time, l10n.time, '$basePath/time.png'),
    PropertyUi(
        PROPERTYX.temperature, l10n.temperature, '$basePath/temperature.png'),
    PropertyUi(PROPERTYX.speed, l10n.speed, '$basePath/speed.png'),
    PropertyUi(PROPERTYX.mass, l10n.mass, '$basePath/mass.png'),
    PropertyUi(PROPERTYX.force, l10n.force, '$basePath/force.png'),
    PropertyUi(
        PROPERTYX.fuelConsumption, l10n.fuelConsumption, '$basePath/fuel.png'),
    PropertyUi(PROPERTYX.numeralSystems, l10n.numeralSystems,
        '$basePath/num_systems.png'),
    PropertyUi(PROPERTYX.pressure, l10n.pressure, '$basePath/pressure.png'),
    PropertyUi(PROPERTYX.energy, l10n.energy, '$basePath/energy.png'),
    PropertyUi(PROPERTYX.power, l10n.power, '$basePath/power.png'),
    PropertyUi(PROPERTYX.angle, l10n.angles, '$basePath/angles.png'),
    PropertyUi(PROPERTYX.shoeSize, l10n.shoeSize, '$basePath/shoe_size.png'),
    PropertyUi(PROPERTYX.digitalData, l10n.digitalData, '$basePath/data.png'),
    PropertyUi(PROPERTYX.siPrefixes, l10n.siPrefixes, '$basePath/prefixes.png'),
    PropertyUi(PROPERTYX.torque, l10n.torque, '$basePath/torque.png')
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
  const String basePath = 'resources/images/';
  var l10n = AppLocalizations.of(context)!;
  return [
    UnitUi(
        LENGTH.meters, l10n.meters, '$basePath/length.png', PROPERTYX.length),
    UnitUi(LENGTH.centimeters, l10n.centimeters, '$basePath/length.png',
        PROPERTYX.length),
    UnitUi(
        LENGTH.inches, l10n.inches, '$basePath/length.png', PROPERTYX.length),
    UnitUi(LENGTH.mils, l10n.mils, '$basePath/length.png', PROPERTYX.length),
    UnitUi(LENGTH.feet, l10n.feet, '$basePath/length.png', PROPERTYX.length),
    UnitUi(LENGTH.nauticalMiles, l10n.nauticalMiles, '$basePath/length.png',
        PROPERTYX.length),
    UnitUi(LENGTH.yards, l10n.yards, '$basePath/length.png', PROPERTYX.length),
    UnitUi(LENGTH.miles, l10n.miles, '$basePath/length.png', PROPERTYX.length),
    UnitUi(LENGTH.millimeters, l10n.millimeters, '$basePath/length.png',
        PROPERTYX.length),
    UnitUi(LENGTH.micrometers, l10n.micrometers, '$basePath/length.png',
        PROPERTYX.length),
    UnitUi(LENGTH.nanometers, l10n.nanometers, '$basePath/length.png',
        PROPERTYX.length),
    UnitUi(LENGTH.angstroms, l10n.angstroms, '$basePath/length.png',
        PROPERTYX.length),
    UnitUi(LENGTH.picometers, l10n.picometers, '$basePath/length.png',
        PROPERTYX.length),
    UnitUi(LENGTH.kilometers, l10n.kilometers, '$basePath/length.png',
        PROPERTYX.length),
    UnitUi(LENGTH.astronomicalUnits, l10n.astronomicalUnits,
        '$basePath/length.png', PROPERTYX.length),
    UnitUi(LENGTH.lightYears, l10n.lightYears, '$basePath/length.png',
        PROPERTYX.length),
    UnitUi(
        LENGTH.parsec, l10n.parsec, '$basePath/length.png', PROPERTYX.length),
    UnitUi(LENGTH.feetUs, l10n.feetUsSurvey, '$basePath/length.png',
        PROPERTYX.length),
    UnitUi(AREA.squareMeters, l10n.squareMeters, '$basePath/area.png',
        PROPERTYX.area),
    UnitUi(AREA.squareCentimeters, l10n.squareCentimeters, '$basePath/area.png',
        PROPERTYX.area),
    UnitUi(AREA.squareInches, l10n.squareInches, '$basePath/area.png',
        PROPERTYX.area),
    UnitUi(
        AREA.squareFeet, l10n.squareFeet, '$basePath/area.png', PROPERTYX.area),
    UnitUi(AREA.squareMiles, l10n.squareMiles, '$basePath/area.png',
        PROPERTYX.area),
    UnitUi(
        AREA.squareYard, l10n.squareYard, '$basePath/area.png', PROPERTYX.area),
    UnitUi(AREA.squareMillimeters, l10n.squareMillimeters, '$basePath/area.png',
        PROPERTYX.area),
    UnitUi(AREA.squareKilometers, l10n.squareKilometers, '$basePath/area.png',
        PROPERTYX.area),
    UnitUi(AREA.hectares, l10n.hectares, '$basePath/area.png', PROPERTYX.area),
    UnitUi(AREA.acres, l10n.acres, '$basePath/area.png', PROPERTYX.area),
    UnitUi(AREA.are, l10n.are, '$basePath/area.png', PROPERTYX.area),
    UnitUi(AREA.squareFeetUs, l10n.squareFeetUsSurvey, '$basePath/area.png',
        PROPERTYX.area),
    UnitUi(VOLUME.cubicMeters, l10n.cubicMeters, '$basePath/volume.png',
        PROPERTYX.volume),
    UnitUi(
        VOLUME.liters, l10n.liters, '$basePath/volume.png', PROPERTYX.volume),
    UnitUi(VOLUME.imperialGallons, l10n.imperialGallons, '$basePath/volume.png',
        PROPERTYX.volume),
    UnitUi(VOLUME.usGallons, l10n.usGallons, '$basePath/volume.png',
        PROPERTYX.volume),
    UnitUi(VOLUME.imperialPints, l10n.imperialPints, '$basePath/volume.png',
        PROPERTYX.volume),
    UnitUi(
        VOLUME.usPints, l10n.usPints, '$basePath/volume.png', PROPERTYX.volume),
    UnitUi(VOLUME.milliliters, l10n.milliliters, '$basePath/volume.png',
        PROPERTYX.volume),
    UnitUi(VOLUME.tablespoonsUs, l10n.tablespoonUs, '$basePath/volume.png',
        PROPERTYX.volume),
    UnitUi(VOLUME.australianTablespoons, l10n.tablespoonAustralian,
        '$basePath/volume.png', PROPERTYX.volume),
    UnitUi(VOLUME.cups, l10n.cups, '$basePath/volume.png', PROPERTYX.volume),
    UnitUi(VOLUME.cubicCentimeters, l10n.cubicCentimeters,
        '$basePath/volume.png', PROPERTYX.volume),
    UnitUi(VOLUME.cubicFeet, l10n.cubicFeet, '$basePath/volume.png',
        PROPERTYX.volume),
    UnitUi(VOLUME.cubicInches, l10n.cubicInches, '$basePath/volume.png',
        PROPERTYX.volume),
    UnitUi(VOLUME.cubicMillimeters, l10n.cubicMillimeters,
        '$basePath/volume.png', PROPERTYX.volume),
    UnitUi(VOLUME.usFluidOunces, l10n.usFluidOunces, '$basePath/volume.png',
        PROPERTYX.volume),
    UnitUi(VOLUME.imperialFluidOunces, l10n.imperialFluidOunces,
        '$basePath/volume.png', PROPERTYX.volume),
    UnitUi(
        VOLUME.usGill, l10n.usGill, '$basePath/volume.png', PROPERTYX.volume),
    UnitUi(VOLUME.imperialGill, l10n.imperialGill, '$basePath/volume.png',
        PROPERTYX.volume),
    UnitUi('EUR', l10n.eur, '$basePath/currencies.png', PROPERTYX.currencies),
    UnitUi('CAD', l10n.cad, '$basePath/currencies.png', PROPERTYX.currencies),
    UnitUi('HKD', l10n.hkd, '$basePath/currencies.png', PROPERTYX.currencies),
    UnitUi('PHP', l10n.php, '$basePath/currencies.png', PROPERTYX.currencies),
    UnitUi('DKK', l10n.dkk, '$basePath/currencies.png', PROPERTYX.currencies),
    UnitUi('NZD', l10n.nzd, '$basePath/currencies.png', PROPERTYX.currencies),
    UnitUi('CNY', l10n.cny, '$basePath/currencies.png', PROPERTYX.currencies),
    UnitUi('AUD', l10n.aud, '$basePath/currencies.png', PROPERTYX.currencies),
    UnitUi('RON', l10n.ron, '$basePath/currencies.png', PROPERTYX.currencies),
    UnitUi('SEK', l10n.sek, '$basePath/currencies.png', PROPERTYX.currencies),
    UnitUi('IDR', l10n.idr, '$basePath/currencies.png', PROPERTYX.currencies),
    UnitUi('INR', l10n.inr, '$basePath/currencies.png', PROPERTYX.currencies),
    UnitUi('BRL', l10n.brl, '$basePath/currencies.png', PROPERTYX.currencies),
    UnitUi('USD', l10n.usd, '$basePath/currencies.png', PROPERTYX.currencies),
    UnitUi('ILS', l10n.ils, '$basePath/currencies.png', PROPERTYX.currencies),
    UnitUi('JPY', l10n.jpy, '$basePath/currencies.png', PROPERTYX.currencies),
    UnitUi('THB', l10n.thb, '$basePath/currencies.png', PROPERTYX.currencies),
    UnitUi('CHF', l10n.chf, '$basePath/currencies.png', PROPERTYX.currencies),
    UnitUi('CZK', l10n.czk, '$basePath/currencies.png', PROPERTYX.currencies),
    UnitUi('MYR', l10n.myr, '$basePath/currencies.png', PROPERTYX.currencies),
    UnitUi('TRY', l10n.trY, '$basePath/currencies.png', PROPERTYX.currencies),
    UnitUi('MXN', l10n.mxn, '$basePath/currencies.png', PROPERTYX.currencies),
    UnitUi('NOK', l10n.nok, '$basePath/currencies.png', PROPERTYX.currencies),
    UnitUi('HUF', l10n.huf, '$basePath/currencies.png', PROPERTYX.currencies),
    UnitUi('ZAR', l10n.zar, '$basePath/currencies.png', PROPERTYX.currencies),
    UnitUi('SGD', l10n.sgd, '$basePath/currencies.png', PROPERTYX.currencies),
    UnitUi('GBP', l10n.gbp, '$basePath/currencies.png', PROPERTYX.currencies),
    UnitUi('KRW', l10n.krw, '$basePath/currencies.png', PROPERTYX.currencies),
    UnitUi('PLN', l10n.pln, '$basePath/currencies.png', PROPERTYX.currencies),
    UnitUi('BGN', l10n.bgn, '$basePath/currencies.png', PROPERTYX.currencies),
    UnitUi('ISK', l10n.isk, '$basePath/currencies.png', PROPERTYX.currencies),
    UnitUi(TIME.seconds, l10n.seconds, '$basePath/time.png', PROPERTYX.time),
    UnitUi(TIME.deciseconds, l10n.deciseconds, '$basePath/time.png',
        PROPERTYX.time),
    UnitUi(TIME.centiseconds, l10n.centiseconds, '$basePath/time.png',
        PROPERTYX.time),
    UnitUi(TIME.milliseconds, l10n.milliseconds, '$basePath/time.png',
        PROPERTYX.time),
    UnitUi(TIME.microseconds, l10n.microseconds, '$basePath/time.png',
        PROPERTYX.time),
    UnitUi(TIME.nanoseconds, l10n.nanoseconds, '$basePath/time.png',
        PROPERTYX.time),
    UnitUi(TIME.minutes, l10n.minutes, '$basePath/time.png', PROPERTYX.time),
    UnitUi(TIME.hours, l10n.hours, '$basePath/time.png', PROPERTYX.time),
    UnitUi(TIME.days, l10n.days, '$basePath/time.png', PROPERTYX.time),
    UnitUi(TIME.weeks, l10n.weeks, '$basePath/time.png', PROPERTYX.time),
    UnitUi(TIME.years365, l10n.years, '$basePath/time.png', PROPERTYX.time),
    UnitUi(TIME.lustrum, l10n.lustrum, '$basePath/time.png', PROPERTYX.time),
    UnitUi(TIME.decades, l10n.decades, '$basePath/time.png', PROPERTYX.time),
    UnitUi(
        TIME.centuries, l10n.centuries, '$basePath/time.png', PROPERTYX.time),
    UnitUi(
        TIME.millennium, l10n.millennium, '$basePath/time.png', PROPERTYX.time),
    UnitUi(TEMPERATURE.fahrenheit, l10n.fahrenheit, '$basePath/temperature.png',
        PROPERTYX.temperature),
    UnitUi(TEMPERATURE.celsius, l10n.celsius, '$basePath/temperature.png',
        PROPERTYX.temperature),
    UnitUi(TEMPERATURE.kelvin, l10n.kelvin, '$basePath/temperature.png',
        PROPERTYX.temperature),
    UnitUi(TEMPERATURE.reamur, l10n.reamur, '$basePath/temperature.png',
        PROPERTYX.temperature),
    UnitUi(TEMPERATURE.romer, l10n.romer, '$basePath/temperature.png',
        PROPERTYX.temperature),
    UnitUi(TEMPERATURE.delisle, l10n.delisle, '$basePath/temperature.png',
        PROPERTYX.temperature),
    UnitUi(TEMPERATURE.rankine, l10n.rankine, '$basePath/temperature.png',
        PROPERTYX.temperature),
    UnitUi(SPEED.metersPerSecond, l10n.metersSecond, '$basePath/speed.png',
        PROPERTYX.speed),
    UnitUi(SPEED.kilometersPerHour, l10n.kilometersHour, '$basePath/speed.png',
        PROPERTYX.speed),
    UnitUi(SPEED.milesPerHour, l10n.milesHour, '$basePath/speed.png',
        PROPERTYX.speed),
    UnitUi(SPEED.knots, l10n.knots, '$basePath/speed.png', PROPERTYX.speed),
    UnitUi(SPEED.feetsPerSecond, l10n.feetSecond, '$basePath/speed.png',
        PROPERTYX.speed),
    UnitUi(SPEED.minutesPerKilometer, l10n.minutesPerKilometer,
        '$basePath/speed.png', PROPERTYX.speed),
    UnitUi(MASS.grams, l10n.grams, '$basePath/mass.png', PROPERTYX.mass),
    UnitUi(
        MASS.ettograms, l10n.ettograms, '$basePath/mass.png', PROPERTYX.mass),
    UnitUi(
        MASS.kilograms, l10n.kilograms, '$basePath/mass.png', PROPERTYX.mass),
    UnitUi(MASS.pounds, l10n.pounds, '$basePath/mass.png', PROPERTYX.mass),
    UnitUi(MASS.ounces, l10n.ounces, '$basePath/mass.png', PROPERTYX.mass),
    UnitUi(MASS.quintals, l10n.quintals, '$basePath/mass.png', PROPERTYX.mass),
    UnitUi(MASS.tons, l10n.tons, '$basePath/mass.png', PROPERTYX.mass),
    UnitUi(
        MASS.milligrams, l10n.milligrams, '$basePath/mass.png', PROPERTYX.mass),
    UnitUi(MASS.uma, l10n.uma, '$basePath/mass.png', PROPERTYX.mass),
    UnitUi(MASS.carats, l10n.carats, '$basePath/mass.png', PROPERTYX.mass),
    UnitUi(
        MASS.centigrams, l10n.centigrams, '$basePath/mass.png', PROPERTYX.mass),
    UnitUi(MASS.pennyweights, l10n.pennyweights, '$basePath/mass.png',
        PROPERTYX.mass),
    UnitUi(
        MASS.troyOunces, l10n.troyOunces, '$basePath/mass.png', PROPERTYX.mass),
    UnitUi(MASS.stones, l10n.stones, '$basePath/mass.png', PROPERTYX.mass),
    UnitUi(FORCE.newton, l10n.newton, '$basePath/force.png', PROPERTYX.force),
    UnitUi(FORCE.dyne, l10n.dyne, '$basePath/force.png', PROPERTYX.force),
    UnitUi(FORCE.poundForce, l10n.poundForce, '$basePath/force.png',
        PROPERTYX.force),
    UnitUi(FORCE.kilogramForce, l10n.kilogramForce, '$basePath/force.png',
        PROPERTYX.force),
    UnitUi(FORCE.poundal, l10n.poundal, '$basePath/force.png', PROPERTYX.force),
    UnitUi(FUEL_CONSUMPTION.kilometersPerLiter, l10n.kilometersLiter,
        '$basePath/fuel.png', PROPERTYX.fuelConsumption),
    UnitUi(FUEL_CONSUMPTION.litersPer100km, l10n.liters100km,
        '$basePath/fuel.png', PROPERTYX.fuelConsumption),
    UnitUi(FUEL_CONSUMPTION.milesPerUsGallon, l10n.milesUsGallon,
        '$basePath/fuel.png', PROPERTYX.fuelConsumption),
    UnitUi(FUEL_CONSUMPTION.milesPerImperialGallon, l10n.milesImperialGallon,
        '$basePath/fuel.png', PROPERTYX.fuelConsumption),
    UnitUi(NUMERAL_SYSTEMS.decimal, l10n.decimal, '$basePath/num_systems.png',
        PROPERTYX.numeralSystems),
    UnitUi(NUMERAL_SYSTEMS.hexadecimal, l10n.hexadecimal,
        '$basePath/num_systems.png', PROPERTYX.numeralSystems),
    UnitUi(NUMERAL_SYSTEMS.octal, l10n.octal, '$basePath/num_systems.png',
        PROPERTYX.numeralSystems),
    UnitUi(NUMERAL_SYSTEMS.binary, l10n.binary, '$basePath/num_systems.png',
        PROPERTYX.numeralSystems),
    UnitUi(PRESSURE.pascal, l10n.pascal, '$basePath/pressure.png',
        PROPERTYX.pressure),
    UnitUi(PRESSURE.atmosphere, l10n.atmosphere, '$basePath/pressure.png',
        PROPERTYX.pressure),
    UnitUi(
        PRESSURE.bar, l10n.bar, '$basePath/pressure.png', PROPERTYX.pressure),
    UnitUi(PRESSURE.millibar, l10n.millibar, '$basePath/pressure.png',
        PROPERTYX.pressure),
    UnitUi(
        PRESSURE.psi, l10n.psi, '$basePath/pressure.png', PROPERTYX.pressure),
    UnitUi(
        PRESSURE.torr, l10n.torr, '$basePath/pressure.png', PROPERTYX.pressure),
    UnitUi(PRESSURE.inchOfMercury, l10n.inchesOfMercury,
        '$basePath/pressure.png', PROPERTYX.pressure),
    UnitUi(PRESSURE.hectoPascal, l10n.hectoPascal, '$basePath/pressure.png',
        PROPERTYX.pressure),
    UnitUi(ENERGY.joules, l10n.joule, '$basePath/energy.png', PROPERTYX.energy),
    UnitUi(ENERGY.calories, l10n.calories, '$basePath/energy.png',
        PROPERTYX.energy),
    UnitUi(ENERGY.kilowattHours, l10n.kilowattHour, '$basePath/energy.png',
        PROPERTYX.energy),
    UnitUi(ENERGY.electronvolts, l10n.electronvolt, '$basePath/energy.png',
        PROPERTYX.energy),
    UnitUi(ENERGY.energyFootPound, l10n.footPound, '$basePath/energy.png',
        PROPERTYX.energy),
    UnitUi(ENERGY.kilocalories, l10n.kilocalories, '$basePath/energy.png',
        PROPERTYX.energy),
    UnitUi(POWER.watt, l10n.watt, '$basePath/power.png', PROPERTYX.power),
    UnitUi(POWER.milliwatt, l10n.milliwatt, '$basePath/power.png',
        PROPERTYX.power),
    UnitUi(
        POWER.kilowatt, l10n.kilowatt, '$basePath/power.png', PROPERTYX.power),
    UnitUi(
        POWER.megawatt, l10n.megawatt, '$basePath/power.png', PROPERTYX.power),
    UnitUi(
        POWER.gigawatt, l10n.gigawatt, '$basePath/power.png', PROPERTYX.power),
    UnitUi(POWER.europeanHorsePower, l10n.europeanHorsePower,
        '$basePath/power.png', PROPERTYX.power),
    UnitUi(POWER.imperialHorsePower, l10n.imperialHorsePower,
        '$basePath/power.png', PROPERTYX.power),
    UnitUi(ANGLE.degree, l10n.degree, '$basePath/angles.png', PROPERTYX.angle),
    UnitUi(ANGLE.minutes, l10n.minutesDegree, '$basePath/angles.png',
        PROPERTYX.angle),
    UnitUi(ANGLE.seconds, l10n.secondsDegree, '$basePath/angles.png',
        PROPERTYX.angle),
    UnitUi(ANGLE.radians, l10n.radiansDegree, '$basePath/angles.png',
        PROPERTYX.angle),
    UnitUi(SHOE_SIZE.centimeters, l10n.centimeters, '$basePath/shoe_size.png',
        PROPERTYX.shoeSize),
    UnitUi(SHOE_SIZE.inches, l10n.inches, '$basePath/shoe_size.png',
        PROPERTYX.shoeSize),
    UnitUi(SHOE_SIZE.euChina, l10n.euChina, '$basePath/shoe_size.png',
        PROPERTYX.shoeSize),
    UnitUi(SHOE_SIZE.ukIndiaChild, l10n.ukIndiaChild, '$basePath/shoe_size.png',
        PROPERTYX.shoeSize),
    UnitUi(SHOE_SIZE.ukIndiaMan, l10n.ukIndiaMan, '$basePath/shoe_size.png',
        PROPERTYX.shoeSize),
    UnitUi(SHOE_SIZE.ukIndiaWoman, l10n.ukIndiaWoman, '$basePath/shoe_size.png',
        PROPERTYX.shoeSize),
    UnitUi(SHOE_SIZE.usaCanadaChild, l10n.usaCanadaChild,
        '$basePath/shoe_size.png', PROPERTYX.shoeSize),
    UnitUi(SHOE_SIZE.usaCanadaMan, l10n.usaCanadaMan, '$basePath/shoe_size.png',
        PROPERTYX.shoeSize),
    UnitUi(SHOE_SIZE.usaCanadaWoman, l10n.usaCanadaWoman,
        '$basePath/shoe_size.png', PROPERTYX.shoeSize),
    UnitUi(SHOE_SIZE.japan, l10n.japan, '$basePath/shoe_size.png',
        PROPERTYX.shoeSize),
    UnitUi(DIGITAL_DATA.bit, l10n.bit, '$basePath/data.png',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.nibble, l10n.nibble, '$basePath/data.png',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.kilobit, l10n.kilobit, '$basePath/data.png',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.megabit, l10n.megabit, '$basePath/data.png',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.gigabit, l10n.gigabit, '$basePath/data.png',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.terabit, l10n.terabit, '$basePath/data.png',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.petabit, l10n.petabit, '$basePath/data.png',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.exabit, l10n.exabit, '$basePath/data.png',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.kibibit, l10n.kibibit, '$basePath/data.png',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.mebibit, l10n.mebibit, '$basePath/data.png',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.gibibit, l10n.gibibit, '$basePath/data.png',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.tebibit, l10n.tebibit, '$basePath/data.png',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.pebibit, l10n.pebibit, '$basePath/data.png',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.exbibit, l10n.exbibit, '$basePath/data.png',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.byte, l10n.byte, '$basePath/data.png',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.kilobyte, l10n.kilobyte, '$basePath/data.png',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.megabyte, l10n.megabyte, '$basePath/data.png',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.gigabyte, l10n.gigabyte, '$basePath/data.png',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.terabyte, l10n.terabyte, '$basePath/data.png',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.petabyte, l10n.petabyte, '$basePath/data.png',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.exabyte, l10n.exabyte, '$basePath/data.png',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.kibibyte, l10n.kibibyte, '$basePath/data.png',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.mebibyte, l10n.mebibyte, '$basePath/data.png',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.gibibyte, l10n.gibibyte, '$basePath/data.png',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.tebibyte, l10n.tebibyte, '$basePath/data.png',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.pebibyte, l10n.pebibyte, '$basePath/data.png',
        PROPERTYX.digitalData),
    UnitUi(DIGITAL_DATA.exbibyte, l10n.exbibyte, '$basePath/data.png',
        PROPERTYX.digitalData),
    UnitUi(SI_PREFIXES.base, l10n.base, '$basePath/prefixes.png',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.deca, l10n.deca, '$basePath/prefixes.png',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.hecto, l10n.hecto, '$basePath/prefixes.png',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.kilo, l10n.kilo, '$basePath/prefixes.png',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.mega, l10n.mega, '$basePath/prefixes.png',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.giga, l10n.giga, '$basePath/prefixes.png',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.tera, l10n.tera, '$basePath/prefixes.png',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.peta, l10n.peta, '$basePath/prefixes.png',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.exa, l10n.exa, '$basePath/prefixes.png',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.zetta, l10n.zetta, '$basePath/prefixes.png',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.yotta, l10n.yotta, '$basePath/prefixes.png',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.deci, l10n.deci, '$basePath/prefixes.png',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.centi, l10n.centi, '$basePath/prefixes.png',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.milli, l10n.milli, '$basePath/prefixes.png',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.micro, l10n.micro, '$basePath/prefixes.png',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.nano, l10n.nano, '$basePath/prefixes.png',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.pico, l10n.pico, '$basePath/prefixes.png',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.femto, l10n.femto, '$basePath/prefixes.png',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.atto, l10n.atto, '$basePath/prefixes.png',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.zepto, l10n.zepto, '$basePath/prefixes.png',
        PROPERTYX.siPrefixes),
    UnitUi(SI_PREFIXES.yocto, l10n.yocto, '$basePath/prefixes.png',
        PROPERTYX.siPrefixes),
    UnitUi(TORQUE.newtonMeter, l10n.newtonMeter, '$basePath/torque.png',
        PROPERTYX.torque),
    UnitUi(TORQUE.dyneMeter, l10n.dyneMeter, '$basePath/torque.png',
        PROPERTYX.torque),
    UnitUi(TORQUE.poundForceFeet, l10n.poundForceFeet, '$basePath/torque.png',
        PROPERTYX.torque),
    UnitUi(TORQUE.kilogramForceMeter, l10n.kilogramForceMeter,
        '$basePath/torque.png', PROPERTYX.torque),
    UnitUi(TORQUE.poundalMeter, l10n.poundalMeter, '$basePath/torque.png',
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
      iconAsset: 'resources/images/logo.png',
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
