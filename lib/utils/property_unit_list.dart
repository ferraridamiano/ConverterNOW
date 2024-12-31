import 'package:flutter/cupertino.dart';
import 'package:translations/app_localizations.dart';
import 'package:units_converter/units_converter.dart';
import 'package:converterpro/utils/utils.dart';
import 'utils_widgets.dart';

/// This will return the map of [PropertyUi], a record that contains all the
/// data regarding the displaying of the property all over the app.
Map<PROPERTYX, PropertyUi> getPropertyUiMap(BuildContext context) {
  const String basePath = 'assets/property_icons';
  final l10n = AppLocalizations.of(context)!;
  //The order is important!
  return {
    PROPERTYX.length: (name: l10n.length, imagePath: '$basePath/length.svg'),
    PROPERTYX.area: (name: l10n.area, imagePath: '$basePath/area.svg'),
    PROPERTYX.volume: (name: l10n.volume, imagePath: '$basePath/volume.svg'),
    PROPERTYX.currencies: (
      name: l10n.currencies,
      imagePath: '$basePath/currencies.svg'
    ),
    PROPERTYX.time: (name: l10n.time, imagePath: '$basePath/time.svg'),
    PROPERTYX.temperature: (
      name: l10n.temperature,
      imagePath: '$basePath/temperature.svg'
    ),
    PROPERTYX.speed: (name: l10n.speed, imagePath: '$basePath/speed.svg'),
    PROPERTYX.mass: (name: l10n.mass, imagePath: '$basePath/mass.svg'),
    PROPERTYX.force: (name: l10n.force, imagePath: '$basePath/force.svg'),
    PROPERTYX.fuelConsumption: (
      name: l10n.fuelConsumption,
      imagePath: '$basePath/fuel.svg'
    ),
    PROPERTYX.numeralSystems: (
      name: l10n.numeralSystems,
      imagePath: '$basePath/numeral_systems.svg'
    ),
    PROPERTYX.pressure: (
      name: l10n.pressure,
      imagePath: '$basePath/pressure.svg'
    ),
    PROPERTYX.energy: (name: l10n.energy, imagePath: '$basePath/energy.svg'),
    PROPERTYX.power: (name: l10n.power, imagePath: '$basePath/power.svg'),
    PROPERTYX.angle: (name: l10n.angles, imagePath: '$basePath/angle.svg'),
    PROPERTYX.shoeSize: (
      name: l10n.shoeSize,
      imagePath: '$basePath/shoe_size.svg'
    ),
    PROPERTYX.digitalData: (
      name: l10n.digitalData,
      imagePath: '$basePath/data.svg'
    ),
    PROPERTYX.siPrefixes: (
      name: l10n.siPrefixes,
      imagePath: '$basePath/si_prefixes.svg'
    ),
    PROPERTYX.torque: (name: l10n.torque, imagePath: '$basePath/torque.svg')
  };
}

/// This will return a Map from a [PROPERTYX] to a Map from a unit key to the
/// name that will be displayed on the app.
Map<PROPERTYX, Map<dynamic, String>> getUnitUiMap(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return {
    PROPERTYX.length: {
      LENGTH.meters: l10n.meters,
      LENGTH.feet: l10n.feet,
      LENGTH.yards: l10n.yards,
      LENGTH.kilometers: l10n.kilometers,
      LENGTH.miles: l10n.miles,
      LENGTH.nauticalMiles: l10n.nauticalMiles,
      LENGTH.centimeters: l10n.centimeters,
      LENGTH.inches: l10n.inches,
      LENGTH.mils: l10n.mils,
      LENGTH.millimeters: l10n.millimeters,
      LENGTH.micrometers: l10n.micrometers,
      LENGTH.nanometers: l10n.nanometers,
      LENGTH.angstroms: l10n.angstroms,
      LENGTH.picometers: l10n.picometers,
      LENGTH.feetUs: l10n.feetUsSurvey,
      LENGTH.astronomicalUnits: l10n.astronomicalUnits,
      LENGTH.lightYears: l10n.lightYears,
      LENGTH.parsec: l10n.parsec,
    },
    PROPERTYX.area: {
      AREA.squareMeters: l10n.squareMeters,
      AREA.squareFeet: l10n.squareFeet,
      AREA.squareYard: l10n.squareYard,
      AREA.hectares: l10n.hectares,
      AREA.acres: l10n.acres,
      AREA.squareKilometers: l10n.squareKilometers,
      AREA.squareMiles: l10n.squareMiles,
      AREA.squareCentimeters: l10n.squareCentimeters,
      AREA.squareMillimeters: l10n.squareMillimeters,
      AREA.squareInches: l10n.squareInches,
      AREA.are: l10n.are,
      AREA.squareFeetUs: l10n.squareFeetUsSurvey,
    },
    PROPERTYX.volume: {
      VOLUME.cubicMeters: l10n.cubicMeters,
      VOLUME.liters: l10n.liters,
      VOLUME.usGallons: l10n.usGallons,
      VOLUME.imperialGallons: l10n.imperialGallons,
      VOLUME.usPints: l10n.usPints,
      VOLUME.imperialPints: l10n.imperialPints,
      VOLUME.milliliters: l10n.milliliters,
      VOLUME.tablespoonsUs: l10n.tablespoonUs,
      VOLUME.australianTablespoons: l10n.tablespoonAustralian,
      VOLUME.cups: l10n.cups,
      VOLUME.cubicMillimeters: l10n.cubicMillimeters,
      VOLUME.cubicCentimeters: l10n.cubicCentimeters,
      VOLUME.cubicInches: l10n.cubicInches,
      VOLUME.cubicFeet: l10n.cubicFeet,
      VOLUME.usFluidOunces: l10n.usFluidOunces,
      VOLUME.imperialFluidOunces: l10n.imperialFluidOunces,
      VOLUME.usGill: l10n.usGill,
      VOLUME.imperialGill: l10n.imperialGill,
    },
    PROPERTYX.currencies: {
      'USD': l10n.usd,
      'EUR': l10n.eur,
      'JPY': l10n.jpy,
      'GBP': l10n.gbp,
      'CNY': l10n.cny,
      'AUD': l10n.aud,
      'CAD': l10n.cad,
      'CHF': l10n.chf,
      'SEK': l10n.sek,
      'NOK': l10n.nok,
      'DKK': l10n.dkk,
      'KRW': l10n.krw,
      'MXN': l10n.mxn,
      'INR': l10n.inr,
      'BRL': l10n.brl,
      'ZAR': l10n.zar,
      'TRY': l10n.trY,
      'PLN': l10n.pln,
      'CZK': l10n.czk,
      'HUF': l10n.huf,
      'RON': l10n.ron,
      'BGN': l10n.bgn,
      'IDR': l10n.idr,
      'THB': l10n.thb,
      'PHP': l10n.php,
      'MYR': l10n.myr,
      'HKD': l10n.hkd,
      'SGD': l10n.sgd,
      'NZD': l10n.nzd,
      'ILS': l10n.ils,
      'ISK': l10n.isk,
    },
    PROPERTYX.time: {
      TIME.seconds: l10n.seconds,
      TIME.minutes: l10n.minutes,
      TIME.hours: l10n.hours,
      TIME.days: l10n.days,
      TIME.weeks: l10n.weeks,
      TIME.years365: l10n.years,
      TIME.lustrum: l10n.lustrum,
      TIME.decades: l10n.decades,
      TIME.centuries: l10n.centuries,
      TIME.millennium: l10n.millennium,
      TIME.deciseconds: l10n.deciseconds,
      TIME.centiseconds: l10n.centiseconds,
      TIME.milliseconds: l10n.milliseconds,
      TIME.microseconds: l10n.microseconds,
      TIME.nanoseconds: l10n.nanoseconds,
    },
    PROPERTYX.temperature: {
      TEMPERATURE.celsius: l10n.celsius,
      TEMPERATURE.fahrenheit: l10n.fahrenheit,
      TEMPERATURE.kelvin: l10n.kelvin,
      TEMPERATURE.reamur: l10n.reamur,
      TEMPERATURE.romer: l10n.romer,
      TEMPERATURE.delisle: l10n.delisle,
      TEMPERATURE.rankine: l10n.rankine,
    },
    PROPERTYX.speed: {
      SPEED.kilometersPerHour: l10n.kilometersHour,
      SPEED.milesPerHour: l10n.milesHour,
      SPEED.metersPerSecond: l10n.metersSecond,
      SPEED.feetsPerSecond: l10n.feetSecond,
      SPEED.knots: l10n.knots,
      SPEED.minutesPerKilometer: l10n.minutesPerKilometer,
    },
    PROPERTYX.mass: {
      MASS.kilograms: l10n.kilograms,
      MASS.pounds: l10n.pounds,
      MASS.ounces: l10n.ounces,
      MASS.tons: l10n.tons,
      MASS.grams: l10n.grams,
      MASS.ettograms: l10n.ettograms,
      MASS.centigrams: l10n.centigrams,
      MASS.milligrams: l10n.milligrams,
      MASS.carats: l10n.carats,
      MASS.quintals: l10n.quintals,
      MASS.pennyweights: l10n.pennyweights,
      MASS.troyOunces: l10n.troyOunces,
      MASS.uma: l10n.uma,
      MASS.stones: l10n.stones,
    },
    PROPERTYX.force: {
      FORCE.newton: l10n.newton,
      FORCE.kilogramForce: l10n.kilogramForce,
      FORCE.poundForce: l10n.poundForce,
      FORCE.dyne: l10n.dyne,
      FORCE.poundal: l10n.poundal,
    },
    PROPERTYX.fuelConsumption: {
      FUEL_CONSUMPTION.kilometersPerLiter: l10n.kilometersLiter,
      FUEL_CONSUMPTION.litersPer100km: l10n.liters100km,
      FUEL_CONSUMPTION.milesPerUsGallon: l10n.milesUsGallon,
      FUEL_CONSUMPTION.milesPerImperialGallon: l10n.milesImperialGallon,
    },
    PROPERTYX.numeralSystems: {
      NUMERAL_SYSTEMS.decimal: l10n.decimal,
      NUMERAL_SYSTEMS.hexadecimal: l10n.hexadecimal,
      NUMERAL_SYSTEMS.octal: l10n.octal,
      NUMERAL_SYSTEMS.binary: l10n.binary,
    },
    PROPERTYX.pressure: {
      PRESSURE.atmosphere: l10n.atmosphere,
      PRESSURE.bar: l10n.bar,
      PRESSURE.millibar: l10n.millibar,
      PRESSURE.psi: l10n.psi,
      PRESSURE.pascal: l10n.pascal,
      PRESSURE.torr: l10n.torr,
      PRESSURE.inchOfMercury: l10n.inchesOfMercury,
      PRESSURE.hectoPascal: l10n.hectoPascal,
    },
    PROPERTYX.energy: {
      ENERGY.kilowattHours: l10n.kilowattHour,
      ENERGY.kilocalories: l10n.kilocalories,
      ENERGY.calories: l10n.calories,
      ENERGY.joules: l10n.joule,
      ENERGY.electronvolts: l10n.electronvolt,
      ENERGY.energyFootPound: l10n.footPound,
    },
    PROPERTYX.power: {
      POWER.kilowatt: l10n.kilowatt,
      POWER.europeanHorsePower: l10n.europeanHorsePower,
      POWER.imperialHorsePower: l10n.imperialHorsePower,
      POWER.watt: l10n.watt,
      POWER.megawatt: l10n.megawatt,
      POWER.gigawatt: l10n.gigawatt,
      POWER.milliwatt: l10n.milliwatt,
    },
    PROPERTYX.angle: {
      ANGLE.degree: l10n.degree,
      ANGLE.radians: l10n.radiansDegree,
      ANGLE.minutes: l10n.minutes,
      ANGLE.seconds: l10n.seconds,
    },
    PROPERTYX.shoeSize: {
      SHOE_SIZE.centimeters: l10n.centimeters,
      SHOE_SIZE.inches: l10n.inches,
      SHOE_SIZE.euChina: l10n.euChina,
      SHOE_SIZE.usaCanadaChild: l10n.usaCanadaChild,
      SHOE_SIZE.usaCanadaMan: l10n.usaCanadaMan,
      SHOE_SIZE.usaCanadaWoman: l10n.usaCanadaWoman,
      SHOE_SIZE.ukIndiaChild: l10n.ukIndiaChild,
      SHOE_SIZE.ukIndiaMan: l10n.ukIndiaMan,
      SHOE_SIZE.ukIndiaWoman: l10n.ukIndiaWoman,
      SHOE_SIZE.japan: l10n.japan,
    },
    PROPERTYX.digitalData: {
      DIGITAL_DATA.byte: l10n.byte,
      DIGITAL_DATA.bit: l10n.bit,
      DIGITAL_DATA.nibble: l10n.nibble,
      DIGITAL_DATA.kilobyte: l10n.kilobyte,
      DIGITAL_DATA.megabyte: l10n.megabyte,
      DIGITAL_DATA.gigabyte: l10n.gigabyte,
      DIGITAL_DATA.terabyte: l10n.terabyte,
      DIGITAL_DATA.petabyte: l10n.petabyte,
      DIGITAL_DATA.exabyte: l10n.exabyte,
      DIGITAL_DATA.kibibyte: l10n.kibibyte,
      DIGITAL_DATA.mebibyte: l10n.mebibyte,
      DIGITAL_DATA.gibibyte: l10n.gibibyte,
      DIGITAL_DATA.tebibyte: l10n.tebibyte,
      DIGITAL_DATA.pebibyte: l10n.pebibyte,
      DIGITAL_DATA.exbibyte: l10n.exbibyte,
      DIGITAL_DATA.kilobit: l10n.kilobit,
      DIGITAL_DATA.megabit: l10n.megabit,
      DIGITAL_DATA.gigabit: l10n.gigabit,
      DIGITAL_DATA.terabit: l10n.terabit,
      DIGITAL_DATA.petabit: l10n.petabit,
      DIGITAL_DATA.exabit: l10n.exabit,
      DIGITAL_DATA.kibibit: l10n.kibibit,
      DIGITAL_DATA.mebibit: l10n.mebibit,
      DIGITAL_DATA.gibibit: l10n.gibibit,
      DIGITAL_DATA.tebibit: l10n.tebibit,
      DIGITAL_DATA.pebibit: l10n.pebibit,
      DIGITAL_DATA.exbibit: l10n.exbibit,
    },
    PROPERTYX.siPrefixes: {
      SI_PREFIXES.base: l10n.base,
      SI_PREFIXES.deca: l10n.deca,
      SI_PREFIXES.hecto: l10n.hecto,
      SI_PREFIXES.kilo: l10n.kilo,
      SI_PREFIXES.mega: l10n.mega,
      SI_PREFIXES.giga: l10n.giga,
      SI_PREFIXES.tera: l10n.tera,
      SI_PREFIXES.peta: l10n.peta,
      SI_PREFIXES.exa: l10n.exa,
      SI_PREFIXES.zetta: l10n.zetta,
      SI_PREFIXES.yotta: l10n.yotta,
      SI_PREFIXES.deci: l10n.deci,
      SI_PREFIXES.centi: l10n.centi,
      SI_PREFIXES.milli: l10n.milli,
      SI_PREFIXES.micro: l10n.micro,
      SI_PREFIXES.nano: l10n.nano,
      SI_PREFIXES.pico: l10n.pico,
      SI_PREFIXES.femto: l10n.femto,
      SI_PREFIXES.atto: l10n.atto,
      SI_PREFIXES.zepto: l10n.zepto,
      SI_PREFIXES.yocto: l10n.yocto,
    },
    PROPERTYX.torque: {
      TORQUE.newtonMeter: l10n.newtonMeter,
      TORQUE.kilogramForceMeter: l10n.kilogramForceMeter,
      TORQUE.dyneMeter: l10n.dyneMeter,
      TORQUE.poundForceFeet: l10n.poundForceFeet,
      TORQUE.poundalMeter: l10n.poundalMeter,
    }
  };
}

/// This method will return a List of [SearchUnit], needed in order to display the tiles in the search
List<SearchUnit> getSearchUnitsList(
    void Function(PROPERTYX) onTap, BuildContext context) {
  List<SearchUnit> searchUnitsList = [];
  final propertyUiMap = getPropertyUiMap(context);
  final unitUiMap = getUnitUiMap(context);

  for (final property in propertyUiMap.entries) {
    final propertyx = property.key;
    final propertyUi = property.value;
    final propertyImagePath = property.value.imagePath;
    // Add properties in search
    searchUnitsList.add(SearchUnit(
      iconAsset: propertyImagePath,
      unitName: propertyUi.name,
      onTap: () => onTap(property.key),
    ));
    // Add units in search
    searchUnitsList.addAll(
      unitUiMap[propertyx]!.values.map(
            (e) => SearchUnit(
              iconAsset: propertyImagePath,
              unitName: e,
              onTap: () => onTap(propertyx),
            ),
          ),
    );
  }

  return searchUnitsList;
}

/// This method will return a List of [SearchGridTile], needed in order to display the gridtiles in the search
List<SearchGridTile> initializeGridSearch(void Function(PROPERTYX) onTap,
    BuildContext context, bool darkMode, List<PROPERTYX> orderList) {
  final propertyUiMap = getPropertyUiMap(context);
  return orderList.map((e) {
    final propertyUi = propertyUiMap[e]!;
    return SearchGridTile(
      iconAsset: propertyUi.imagePath,
      footer: propertyUi.name,
      onTap: () => onTap(e),
      darkMode: darkMode,
    );
  }).toList();
}
