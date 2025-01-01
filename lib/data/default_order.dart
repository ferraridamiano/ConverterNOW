import 'package:converterpro/utils/utils.dart';
import 'package:units_converter/units_converter.dart';

const defaultPropertiesOrder = [
  PROPERTYX.length,
  PROPERTYX.area,
  PROPERTYX.volume,
  PROPERTYX.currencies,
  PROPERTYX.time,
  PROPERTYX.temperature,
  PROPERTYX.speed,
  PROPERTYX.mass,
  PROPERTYX.force,
  PROPERTYX.fuelConsumption,
  PROPERTYX.numeralSystems,
  PROPERTYX.pressure,
  PROPERTYX.energy,
  PROPERTYX.power,
  PROPERTYX.angle,
  PROPERTYX.shoeSize,
  PROPERTYX.digitalData,
  PROPERTYX.siPrefixes,
  PROPERTYX.torque,
];

const Map<PROPERTYX, List<dynamic>> defaultUnitsOrder = {
  PROPERTYX.length: [
    LENGTH.meters,
    LENGTH.feet,
    LENGTH.yards,
    LENGTH.kilometers,
    LENGTH.miles,
    LENGTH.nauticalMiles,
    LENGTH.centimeters,
    LENGTH.inches,
    LENGTH.mils,
    LENGTH.millimeters,
    LENGTH.micrometers,
    LENGTH.nanometers,
    LENGTH.angstroms,
    LENGTH.picometers,
    LENGTH.feetUs,
    LENGTH.astronomicalUnits,
    LENGTH.lightYears,
    LENGTH.parsec,
  ],
  PROPERTYX.area: [
    AREA.squareMeters,
    AREA.squareFeet,
    AREA.squareYard,
    AREA.hectares,
    AREA.acres,
    AREA.squareKilometers,
    AREA.squareMiles,
    AREA.squareCentimeters,
    AREA.squareMillimeters,
    AREA.squareInches,
    AREA.are,
    AREA.squareFeetUs,
  ],
  PROPERTYX.volume: [
    VOLUME.cubicMeters,
    VOLUME.liters,
    VOLUME.usGallons,
    VOLUME.imperialGallons,
    VOLUME.usPints,
    VOLUME.imperialPints,
    VOLUME.usQuarts,
    VOLUME.deciliters,
    VOLUME.centiliters,
    VOLUME.milliliters,
    VOLUME.microliters,
    VOLUME.tablespoonsUs,
    VOLUME.australianTablespoons,
    VOLUME.cups,
    VOLUME.cubicMillimeters,
    VOLUME.cubicCentimeters,
    VOLUME.cubicInches,
    VOLUME.cubicFeet,
    VOLUME.usFluidOunces,
    VOLUME.imperialFluidOunces,
    VOLUME.usGill,
    VOLUME.imperialGill,
  ],
  PROPERTYX.currencies: [
    'USD',
    'EUR',
    'JPY',
    'GBP',
    'CNY',
    'AUD',
    'CAD',
    'CHF',
    'SEK',
    'NOK',
    'DKK',
    'KRW',
    'MXN',
    'INR',
    'BRL',
    'ZAR',
    'TRY',
    'PLN',
    'CZK',
    'HUF',
    'RON',
    'BGN',
    'IDR',
    'THB',
    'PHP',
    'MYR',
    'HKD',
    'SGD',
    'NZD',
    'ILS',
    'ISK',
  ],
  PROPERTYX.time: [
    TIME.seconds,
    TIME.minutes,
    TIME.hours,
    TIME.days,
    TIME.weeks,
    TIME.years365,
    TIME.lustrum,
    TIME.decades,
    TIME.centuries,
    TIME.millennium,
    TIME.deciseconds,
    TIME.centiseconds,
    TIME.milliseconds,
    TIME.microseconds,
    TIME.nanoseconds,
  ],
  PROPERTYX.temperature: [
    TEMPERATURE.celsius,
    TEMPERATURE.fahrenheit,
    TEMPERATURE.kelvin,
    TEMPERATURE.reamur,
    TEMPERATURE.romer,
    TEMPERATURE.delisle,
    TEMPERATURE.rankine,
  ],
  PROPERTYX.speed: [
    SPEED.kilometersPerHour,
    SPEED.milesPerHour,
    SPEED.metersPerSecond,
    SPEED.feetsPerSecond,
    SPEED.knots,
    SPEED.minutesPerKilometer,
  ],
  PROPERTYX.mass: [
    MASS.kilograms,
    MASS.pounds,
    MASS.ounces,
    MASS.tons,
    MASS.grams,
    MASS.ettograms,
    MASS.centigrams,
    MASS.milligrams,
    MASS.carats,
    MASS.quintals,
    MASS.pennyweights,
    MASS.troyOunces,
    MASS.uma,
    MASS.stones,
  ],
  PROPERTYX.force: [
    FORCE.newton,
    FORCE.kilogramForce,
    FORCE.poundForce,
    FORCE.dyne,
    FORCE.poundal,
  ],
  PROPERTYX.fuelConsumption: [
    FUEL_CONSUMPTION.kilometersPerLiter,
    FUEL_CONSUMPTION.litersPer100km,
    FUEL_CONSUMPTION.milesPerUsGallon,
    FUEL_CONSUMPTION.milesPerImperialGallon,
  ],
  PROPERTYX.numeralSystems: [
    NUMERAL_SYSTEMS.decimal,
    NUMERAL_SYSTEMS.hexadecimal,
    NUMERAL_SYSTEMS.octal,
    NUMERAL_SYSTEMS.binary,
  ],
  PROPERTYX.pressure: [
    PRESSURE.atmosphere,
    PRESSURE.bar,
    PRESSURE.millibar,
    PRESSURE.psi,
    PRESSURE.pascal,
    PRESSURE.kiloPascal,
    PRESSURE.torr,
    PRESSURE.inchOfMercury,
    PRESSURE.hectoPascal,
  ],
  PROPERTYX.energy: [
    ENERGY.kilowattHours,
    ENERGY.kilocalories,
    ENERGY.calories,
    ENERGY.joules,
    ENERGY.kilojoules,
    ENERGY.electronvolts,
    ENERGY.energyFootPound,
  ],
  PROPERTYX.power: [
    POWER.kilowatt,
    POWER.europeanHorsePower,
    POWER.imperialHorsePower,
    POWER.watt,
    POWER.megawatt,
    POWER.gigawatt,
    POWER.milliwatt,
  ],
  PROPERTYX.angle: [
    ANGLE.degree,
    ANGLE.radians,
    ANGLE.minutes,
    ANGLE.seconds,
  ],
  PROPERTYX.shoeSize: [
    SHOE_SIZE.centimeters,
    SHOE_SIZE.inches,
    SHOE_SIZE.euChina,
    SHOE_SIZE.usaCanadaChild,
    SHOE_SIZE.usaCanadaMan,
    SHOE_SIZE.usaCanadaWoman,
    SHOE_SIZE.ukIndiaChild,
    SHOE_SIZE.ukIndiaMan,
    SHOE_SIZE.ukIndiaWoman,
    SHOE_SIZE.japan,
  ],
  PROPERTYX.digitalData: [
    DIGITAL_DATA.byte,
    DIGITAL_DATA.bit,
    DIGITAL_DATA.nibble,
    DIGITAL_DATA.kilobyte,
    DIGITAL_DATA.megabyte,
    DIGITAL_DATA.gigabyte,
    DIGITAL_DATA.terabyte,
    DIGITAL_DATA.petabyte,
    DIGITAL_DATA.exabyte,
    DIGITAL_DATA.kibibyte,
    DIGITAL_DATA.mebibyte,
    DIGITAL_DATA.gibibyte,
    DIGITAL_DATA.tebibyte,
    DIGITAL_DATA.pebibyte,
    DIGITAL_DATA.exbibyte,
    DIGITAL_DATA.kilobit,
    DIGITAL_DATA.megabit,
    DIGITAL_DATA.gigabit,
    DIGITAL_DATA.terabit,
    DIGITAL_DATA.petabit,
    DIGITAL_DATA.exabit,
    DIGITAL_DATA.kibibit,
    DIGITAL_DATA.mebibit,
    DIGITAL_DATA.gibibit,
    DIGITAL_DATA.tebibit,
    DIGITAL_DATA.pebibit,
    DIGITAL_DATA.exbibit,
  ],
  PROPERTYX.siPrefixes: [
    SI_PREFIXES.base,
    SI_PREFIXES.deca,
    SI_PREFIXES.hecto,
    SI_PREFIXES.kilo,
    SI_PREFIXES.mega,
    SI_PREFIXES.giga,
    SI_PREFIXES.tera,
    SI_PREFIXES.peta,
    SI_PREFIXES.exa,
    SI_PREFIXES.zetta,
    SI_PREFIXES.yotta,
    SI_PREFIXES.deci,
    SI_PREFIXES.centi,
    SI_PREFIXES.milli,
    SI_PREFIXES.micro,
    SI_PREFIXES.nano,
    SI_PREFIXES.pico,
    SI_PREFIXES.femto,
    SI_PREFIXES.atto,
    SI_PREFIXES.zepto,
    SI_PREFIXES.yocto,
  ],
  PROPERTYX.torque: [
    TORQUE.newtonMeter,
    TORQUE.kilogramForceMeter,
    TORQUE.dyneMeter,
    TORQUE.poundForceFeet,
    TORQUE.poundalMeter,
  ]
};
