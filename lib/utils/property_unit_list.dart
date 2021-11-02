import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:units_converter/units_converter.dart';
import 'package:converterpro/utils/utils.dart';
import 'utils_widgets.dart';

/// This will return the list of [PropertyUi], an objext that contains all the data regarding the displaying of the
/// property all over the app. From this List depends also other functions.
List<PropertyUi> getPropertyUiList(BuildContext context) {
  const String basePath = 'resources/images/';

  List<PropertyUi> propertyUiList = [];
  //The order is important!
  propertyUiList
    ..add(PropertyUi(PROPERTYX.length, AppLocalizations.of(context)!.length, basePath + 'length.png'))
    ..add(PropertyUi(PROPERTYX.area, AppLocalizations.of(context)!.area, basePath + 'area.png'))
    ..add(PropertyUi(PROPERTYX.volume, AppLocalizations.of(context)!.volume, basePath + 'volume.png'))
    ..add(PropertyUi(PROPERTYX.currencies, AppLocalizations.of(context)!.currencies, basePath + 'currencies.png'))
    ..add(PropertyUi(PROPERTYX.time, AppLocalizations.of(context)!.time, basePath + 'time.png'))
    ..add(PropertyUi(PROPERTYX.temperature, AppLocalizations.of(context)!.temperature, basePath + 'temperature.png'))
    ..add(PropertyUi(PROPERTYX.speed, AppLocalizations.of(context)!.speed, basePath + 'speed.png'))
    ..add(PropertyUi(PROPERTYX.mass, AppLocalizations.of(context)!.mass, basePath + 'mass.png'))
    ..add(PropertyUi(PROPERTYX.force, AppLocalizations.of(context)!.force, basePath + 'force.png'))
    ..add(PropertyUi(PROPERTYX.fuelConsumption, AppLocalizations.of(context)!.fuelConsumption, basePath + 'fuel.png'))
    ..add(PropertyUi(PROPERTYX.numeralSystems, AppLocalizations.of(context)!.numeralSystems, basePath + 'num_systems.png'))
    ..add(PropertyUi(PROPERTYX.pressure, AppLocalizations.of(context)!.pressure, basePath + 'pressure.png'))
    ..add(PropertyUi(PROPERTYX.energy, AppLocalizations.of(context)!.energy, basePath + 'energy.png'))
    ..add(PropertyUi(PROPERTYX.power, AppLocalizations.of(context)!.power, basePath + 'power.png'))
    ..add(PropertyUi(PROPERTYX.angle, AppLocalizations.of(context)!.angles, basePath + 'angles.png'))
    ..add(PropertyUi(PROPERTYX.shoeSize, AppLocalizations.of(context)!.shoeSize, basePath + 'shoe_size.png'))
    ..add(PropertyUi(PROPERTYX.digitalData, AppLocalizations.of(context)!.digitalData, basePath + 'data.png'))
    ..add(PropertyUi(PROPERTYX.siPrefixes, AppLocalizations.of(context)!.siPrefixes, basePath + 'prefixes.png'))
    ..add(PropertyUi(PROPERTYX.torque, AppLocalizations.of(context)!.torque, basePath + 'torque.png'));

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

  unitUiList
    ..add(UnitUi(LENGTH.meters, AppLocalizations.of(context)!.meters, basePath + 'length.png', PROPERTYX.length))
    ..add(UnitUi(LENGTH.centimeters, AppLocalizations.of(context)!.centimeters, basePath + 'length.png', PROPERTYX.length))
    ..add(UnitUi(LENGTH.inches, AppLocalizations.of(context)!.inches, basePath + 'length.png', PROPERTYX.length))
    ..add(UnitUi(LENGTH.mils, AppLocalizations.of(context)!.mils, basePath + 'length.png', PROPERTYX.length))
    ..add(UnitUi(LENGTH.feet, AppLocalizations.of(context)!.feet, basePath + 'length.png', PROPERTYX.length))
    ..add(UnitUi(LENGTH.nauticalMiles, AppLocalizations.of(context)!.nauticalMiles, basePath + 'length.png', PROPERTYX.length))
    ..add(UnitUi(LENGTH.yards, AppLocalizations.of(context)!.yards, basePath + 'length.png', PROPERTYX.length))
    ..add(UnitUi(LENGTH.miles, AppLocalizations.of(context)!.miles, basePath + 'length.png', PROPERTYX.length))
    ..add(UnitUi(LENGTH.millimeters, AppLocalizations.of(context)!.millimeters, basePath + 'length.png', PROPERTYX.length))
    ..add(UnitUi(LENGTH.micrometers, AppLocalizations.of(context)!.micrometers, basePath + 'length.png', PROPERTYX.length))
    ..add(UnitUi(LENGTH.nanometers, AppLocalizations.of(context)!.nanometers, basePath + 'length.png', PROPERTYX.length))
    ..add(UnitUi(LENGTH.angstroms, AppLocalizations.of(context)!.angstroms, basePath + 'length.png', PROPERTYX.length))
    ..add(UnitUi(LENGTH.picometers, AppLocalizations.of(context)!.picometers, basePath + 'length.png', PROPERTYX.length))
    ..add(UnitUi(LENGTH.kilometers, AppLocalizations.of(context)!.kilometers, basePath + 'length.png', PROPERTYX.length))
    ..add(UnitUi(LENGTH.astronomicalUnits, AppLocalizations.of(context)!.astronomicalUnits, basePath + 'length.png', PROPERTYX.length))
    ..add(UnitUi(LENGTH.lightYears, AppLocalizations.of(context)!.lightYears, basePath + 'length.png', PROPERTYX.length))
    ..add(UnitUi(LENGTH.parsec, AppLocalizations.of(context)!.parsec, basePath + 'length.png', PROPERTYX.length))
    ..add(UnitUi(AREA.squareMeters, AppLocalizations.of(context)!.squareMeters, basePath + 'area.png', PROPERTYX.area))
    ..add(UnitUi(AREA.squareCentimeters, AppLocalizations.of(context)!.squareCentimeters, basePath + 'area.png', PROPERTYX.area))
    ..add(UnitUi(AREA.squareInches, AppLocalizations.of(context)!.squareInches, basePath + 'area.png', PROPERTYX.area))
    ..add(UnitUi(AREA.squareFeet, AppLocalizations.of(context)!.squareFeet, basePath + 'area.png', PROPERTYX.area))
    ..add(UnitUi(AREA.squareMiles, AppLocalizations.of(context)!.squareMiles, basePath + 'area.png', PROPERTYX.area))
    ..add(UnitUi(AREA.squareYard, AppLocalizations.of(context)!.squareYard, basePath + 'area.png', PROPERTYX.area))
    ..add(UnitUi(AREA.squareMillimeters, AppLocalizations.of(context)!.squareMillimeters, basePath + 'area.png', PROPERTYX.area))
    ..add(UnitUi(AREA.squareKilometers, AppLocalizations.of(context)!.squareKilometers, basePath + 'area.png', PROPERTYX.area))
    ..add(UnitUi(AREA.hectares, AppLocalizations.of(context)!.hectares, basePath + 'area.png', PROPERTYX.area))
    ..add(UnitUi(AREA.acres, AppLocalizations.of(context)!.acres, basePath + 'area.png', PROPERTYX.area))
    ..add(UnitUi(AREA.are, AppLocalizations.of(context)!.are, basePath + 'area.png', PROPERTYX.area))
    ..add(UnitUi(VOLUME.cubicMeters, AppLocalizations.of(context)!.cubicMeters, basePath + 'volume.png', PROPERTYX.volume))
    ..add(UnitUi(VOLUME.liters, AppLocalizations.of(context)!.liters, basePath + 'volume.png', PROPERTYX.volume))
    ..add(UnitUi(VOLUME.imperialGallons, AppLocalizations.of(context)!.imperialGallons, basePath + 'volume.png', PROPERTYX.volume))
    ..add(UnitUi(VOLUME.usGallons, AppLocalizations.of(context)!.usGallons, basePath + 'volume.png', PROPERTYX.volume))
    ..add(UnitUi(VOLUME.imperialPints, AppLocalizations.of(context)!.imperialPints, basePath + 'volume.png', PROPERTYX.volume))
    ..add(UnitUi(VOLUME.usPints, AppLocalizations.of(context)!.usPints, basePath + 'volume.png', PROPERTYX.volume))
    ..add(UnitUi(VOLUME.milliliters, AppLocalizations.of(context)!.milliliters, basePath + 'volume.png', PROPERTYX.volume))
    ..add(UnitUi(VOLUME.tablespoonsUs, AppLocalizations.of(context)!.tablespoonUs, basePath + 'volume.png', PROPERTYX.volume))
    ..add(UnitUi(VOLUME.australianTablespoons, AppLocalizations.of(context)!.tablespoonAustralian, basePath + 'volume.png', PROPERTYX.volume))
    ..add(UnitUi(VOLUME.cups, AppLocalizations.of(context)!.cups, basePath + 'volume.png', PROPERTYX.volume))
    ..add(UnitUi(VOLUME.cubicCentimeters, AppLocalizations.of(context)!.cubicCentimeters, basePath + 'volume.png', PROPERTYX.volume))
    ..add(UnitUi(VOLUME.cubicFeet, AppLocalizations.of(context)!.cubicFeet, basePath + 'volume.png', PROPERTYX.volume))
    ..add(UnitUi(VOLUME.cubicInches, AppLocalizations.of(context)!.cubicInches, basePath + 'volume.png', PROPERTYX.volume))
    ..add(UnitUi(VOLUME.cubicMillimeters, AppLocalizations.of(context)!.cubicMillimeters, basePath + 'volume.png', PROPERTYX.volume))
    ..add(UnitUi(VOLUME.usFluidOunces, AppLocalizations.of(context)!.usFluidOunces, basePath + 'volume.png', PROPERTYX.volume))
    ..add(UnitUi(VOLUME.imperialFluidOunces, AppLocalizations.of(context)!.imperialFluidOunces, basePath + 'volume.png', PROPERTYX.volume))
    ..add(UnitUi(VOLUME.usGill, AppLocalizations.of(context)!.usGill, basePath + 'volume.png', PROPERTYX.volume))
    ..add(UnitUi(VOLUME.imperialGill, AppLocalizations.of(context)!.imperialGill, basePath + 'volume.png', PROPERTYX.volume))
    ..add(UnitUi(CURRENCIES.EUR, AppLocalizations.of(context)!.eur, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.CAD, AppLocalizations.of(context)!.cad, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.HKD, AppLocalizations.of(context)!.hkd, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.RUB, AppLocalizations.of(context)!.rub, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.PHP, AppLocalizations.of(context)!.php, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.DKK, AppLocalizations.of(context)!.dkk, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.NZD, AppLocalizations.of(context)!.nzd, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.CNY, AppLocalizations.of(context)!.cny, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.AUD, AppLocalizations.of(context)!.aud, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.RON, AppLocalizations.of(context)!.ron, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.SEK, AppLocalizations.of(context)!.sek, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.IDR, AppLocalizations.of(context)!.idr, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.INR, AppLocalizations.of(context)!.inr, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.BRL, AppLocalizations.of(context)!.brl, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.USD, AppLocalizations.of(context)!.usd, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.ILS, AppLocalizations.of(context)!.ils, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.JPY, AppLocalizations.of(context)!.jpy, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.THB, AppLocalizations.of(context)!.thb, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.CHF, AppLocalizations.of(context)!.chf, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.CZK, AppLocalizations.of(context)!.czk, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.MYR, AppLocalizations.of(context)!.myr, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.TRY, AppLocalizations.of(context)!.trY, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.MXN, AppLocalizations.of(context)!.mxn, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.NOK, AppLocalizations.of(context)!.nok, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.HUF, AppLocalizations.of(context)!.huf, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.ZAR, AppLocalizations.of(context)!.zar, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.SGD, AppLocalizations.of(context)!.sgd, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.GBP, AppLocalizations.of(context)!.gbp, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.KRW, AppLocalizations.of(context)!.krw, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.PLN, AppLocalizations.of(context)!.pln, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.BGN, AppLocalizations.of(context)!.bgn, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.HRK, AppLocalizations.of(context)!.hrk, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.ISK, AppLocalizations.of(context)!.isk, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.TWD, AppLocalizations.of(context)!.twd, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(CURRENCIES.MAD, AppLocalizations.of(context)!.mad, basePath + 'currencies.png', PROPERTYX.currencies))
    ..add(UnitUi(TIME.seconds, AppLocalizations.of(context)!.seconds, basePath + 'time.png', PROPERTYX.time))
    ..add(UnitUi(TIME.deciseconds, AppLocalizations.of(context)!.deciseconds, basePath + 'time.png', PROPERTYX.time))
    ..add(UnitUi(TIME.centiseconds, AppLocalizations.of(context)!.centiseconds, basePath + 'time.png', PROPERTYX.time))
    ..add(UnitUi(TIME.milliseconds, AppLocalizations.of(context)!.milliseconds, basePath + 'time.png', PROPERTYX.time))
    ..add(UnitUi(TIME.microseconds, AppLocalizations.of(context)!.microseconds, basePath + 'time.png', PROPERTYX.time))
    ..add(UnitUi(TIME.nanoseconds, AppLocalizations.of(context)!.nanoseconds, basePath + 'time.png', PROPERTYX.time))
    ..add(UnitUi(TIME.minutes, AppLocalizations.of(context)!.minutes, basePath + 'time.png', PROPERTYX.time))
    ..add(UnitUi(TIME.hours, AppLocalizations.of(context)!.hours, basePath + 'time.png', PROPERTYX.time))
    ..add(UnitUi(TIME.days, AppLocalizations.of(context)!.days, basePath + 'time.png', PROPERTYX.time))
    ..add(UnitUi(TIME.weeks, AppLocalizations.of(context)!.weeks, basePath + 'time.png', PROPERTYX.time))
    ..add(UnitUi(TIME.years365, AppLocalizations.of(context)!.years, basePath + 'time.png', PROPERTYX.time))
    ..add(UnitUi(TIME.lustrum, AppLocalizations.of(context)!.lustrum, basePath + 'time.png', PROPERTYX.time))
    ..add(UnitUi(TIME.decades, AppLocalizations.of(context)!.decades, basePath + 'time.png', PROPERTYX.time))
    ..add(UnitUi(TIME.centuries, AppLocalizations.of(context)!.centuries, basePath + 'time.png', PROPERTYX.time))
    ..add(UnitUi(TIME.millennium, AppLocalizations.of(context)!.millennium, basePath + 'time.png', PROPERTYX.time))
    ..add(UnitUi(TEMPERATURE.fahrenheit, AppLocalizations.of(context)!.fahrenheit, basePath + 'temperature.png', PROPERTYX.temperature))
    ..add(UnitUi(TEMPERATURE.celsius, AppLocalizations.of(context)!.celsius, basePath + 'temperature.png', PROPERTYX.temperature))
    ..add(UnitUi(TEMPERATURE.kelvin, AppLocalizations.of(context)!.kelvin, basePath + 'temperature.png', PROPERTYX.temperature))
    ..add(UnitUi(TEMPERATURE.reamur, AppLocalizations.of(context)!.reamur, basePath + 'temperature.png', PROPERTYX.temperature))
    ..add(UnitUi(TEMPERATURE.romer, AppLocalizations.of(context)!.romer, basePath + 'temperature.png', PROPERTYX.temperature))
    ..add(UnitUi(TEMPERATURE.delisle, AppLocalizations.of(context)!.delisle, basePath + 'temperature.png', PROPERTYX.temperature))
    ..add(UnitUi(TEMPERATURE.rankine, AppLocalizations.of(context)!.rankine, basePath + 'temperature.png', PROPERTYX.temperature))
    ..add(UnitUi(SPEED.metersPerSecond, AppLocalizations.of(context)!.metersSecond, basePath + 'speed.png', PROPERTYX.speed))
    ..add(UnitUi(SPEED.kilometersPerHour, AppLocalizations.of(context)!.kilometersHour, basePath + 'speed.png', PROPERTYX.speed))
    ..add(UnitUi(SPEED.milesPerHour, AppLocalizations.of(context)!.milesHour, basePath + 'speed.png', PROPERTYX.speed))
    ..add(UnitUi(SPEED.knots, AppLocalizations.of(context)!.knots, basePath + 'speed.png', PROPERTYX.speed))
    ..add(UnitUi(SPEED.feetsPerSecond, AppLocalizations.of(context)!.feetSecond, basePath + 'speed.png', PROPERTYX.speed))
    ..add(UnitUi(SPEED.minutesPerKilometer, AppLocalizations.of(context)!.minutesPerKilometer, basePath + 'speed.png', PROPERTYX.speed))
    ..add(UnitUi(MASS.grams, AppLocalizations.of(context)!.grams, basePath + 'mass.png', PROPERTYX.mass))
    ..add(UnitUi(MASS.ettograms, AppLocalizations.of(context)!.ettograms, basePath + 'mass.png', PROPERTYX.mass))
    ..add(UnitUi(MASS.kilograms, AppLocalizations.of(context)!.kilograms, basePath + 'mass.png', PROPERTYX.mass))
    ..add(UnitUi(MASS.pounds, AppLocalizations.of(context)!.pounds, basePath + 'mass.png', PROPERTYX.mass))
    ..add(UnitUi(MASS.ounces, AppLocalizations.of(context)!.ounces, basePath + 'mass.png', PROPERTYX.mass))
    ..add(UnitUi(MASS.quintals, AppLocalizations.of(context)!.quintals, basePath + 'mass.png', PROPERTYX.mass))
    ..add(UnitUi(MASS.tons, AppLocalizations.of(context)!.tons, basePath + 'mass.png', PROPERTYX.mass))
    ..add(UnitUi(MASS.milligrams, AppLocalizations.of(context)!.milligrams, basePath + 'mass.png', PROPERTYX.mass))
    ..add(UnitUi(MASS.uma, AppLocalizations.of(context)!.uma, basePath + 'mass.png', PROPERTYX.mass))
    ..add(UnitUi(MASS.carats, AppLocalizations.of(context)!.carats, basePath + 'mass.png', PROPERTYX.mass))
    ..add(UnitUi(MASS.centigrams, AppLocalizations.of(context)!.centigrams, basePath + 'mass.png', PROPERTYX.mass))
    ..add(UnitUi(MASS.pennyweights, AppLocalizations.of(context)!.pennyweights, basePath + 'mass.png', PROPERTYX.mass))
    ..add(UnitUi(MASS.troyOunces, AppLocalizations.of(context)!.troyOunces, basePath + 'mass.png', PROPERTYX.mass))
    ..add(UnitUi(MASS.stones, AppLocalizations.of(context)!.stones, basePath + 'mass.png', PROPERTYX.mass))
    ..add(UnitUi(FORCE.newton, AppLocalizations.of(context)!.newton, basePath + 'force.png', PROPERTYX.force))
    ..add(UnitUi(FORCE.dyne, AppLocalizations.of(context)!.dyne, basePath + 'force.png', PROPERTYX.force))
    ..add(UnitUi(FORCE.poundForce, AppLocalizations.of(context)!.poundForce, basePath + 'force.png', PROPERTYX.force))
    ..add(UnitUi(FORCE.kilogramForce, AppLocalizations.of(context)!.kilogramForce, basePath + 'force.png', PROPERTYX.force))
    ..add(UnitUi(FORCE.poundal, AppLocalizations.of(context)!.poundal, basePath + 'force.png', PROPERTYX.force))
    ..add(UnitUi(FUEL_CONSUMPTION.kilometersPerLiter, AppLocalizations.of(context)!.kilometersLiter, basePath + 'fuel.png', PROPERTYX.fuelConsumption))
    ..add(UnitUi(FUEL_CONSUMPTION.litersPer100km, AppLocalizations.of(context)!.liters100km, basePath + 'fuel.png', PROPERTYX.fuelConsumption))
    ..add(UnitUi(FUEL_CONSUMPTION.milesPerUsGallon, AppLocalizations.of(context)!.milesUsGallon, basePath + 'fuel.png', PROPERTYX.fuelConsumption))
    ..add(UnitUi(
        FUEL_CONSUMPTION.milesPerImperialGallon, AppLocalizations.of(context)!.milesImperialGallon, basePath + 'fuel.png', PROPERTYX.fuelConsumption))
    ..add(UnitUi(NUMERAL_SYSTEMS.decimal, AppLocalizations.of(context)!.decimal, basePath + 'num_systems.png', PROPERTYX.numeralSystems))
    ..add(UnitUi(NUMERAL_SYSTEMS.hexadecimal, AppLocalizations.of(context)!.hexadecimal, basePath + 'num_systems.png', PROPERTYX.numeralSystems))
    ..add(UnitUi(NUMERAL_SYSTEMS.octal, AppLocalizations.of(context)!.octal, basePath + 'num_systems.png', PROPERTYX.numeralSystems))
    ..add(UnitUi(NUMERAL_SYSTEMS.binary, AppLocalizations.of(context)!.binary, basePath + 'num_systems.png', PROPERTYX.numeralSystems))
    ..add(UnitUi(PRESSURE.pascal, AppLocalizations.of(context)!.pascal, basePath + 'pressure.png', PROPERTYX.pressure))
    ..add(UnitUi(PRESSURE.atmosphere, AppLocalizations.of(context)!.atmosphere, basePath + 'pressure.png', PROPERTYX.pressure))
    ..add(UnitUi(PRESSURE.bar, AppLocalizations.of(context)!.bar, basePath + 'pressure.png', PROPERTYX.pressure))
    ..add(UnitUi(PRESSURE.millibar, AppLocalizations.of(context)!.millibar, basePath + 'pressure.png', PROPERTYX.pressure))
    ..add(UnitUi(PRESSURE.psi, AppLocalizations.of(context)!.psi, basePath + 'pressure.png', PROPERTYX.pressure))
    ..add(UnitUi(PRESSURE.torr, AppLocalizations.of(context)!.torr, basePath + 'pressure.png', PROPERTYX.pressure))
    ..add(UnitUi(PRESSURE.inchOfMercury, AppLocalizations.of(context)!.inchesOfMercury, basePath + 'pressure.png', PROPERTYX.pressure))
    ..add(UnitUi(PRESSURE.hectoPascal, AppLocalizations.of(context)!.hectoPascal, basePath + 'pressure.png', PROPERTYX.pressure))
    ..add(UnitUi(ENERGY.joules, AppLocalizations.of(context)!.joule, basePath + 'energy.png', PROPERTYX.energy))
    ..add(UnitUi(ENERGY.calories, AppLocalizations.of(context)!.calorie, basePath + 'energy.png', PROPERTYX.energy))
    ..add(UnitUi(ENERGY.kilowattHours, AppLocalizations.of(context)!.kilowattHour, basePath + 'energy.png', PROPERTYX.energy))
    ..add(UnitUi(ENERGY.electronvolts, AppLocalizations.of(context)!.electronvolt, basePath + 'energy.png', PROPERTYX.energy))
    ..add(UnitUi(ENERGY.energyFootPound, AppLocalizations.of(context)!.footPound, basePath + 'energy.png', PROPERTYX.energy))
    ..add(UnitUi(POWER.watt, AppLocalizations.of(context)!.watt, basePath + 'power.png', PROPERTYX.power))
    ..add(UnitUi(POWER.milliwatt, AppLocalizations.of(context)!.milliwatt, basePath + 'power.png', PROPERTYX.power))
    ..add(UnitUi(POWER.kilowatt, AppLocalizations.of(context)!.kilowatt, basePath + 'power.png', PROPERTYX.power))
    ..add(UnitUi(POWER.megawatt, AppLocalizations.of(context)!.megawatt, basePath + 'power.png', PROPERTYX.power))
    ..add(UnitUi(POWER.gigawatt, AppLocalizations.of(context)!.gigawatt, basePath + 'power.png', PROPERTYX.power))
    ..add(UnitUi(POWER.europeanHorsePower, AppLocalizations.of(context)!.europeanHorsePower, basePath + 'power.png', PROPERTYX.power))
    ..add(UnitUi(POWER.imperialHorsePower, AppLocalizations.of(context)!.imperialHorsePower, basePath + 'power.png', PROPERTYX.power))
    ..add(UnitUi(ANGLE.degree, AppLocalizations.of(context)!.degree, basePath + 'angles.png', PROPERTYX.angle))
    ..add(UnitUi(ANGLE.minutes, AppLocalizations.of(context)!.minutesDegree, basePath + 'angles.png', PROPERTYX.angle))
    ..add(UnitUi(ANGLE.seconds, AppLocalizations.of(context)!.secondsDegree, basePath + 'angles.png', PROPERTYX.angle))
    ..add(UnitUi(ANGLE.radians, AppLocalizations.of(context)!.radiansDegree, basePath + 'angles.png', PROPERTYX.angle))
    ..add(UnitUi(SHOE_SIZE.centimeters, AppLocalizations.of(context)!.centimeters, basePath + 'shoe_size.png', PROPERTYX.shoeSize))
    ..add(UnitUi(SHOE_SIZE.inches, AppLocalizations.of(context)!.inches, basePath + 'shoe_size.png', PROPERTYX.shoeSize))
    ..add(UnitUi(SHOE_SIZE.euChina, AppLocalizations.of(context)!.euChina, basePath + 'shoe_size.png', PROPERTYX.shoeSize))
    ..add(UnitUi(SHOE_SIZE.ukIndiaChild, AppLocalizations.of(context)!.ukIndiaChild, basePath + 'shoe_size.png', PROPERTYX.shoeSize))
    ..add(UnitUi(SHOE_SIZE.ukIndiaMan, AppLocalizations.of(context)!.ukIndiaMan, basePath + 'shoe_size.png', PROPERTYX.shoeSize))
    ..add(UnitUi(SHOE_SIZE.ukIndiaWoman, AppLocalizations.of(context)!.ukIndiaWoman, basePath + 'shoe_size.png', PROPERTYX.shoeSize))
    ..add(UnitUi(SHOE_SIZE.usaCanadaChild, AppLocalizations.of(context)!.usaCanadaChild, basePath + 'shoe_size.png', PROPERTYX.shoeSize))
    ..add(UnitUi(SHOE_SIZE.usaCanadaMan, AppLocalizations.of(context)!.usaCanadaMan, basePath + 'shoe_size.png', PROPERTYX.shoeSize))
    ..add(UnitUi(SHOE_SIZE.usaCanadaWoman, AppLocalizations.of(context)!.usaCanadaWoman, basePath + 'shoe_size.png', PROPERTYX.shoeSize))
    ..add(UnitUi(SHOE_SIZE.japan, AppLocalizations.of(context)!.japan, basePath + 'shoe_size.png', PROPERTYX.shoeSize))
    ..add(UnitUi(DIGITAL_DATA.bit, AppLocalizations.of(context)!.bit, basePath + 'data.png', PROPERTYX.digitalData))
    ..add(UnitUi(DIGITAL_DATA.nibble, AppLocalizations.of(context)!.nibble, basePath + 'data.png', PROPERTYX.digitalData))
    ..add(UnitUi(DIGITAL_DATA.kilobit, AppLocalizations.of(context)!.kilobit, basePath + 'data.png', PROPERTYX.digitalData))
    ..add(UnitUi(DIGITAL_DATA.megabit, AppLocalizations.of(context)!.megabit, basePath + 'data.png', PROPERTYX.digitalData))
    ..add(UnitUi(DIGITAL_DATA.gigabit, AppLocalizations.of(context)!.gigabit, basePath + 'data.png', PROPERTYX.digitalData))
    ..add(UnitUi(DIGITAL_DATA.terabit, AppLocalizations.of(context)!.terabit, basePath + 'data.png', PROPERTYX.digitalData))
    ..add(UnitUi(DIGITAL_DATA.petabit, AppLocalizations.of(context)!.petabit, basePath + 'data.png', PROPERTYX.digitalData))
    ..add(UnitUi(DIGITAL_DATA.exabit, AppLocalizations.of(context)!.exabit, basePath + 'data.png', PROPERTYX.digitalData))
    ..add(UnitUi(DIGITAL_DATA.kibibit, AppLocalizations.of(context)!.kibibit, basePath + 'data.png', PROPERTYX.digitalData))
    ..add(UnitUi(DIGITAL_DATA.mebibit, AppLocalizations.of(context)!.mebibit, basePath + 'data.png', PROPERTYX.digitalData))
    ..add(UnitUi(DIGITAL_DATA.gibibit, AppLocalizations.of(context)!.gibibit, basePath + 'data.png', PROPERTYX.digitalData))
    ..add(UnitUi(DIGITAL_DATA.tebibit, AppLocalizations.of(context)!.tebibit, basePath + 'data.png', PROPERTYX.digitalData))
    ..add(UnitUi(DIGITAL_DATA.pebibit, AppLocalizations.of(context)!.pebibit, basePath + 'data.png', PROPERTYX.digitalData))
    ..add(UnitUi(DIGITAL_DATA.exbibit, AppLocalizations.of(context)!.exbibit, basePath + 'data.png', PROPERTYX.digitalData))
    ..add(UnitUi(DIGITAL_DATA.byte, AppLocalizations.of(context)!.byte, basePath + 'data.png', PROPERTYX.digitalData))
    ..add(UnitUi(DIGITAL_DATA.kilobyte, AppLocalizations.of(context)!.kilobyte, basePath + 'data.png', PROPERTYX.digitalData))
    ..add(UnitUi(DIGITAL_DATA.megabyte, AppLocalizations.of(context)!.megabyte, basePath + 'data.png', PROPERTYX.digitalData))
    ..add(UnitUi(DIGITAL_DATA.gigabyte, AppLocalizations.of(context)!.gigabyte, basePath + 'data.png', PROPERTYX.digitalData))
    ..add(UnitUi(DIGITAL_DATA.terabyte, AppLocalizations.of(context)!.terabyte, basePath + 'data.png', PROPERTYX.digitalData))
    ..add(UnitUi(DIGITAL_DATA.petabyte, AppLocalizations.of(context)!.petabyte, basePath + 'data.png', PROPERTYX.digitalData))
    ..add(UnitUi(DIGITAL_DATA.exabyte, AppLocalizations.of(context)!.exabyte, basePath + 'data.png', PROPERTYX.digitalData))
    ..add(UnitUi(DIGITAL_DATA.kibibyte, AppLocalizations.of(context)!.kibibyte, basePath + 'data.png', PROPERTYX.digitalData))
    ..add(UnitUi(DIGITAL_DATA.mebibyte, AppLocalizations.of(context)!.mebibyte, basePath + 'data.png', PROPERTYX.digitalData))
    ..add(UnitUi(DIGITAL_DATA.gibibyte, AppLocalizations.of(context)!.gibibyte, basePath + 'data.png', PROPERTYX.digitalData))
    ..add(UnitUi(DIGITAL_DATA.tebibyte, AppLocalizations.of(context)!.tebibyte, basePath + 'data.png', PROPERTYX.digitalData))
    ..add(UnitUi(DIGITAL_DATA.pebibyte, AppLocalizations.of(context)!.pebibyte, basePath + 'data.png', PROPERTYX.digitalData))
    ..add(UnitUi(DIGITAL_DATA.exbibyte, AppLocalizations.of(context)!.exbibyte, basePath + 'data.png', PROPERTYX.digitalData))
    ..add(UnitUi(SI_PREFIXES.base, AppLocalizations.of(context)!.base, basePath + 'prefixes.png', PROPERTYX.siPrefixes))
    ..add(UnitUi(SI_PREFIXES.deca, AppLocalizations.of(context)!.deca, basePath + 'prefixes.png', PROPERTYX.siPrefixes))
    ..add(UnitUi(SI_PREFIXES.hecto, AppLocalizations.of(context)!.hecto, basePath + 'prefixes.png', PROPERTYX.siPrefixes))
    ..add(UnitUi(SI_PREFIXES.kilo, AppLocalizations.of(context)!.kilo, basePath + 'prefixes.png', PROPERTYX.siPrefixes))
    ..add(UnitUi(SI_PREFIXES.mega, AppLocalizations.of(context)!.mega, basePath + 'prefixes.png', PROPERTYX.siPrefixes))
    ..add(UnitUi(SI_PREFIXES.giga, AppLocalizations.of(context)!.giga, basePath + 'prefixes.png', PROPERTYX.siPrefixes))
    ..add(UnitUi(SI_PREFIXES.tera, AppLocalizations.of(context)!.tera, basePath + 'prefixes.png', PROPERTYX.siPrefixes))
    ..add(UnitUi(SI_PREFIXES.peta, AppLocalizations.of(context)!.peta, basePath + 'prefixes.png', PROPERTYX.siPrefixes))
    ..add(UnitUi(SI_PREFIXES.exa, AppLocalizations.of(context)!.exa, basePath + 'prefixes.png', PROPERTYX.siPrefixes))
    ..add(UnitUi(SI_PREFIXES.zetta, AppLocalizations.of(context)!.zetta, basePath + 'prefixes.png', PROPERTYX.siPrefixes))
    ..add(UnitUi(SI_PREFIXES.yotta, AppLocalizations.of(context)!.yotta, basePath + 'prefixes.png', PROPERTYX.siPrefixes))
    ..add(UnitUi(SI_PREFIXES.deci, AppLocalizations.of(context)!.deci, basePath + 'prefixes.png', PROPERTYX.siPrefixes))
    ..add(UnitUi(SI_PREFIXES.centi, AppLocalizations.of(context)!.centi, basePath + 'prefixes.png', PROPERTYX.siPrefixes))
    ..add(UnitUi(SI_PREFIXES.milli, AppLocalizations.of(context)!.milli, basePath + 'prefixes.png', PROPERTYX.siPrefixes))
    ..add(UnitUi(SI_PREFIXES.micro, AppLocalizations.of(context)!.micro, basePath + 'prefixes.png', PROPERTYX.siPrefixes))
    ..add(UnitUi(SI_PREFIXES.nano, AppLocalizations.of(context)!.nano, basePath + 'prefixes.png', PROPERTYX.siPrefixes))
    ..add(UnitUi(SI_PREFIXES.pico, AppLocalizations.of(context)!.pico, basePath + 'prefixes.png', PROPERTYX.siPrefixes))
    ..add(UnitUi(SI_PREFIXES.femto, AppLocalizations.of(context)!.femto, basePath + 'prefixes.png', PROPERTYX.siPrefixes))
    ..add(UnitUi(SI_PREFIXES.atto, AppLocalizations.of(context)!.atto, basePath + 'prefixes.png', PROPERTYX.siPrefixes))
    ..add(UnitUi(SI_PREFIXES.zepto, AppLocalizations.of(context)!.zepto, basePath + 'prefixes.png', PROPERTYX.siPrefixes))
    ..add(UnitUi(SI_PREFIXES.yocto, AppLocalizations.of(context)!.yocto, basePath + 'prefixes.png', PROPERTYX.siPrefixes))
    ..add(UnitUi(TORQUE.newtonMeter, AppLocalizations.of(context)!.newtonMeter, basePath + 'torque.png', PROPERTYX.torque))
    ..add(UnitUi(TORQUE.dyneMeter, AppLocalizations.of(context)!.dyneMeter, basePath + 'torque.png', PROPERTYX.torque))
    ..add(UnitUi(TORQUE.poundForceFeet, AppLocalizations.of(context)!.poundForceFeet, basePath + 'torque.png', PROPERTYX.torque))
    ..add(UnitUi(TORQUE.kilogramForceMeter, AppLocalizations.of(context)!.kilogramForceMeter, basePath + 'torque.png', PROPERTYX.torque))
    ..add(UnitUi(TORQUE.poundalMeter, AppLocalizations.of(context)!.poundalMeter, basePath + 'torque.png', PROPERTYX.torque));

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
  List<PropertyUi> propertyUiList = getPropertyUiList(context);

  int propertyNumber = 0;
  PROPERTYX previousProperty = PROPERTYX.length;

  //Add units in searhc
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

  //Add properties in search
  propertyNumber = 0;
  for(PropertyUi properrtyUi in propertyUiList){
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
List<SearchGridTile> initializeGridSearch(Function onTap, BuildContext context, bool darkMode, List<int> orderList) {
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
