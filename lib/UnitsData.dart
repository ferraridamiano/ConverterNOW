import 'package:converter_pro/Localization.dart';
import 'package:flutter/widgets.dart';
import 'Utils.dart';
import 'UtilsConversion.dart';

initializeUnits(BuildContext context, listaOrder, currencyValues){
  Node metro=Node(name: MyLocalizations.of(context).trans('metro',),symbol:"[m]",order: listaOrder[0][0],
        leafNodes: [
          Node(isMultiplication: false, coefficientPer: 100.0, name: MyLocalizations.of(context).trans('centimetro'),symbol:"[cm]",order: listaOrder[0][1], leafNodes: [
            Node(isMultiplication: true, coefficientPer: 2.54, name: MyLocalizations.of(context).trans('pollice'),symbol:"[in]",order: listaOrder[0][2], leafNodes: [
              Node(isMultiplication: true, coefficientPer: 12.0, name: MyLocalizations.of(context).trans('piede'),symbol:"[ft]",order: listaOrder[0][3]),
            ]),
          ]),
          Node(isMultiplication: true, coefficientPer: 1852.0, name: MyLocalizations.of(context).trans('miglio_marino'),symbol:"[M]",order: listaOrder[0][4],),
          Node(isMultiplication: true, coefficientPer: 0.9144, name: MyLocalizations.of(context).trans('yard'),symbol:"[yd]",order: listaOrder[0][5], leafNodes: [
            Node(isMultiplication: true, coefficientPer: 1760.0, name: MyLocalizations.of(context).trans('miglio_terrestre'),symbol:"[mi]",order: listaOrder[0][6],),
          ]),
          Node(isMultiplication: false, coefficientPer: 1000.0, name: MyLocalizations.of(context).trans('millimetro'),symbol:"[mm]",order: listaOrder[0][7],),
          Node(isMultiplication: false, coefficientPer: 1000000.0, name: MyLocalizations.of(context).trans('micrometro'),symbol:"[µm]", order: listaOrder[0][8],),
          Node(isMultiplication: false, coefficientPer: 1000000000.0, name: MyLocalizations.of(context).trans('nanometro'),symbol:"[nm]",order: listaOrder[0][9],),
          Node(isMultiplication: false, coefficientPer: 10000000000.0, name: MyLocalizations.of(context).trans('angstrom'),symbol:"[Å]",order: listaOrder[0][10],),
          Node(isMultiplication: false, coefficientPer: 1000000000000.0, name: MyLocalizations.of(context).trans('picometro'),symbol:"[pm]",order: listaOrder[0][11],),
          Node(isMultiplication: true, coefficientPer: 1000.0, name: MyLocalizations.of(context).trans('chilometro'),symbol:"[km]",order: listaOrder[0][12],leafNodes: [
            Node(isMultiplication: true, coefficientPer: 149597870.7, name: MyLocalizations.of(context).trans('unita_astronomica'),symbol:"[au]",order: listaOrder[0][13],leafNodes: [
              Node(isMultiplication: true, coefficientPer: 63241.1, name: MyLocalizations.of(context).trans('anno_luce'),symbol:"[ly]",order: listaOrder[0][14],leafNodes: [
                Node(isMultiplication: true, coefficientPer: 3.26, name: MyLocalizations.of(context).trans('parsec'),symbol:"[pc]",order: listaOrder[0][15],),
              ]),
            ]),
          ]),
        ]);

    Node metroq=Node(name: MyLocalizations.of(context).trans('metro_quadrato'),symbol:"[m²]",order: listaOrder[1][0],leafNodes: [
      Node(isMultiplication: false, coefficientPer: 10000.0, name: MyLocalizations.of(context).trans('centimetro_quadrato'),symbol:"[cm²]",order: listaOrder[1][1], leafNodes: [
        Node(isMultiplication: true, coefficientPer: 6.4516, name: MyLocalizations.of(context).trans('pollice_quadrato'),symbol:"[in²]",order: listaOrder[1][2], leafNodes: [
          Node(isMultiplication: true, coefficientPer: 144.0, name: MyLocalizations.of(context).trans('piede_quadrato'),symbol:"[ft²]",order: listaOrder[1][3]),
        ]),
      ]),
      Node(isMultiplication: false, coefficientPer: 1000000.0, name: MyLocalizations.of(context).trans('millimetro_quadrato'),symbol:"[mm²]",order: listaOrder[1][4],),
      Node(isMultiplication: true, coefficientPer: 10000.0, name: MyLocalizations.of(context).trans('ettaro'),symbol:"[he]",order: listaOrder[1][5],),
      Node(isMultiplication: true, coefficientPer: 1000000.0, name: MyLocalizations.of(context).trans('chilometro_quadrato'),symbol:"[km²]",order: listaOrder[1][6],),
      Node(isMultiplication: true, coefficientPer: 0.83612736, name: MyLocalizations.of(context).trans('yard_quadrato'),symbol:"[yd²]",order: listaOrder[1][7], leafNodes: [
        Node(isMultiplication: true, coefficientPer: 3097600.0, name: MyLocalizations.of(context).trans('miglio_quadrato'),symbol:"[mi²]",order: listaOrder[1][8]),
        Node(isMultiplication: true, coefficientPer: 4840.0, name: MyLocalizations.of(context).trans('acri'),symbol:"[ac]",order: listaOrder[1][9],),
      ]),
      Node(isMultiplication: true, coefficientPer: 100.0, name: MyLocalizations.of(context).trans('ara'),symbol:"[a]",order: listaOrder[1][10],),
    ]);

    Node metroc=Node(name: MyLocalizations.of(context).trans('metro_cubo'),symbol:"[m³]",order: listaOrder[2][0],leafNodes: [
      Node(isMultiplication: false, coefficientPer: 1000.0, name: MyLocalizations.of(context).trans('litro'),symbol:"[l]",order: listaOrder[2][1],leafNodes: [
        Node(isMultiplication: true, coefficientPer: 4.54609, name: MyLocalizations.of(context).trans('gallone_imperiale'),symbol:"[imp gal]",order: listaOrder[2][2],),
        Node(isMultiplication: true, coefficientPer: 3.785411784, name: MyLocalizations.of(context).trans('gallone_us'),symbol:"[US gal]",order: listaOrder[2][3],),
        Node(isMultiplication: true, coefficientPer: 0.56826125, name: MyLocalizations.of(context).trans('pinta_imperiale'),symbol:"[imp pt]",order: listaOrder[2][4],),
        Node(isMultiplication: true, coefficientPer: 0.473176473, name: MyLocalizations.of(context).trans('pinta_us'),symbol:"[US pt]",order: listaOrder[2][5],),
        Node(isMultiplication: false, coefficientPer: 1000.0, name: MyLocalizations.of(context).trans('millilitro'),symbol:"[ml]",order: listaOrder[2][6], leafNodes: [
          Node(isMultiplication: true, coefficientPer: 14.8, name: MyLocalizations.of(context).trans('tablespoon_us'),symbol:"[tbsp.]",order: listaOrder[2][7],),
          Node(isMultiplication: true, coefficientPer: 20.0, name: MyLocalizations.of(context).trans('tablespoon_australian'),symbol:"[tbsp.]",order:listaOrder[2][8],),
          Node(isMultiplication: true, coefficientPer: 240.0, name: MyLocalizations.of(context).trans('cup_us'),symbol:"[cup]",order: listaOrder[2][9],),
        ]),
      ]),
      Node(isMultiplication: false, coefficientPer: 1000000.0, name: MyLocalizations.of(context).trans('centimetro_cubo'),symbol:"[cm³]",order: listaOrder[2][10], leafNodes: [
        Node(isMultiplication: true, coefficientPer: 16.387064, name: MyLocalizations.of(context).trans('pollice_cubo'),symbol:"[in³]",order: listaOrder[2][11], leafNodes: [
          Node(isMultiplication: true, coefficientPer: 1728.0, name: MyLocalizations.of(context).trans('piede_cubo'),symbol:"[ft³]",order: listaOrder[2][12],),
        ]),
      ]),
      Node(isMultiplication: false, coefficientPer: 1000000000.0, name: MyLocalizations.of(context).trans('millimetro_cubo'),symbol:"[mm³]",order: listaOrder[2][13],),
    ]);

    Node secondo=Node(name: MyLocalizations.of(context).trans('secondo'),symbol:"[s]",order: listaOrder[3][0],
        leafNodes: [
          Node(isMultiplication: false, coefficientPer: 10.0, name: MyLocalizations.of(context).trans('decimo_secondo'),symbol:"[ds]",order: listaOrder[3][1],),
          Node(isMultiplication: false, coefficientPer: 100.0, name: MyLocalizations.of(context).trans('centesimo_secondo'),symbol:"[cs]", order: listaOrder[3][2],),
          Node(isMultiplication: false, coefficientPer: 1000.0, name: MyLocalizations.of(context).trans('millisecondo'),symbol:"[ms]",order: listaOrder[3][3],),
          Node(isMultiplication: false, coefficientPer: 1000000.0, name: MyLocalizations.of(context).trans('microsecondo'),symbol:"[µs]",order: listaOrder[3][4],),
          Node(isMultiplication: false, coefficientPer: 1000000000.0, name: MyLocalizations.of(context).trans('nanosecondo'),symbol:"[ns]",order: listaOrder[3][5],),
          Node(isMultiplication: true, coefficientPer: 60.0, name: MyLocalizations.of(context).trans('minuti'),symbol:"[min]",order: listaOrder[3][6],leafNodes: [
            Node(isMultiplication: true, coefficientPer: 60.0, name: MyLocalizations.of(context).trans('ore'),symbol:"[h]",order: listaOrder[3][7],leafNodes: [
              Node(isMultiplication: true, coefficientPer: 24.0, name: MyLocalizations.of(context).trans('giorni'),symbol:"[d]",order: listaOrder[3][8],leafNodes: [
                Node(isMultiplication: true, coefficientPer: 7.0, name: MyLocalizations.of(context).trans('settimane'),order: listaOrder[3][9],),
                Node(isMultiplication: true, coefficientPer: 365.0, name: MyLocalizations.of(context).trans('anno'),symbol:"[a]",order: listaOrder[3][10],leafNodes: [
                  Node(isMultiplication: true, coefficientPer: 5.0, name: MyLocalizations.of(context).trans('lustro'),order: listaOrder[3][11],),
                  Node(isMultiplication: true, coefficientPer: 10.0, name: MyLocalizations.of(context).trans('decade'),order: listaOrder[3][12],),
                  Node(isMultiplication: true, coefficientPer: 100.0, name: MyLocalizations.of(context).trans('secolo'),symbol:"[c.]",order: listaOrder[3][13],),
                  Node(isMultiplication: true, coefficientPer: 1000.0, name: MyLocalizations.of(context).trans('millennio'),order: listaOrder[3][14],),
                ]),
              ]),
            ]),
          ]),
        ]);

    Node celsius=Node(name: MyLocalizations.of(context).trans('fahrenheit'),symbol:"[°F]",order: listaOrder[4][0],leafNodes:[
      Node(isMultiplication: true, coefficientPer: 1.8, isSum: true, coefficientPlus: 32.0, name: MyLocalizations.of(context).trans('celsius'),symbol:"[°C]",order: listaOrder[4][1],leafNodes: [
        Node(isSum: false, coefficientPlus: 273.15, name: MyLocalizations.of(context).trans('kelvin'),symbol:"[K]",order: listaOrder[4][2],),
        Node(isMultiplication: true, coefficientPer: 5/4, name: "Reamur",symbol:"[°Re]",order: listaOrder[4][3],),
        Node(isMultiplication: true, coefficientPer: 40/21, isSum: true, coefficientPlus: -100/7,  name: "Rømer",symbol:"[°Rø]",order: listaOrder[4][4],),
        Node(isMultiplication: true, coefficientPer: -2/3, isSum: true, coefficientPlus: 100,  name: "Delisle",symbol:"[°De]",order: listaOrder[4][5],),
      ]),
      Node(isSum: false, coefficientPlus: 459.67, name: "Rankine",symbol:"[°R]",order: listaOrder[4][6],),
    ]);

    Node metriSecondo=Node(name: MyLocalizations.of(context).trans('metri_secondo'),symbol:"[m/s]", order: listaOrder[5][0], leafNodes: [
      Node(isMultiplication: false, coefficientPer: 3.6, name: MyLocalizations.of(context).trans('chilometri_ora'),symbol:"[km/h]",order: listaOrder[5][1], leafNodes:[
        Node(isMultiplication: true, coefficientPer: 1.609344, name: MyLocalizations.of(context).trans('miglia_ora'),symbol:"[mph]",order: listaOrder[5][2],),
        Node(isMultiplication: true, coefficientPer: 1.852, name: MyLocalizations.of(context).trans('nodi'),symbol:"[kts]",order: listaOrder[5][3],),
      ]),
      Node(isMultiplication: true, coefficientPer: 0.3048, name: MyLocalizations.of(context).trans('piedi_secondo'),symbol:"[ft/s]",order: listaOrder[5][4],),
    ]);

    Node si=Node(name: "Base",symbol:"[10º]",order: listaOrder[6][0],
        leafNodes: [
          Node(isMultiplication: true, coefficientPer: 10.0, name: "Deca-",symbol:"[da][10¹]",order: listaOrder[6][1],),
          Node(isMultiplication: true, coefficientPer: 100.0, name: "Hecto-",symbol:"[h][10²]",order: listaOrder[6][2],),
          Node(isMultiplication: true, coefficientPer: 1000.0, name: "Kilo-",symbol:"[k][10³]",order: listaOrder[6][3],),
          Node(isMultiplication: true, coefficientPer: 1000000.0, name: "Mega-",symbol:"[M][10⁶]",order: listaOrder[6][4],),
          Node(isMultiplication: true, coefficientPer: 1000000000.0, name: "Giga-",symbol:"[G][10⁹]",order: listaOrder[6][5],),
          Node(isMultiplication: true, coefficientPer: 1000000000000.0, name: "Tera-",symbol:"[T][10¹²]",order: listaOrder[6][6],),
          Node(isMultiplication: true, coefficientPer: 1000000000000000.0, name: "Peta-",symbol:"[P][10¹⁵]",order: listaOrder[6][7],),
          Node(isMultiplication: true, coefficientPer: 1000000000000000000.0, name: "Exa-",symbol:"[E][10¹⁸]",order: listaOrder[6][8],),
          Node(isMultiplication: true, coefficientPer: 1000000000000000000000.0, name: "Zetta-",symbol:"[Z][10²¹]",order: listaOrder[6][9],),
          Node(isMultiplication: true, coefficientPer: 1000000000000000000000000.0, name: "Yotta-",symbol:"[Y][10²⁴]",order: listaOrder[6][10],),
          Node(isMultiplication: false, coefficientPer: 10.0, name: "Deci-",symbol:"[d][10⁻¹]",order: listaOrder[6][11],),
          Node(isMultiplication: false, coefficientPer: 100.0, name: "Centi-",symbol:"[c][10⁻²]",order: listaOrder[6][12],),
          Node(isMultiplication: false, coefficientPer: 1000.0, name: "Milli-",symbol:"[m][10⁻³]",order: listaOrder[6][13],),
          Node(isMultiplication: false, coefficientPer: 1000000.0, name: "Micro-",symbol:"[µ][10⁻⁶]",order: listaOrder[6][14],),
          Node(isMultiplication: false, coefficientPer: 1000000000.0, name: "Nano-",symbol:"[n][10⁻⁹]",order: listaOrder[6][15],),
          Node(isMultiplication: false, coefficientPer: 1000000000000.0, name: "Pico-",symbol:"[p][10⁻¹²]",order: listaOrder[6][16],),
          Node(isMultiplication: false, coefficientPer: 1000000000000000.0, name: "Femto-",symbol:"[f][10⁻¹⁵]",order: listaOrder[6][17],),
          Node(isMultiplication: false, coefficientPer: 1000000000000000000.0, name: "Atto-",symbol:"[a][10⁻¹⁸]",order: listaOrder[6][18],),
          Node(isMultiplication: false, coefficientPer: 1000000000000000000000.0, name: "Zepto-",symbol:"[z][10⁻²¹]",order: listaOrder[6][19],),
          Node(isMultiplication: false, coefficientPer: 1000000000000000000000000.0, name: "Yocto-",symbol:"[y][10⁻²⁴]",order: listaOrder[6][20],),
        ]
    );

    Node grammo=Node(name: MyLocalizations.of(context).trans('grammo'),symbol:"[g]",order: listaOrder[7][0],
      leafNodes: [
      Node(isMultiplication: true, coefficientPer: 100.0, name: MyLocalizations.of(context).trans('ettogrammo'),symbol:"[hg]",order: listaOrder[7][1],),
      Node(isMultiplication: true, coefficientPer: 1000.0, name: MyLocalizations.of(context).trans('chilogrammo'),symbol:"[kg]",order: listaOrder[7][2],leafNodes:[
        Node(isMultiplication: true, coefficientPer: 0.45359237, name: MyLocalizations.of(context).trans('libbra'),symbol:"[lb]",order: listaOrder[7][3],leafNodes: [
          Node(isMultiplication: false, coefficientPer: 16.0, name: MyLocalizations.of(context).trans('oncia'),symbol:"[oz]",order: listaOrder[7][4],)
        ]),
      ]),
      Node(isMultiplication: true, coefficientPer: 100000.0, name: MyLocalizations.of(context).trans('quintale'),order: listaOrder[7][5],),
      Node(isMultiplication: true, coefficientPer: 1000000.0, name: MyLocalizations.of(context).trans('tonnellata'),symbol:"[t]",order: listaOrder[7][6],),
      Node(isMultiplication: false, coefficientPer: 1000.0, name: MyLocalizations.of(context).trans('milligrammo'),symbol:"[mg]",order: listaOrder[7][7],),
      Node(isMultiplication: true, coefficientPer: 1.660539e-24, name: MyLocalizations.of(context).trans('uma'),symbol:"[u]",order: listaOrder[7][8],),
      Node(isMultiplication: true, coefficientPer: 0.2, name: MyLocalizations.of(context).trans('carato'),symbol:"[ct]",order: listaOrder[7][9],),
    ]);

    Node pascal=Node(name: MyLocalizations.of(context).trans('pascal'),symbol:"[Pa]",order: listaOrder[8][0],
        leafNodes: [
          Node(isMultiplication: true, coefficientPer: 101325.0, name: MyLocalizations.of(context).trans('atmosfere'),symbol:"[atm]",order: listaOrder[8][1],leafNodes:[
            Node(isMultiplication: true, coefficientPer: 0.987, name: MyLocalizations.of(context).trans('bar'),symbol:"[bar]",order: listaOrder[8][2],leafNodes:[
              Node(isMultiplication: false, coefficientPer: 1000.0, name: MyLocalizations.of(context).trans('millibar'),symbol:"[mbar]",order: listaOrder[8][3],),
            ]),
          ]),
          Node(isMultiplication: true, coefficientPer: 6894.757293168, name: MyLocalizations.of(context).trans('psi'),symbol:"[psi]",order: listaOrder[8][4],),
          Node(isMultiplication: true, coefficientPer: 133.322368421, name: MyLocalizations.of(context).trans('torr'),symbol:"(mmHg) [torr]",order: listaOrder[8][5],),
    ]);

    Node joule=Node(name: MyLocalizations.of(context).trans('joule'),symbol:"[J]",order: listaOrder[9][0],
        leafNodes: [
          Node(isMultiplication: true, coefficientPer: 4.1867999409, name: MyLocalizations.of(context).trans('calorie'),symbol:"[cal]",order: listaOrder[9][1]),
          Node(isMultiplication: true, coefficientPer: 3600000.0, name: MyLocalizations.of(context).trans('kilowattora'),symbol:"[kwh]",order: listaOrder[9][2],),
          Node(isMultiplication: true, coefficientPer: 1.60217646e-19, name: MyLocalizations.of(context).trans('elettronvolt'),symbol:"[eV]",order: listaOrder[9][3],),
        ]);
    Node gradi=Node(name:MyLocalizations.of(context).trans('gradi'),symbol:"[°]",order: listaOrder[10][0],
        leafNodes: [
          Node(isMultiplication: false, coefficientPer: 60.0, name: MyLocalizations.of(context).trans('primi'),symbol:"[']",order: listaOrder[10][1]),
          Node(isMultiplication: false, coefficientPer: 3600.0, name: MyLocalizations.of(context).trans('secondi'),symbol:"['']",order: listaOrder[10][2]),
          Node(isMultiplication: true, coefficientPer: 57.295779513, name: MyLocalizations.of(context).trans('radianti'),symbol:"[rad]",order: listaOrder[10][3]),
    ]);

    Node eur=Node(name:MyLocalizations.of(context).trans('EUR',),symbol:MyLocalizations.of(context).trans('eu'),order: listaOrder[11][0],
        leafNodes: [
          Node(isMultiplication: false, coefficientPer: currencyValues['USD'], name: MyLocalizations.of(context).trans('USD'),symbol:MyLocalizations.of(context).trans('us'),order: listaOrder[11][1]),
          Node(isMultiplication: false, coefficientPer: currencyValues['GBP'], name: MyLocalizations.of(context).trans('GBP'),symbol:MyLocalizations.of(context).trans('gb'),order: listaOrder[11][2]),
          Node(isMultiplication: false, coefficientPer: currencyValues['INR'], name: MyLocalizations.of(context).trans('INR'),symbol:MyLocalizations.of(context).trans('in'),order: listaOrder[11][3]),
          Node(isMultiplication: false, coefficientPer: currencyValues['CNY'], name: MyLocalizations.of(context).trans('CNY'),symbol:MyLocalizations.of(context).trans('cn'),order: listaOrder[11][4]),
          Node(isMultiplication: false, coefficientPer: currencyValues['JPY'], name: MyLocalizations.of(context).trans('JPY'),symbol:MyLocalizations.of(context).trans('jp'),order: listaOrder[11][5]),
          Node(isMultiplication: false, coefficientPer: currencyValues['CHF'], name: MyLocalizations.of(context).trans('CHF'),symbol:MyLocalizations.of(context).trans('ch'),order: listaOrder[11][6]),
          Node(isMultiplication: false, coefficientPer: currencyValues['SEK'], name: MyLocalizations.of(context).trans('SEK'),symbol:MyLocalizations.of(context).trans('se'),order: listaOrder[11][7]),
          Node(isMultiplication: false, coefficientPer: currencyValues['RUB'], name: MyLocalizations.of(context).trans('RUB'),symbol:MyLocalizations.of(context).trans('ru'),order: listaOrder[11][8]),
          Node(isMultiplication: false, coefficientPer: currencyValues['CAD'], name: MyLocalizations.of(context).trans('CAD'),symbol:MyLocalizations.of(context).trans('ca'),order: listaOrder[11][9]),
          Node(isMultiplication: false, coefficientPer: currencyValues['KRW'], name: MyLocalizations.of(context).trans('KRW'),symbol:MyLocalizations.of(context).trans('kr'),order: listaOrder[11][10]),
          Node(isMultiplication: false, coefficientPer: currencyValues['BRL'], name: MyLocalizations.of(context).trans('BRL'),symbol:MyLocalizations.of(context).trans('br'),order: listaOrder[11][11]),
          Node(isMultiplication: false, coefficientPer: currencyValues['HKD'], name: MyLocalizations.of(context).trans('HKD'),symbol:MyLocalizations.of(context).trans('hk'),order: listaOrder[11][12]),
          Node(isMultiplication: false, coefficientPer: currencyValues['AUD'], name: MyLocalizations.of(context).trans('AUD'),symbol:MyLocalizations.of(context).trans('au'),order: listaOrder[11][13]),
          Node(isMultiplication: false, coefficientPer: currencyValues['NZD'], name: MyLocalizations.of(context).trans('NZD'),symbol:MyLocalizations.of(context).trans('nz'),order: listaOrder[11][14]),
          Node(isMultiplication: false, coefficientPer: currencyValues['MXN'], name: MyLocalizations.of(context).trans('MXN'),symbol:MyLocalizations.of(context).trans('mx'),order: listaOrder[11][15]),
          Node(isMultiplication: false, coefficientPer: currencyValues['SGD'], name: MyLocalizations.of(context).trans('SGD'),symbol:MyLocalizations.of(context).trans('sg'),order: listaOrder[11][16]),
          Node(isMultiplication: false, coefficientPer: currencyValues['NOK'], name: MyLocalizations.of(context).trans('NOK'),symbol:MyLocalizations.of(context).trans('no'),order: listaOrder[11][17]),
          Node(isMultiplication: false, coefficientPer: currencyValues['TRY'], name: MyLocalizations.of(context).trans('TRY'),symbol:MyLocalizations.of(context).trans('tr'),order: listaOrder[11][18]),
          Node(isMultiplication: false, coefficientPer: currencyValues['ZAR'], name: MyLocalizations.of(context).trans('ZAR'),symbol:MyLocalizations.of(context).trans('za'),order: listaOrder[11][19]),
          Node(isMultiplication: false, coefficientPer: currencyValues['DKK'], name: MyLocalizations.of(context).trans('DKK'),symbol:MyLocalizations.of(context).trans('dk'),order: listaOrder[11][20]),
          Node(isMultiplication: false, coefficientPer: currencyValues['PLN'], name: MyLocalizations.of(context).trans('PLN'),symbol:MyLocalizations.of(context).trans('pl'),order: listaOrder[11][21]),
          Node(isMultiplication: false, coefficientPer: currencyValues['THB'], name: MyLocalizations.of(context).trans('THB'),symbol:MyLocalizations.of(context).trans('th'),order: listaOrder[11][22]),
          Node(isMultiplication: false, coefficientPer: currencyValues['MYR'], name: MyLocalizations.of(context).trans('MYR'),symbol:MyLocalizations.of(context).trans('my'),order: listaOrder[11][23]),
          Node(isMultiplication: false, coefficientPer: currencyValues['HUF'], name: MyLocalizations.of(context).trans('HUF'),symbol:MyLocalizations.of(context).trans('hu'),order: listaOrder[11][24]),
          Node(isMultiplication: false, coefficientPer: currencyValues['CZK'], name: MyLocalizations.of(context).trans('CZK'),symbol:MyLocalizations.of(context).trans('cz'),order: listaOrder[11][25]),
          Node(isMultiplication: false, coefficientPer: currencyValues['ILS'], name: MyLocalizations.of(context).trans('ILS'),symbol:MyLocalizations.of(context).trans('il'),order: listaOrder[11][26]),
          Node(isMultiplication: false, coefficientPer: currencyValues['IDR'], name: MyLocalizations.of(context).trans('IDR'),symbol:MyLocalizations.of(context).trans('id'),order: listaOrder[11][27]),
          Node(isMultiplication: false, coefficientPer: currencyValues['PHP'], name: MyLocalizations.of(context).trans('PHP'),symbol:MyLocalizations.of(context).trans('ph'),order: listaOrder[11][28]),
          Node(isMultiplication: false, coefficientPer: currencyValues['RON'], name: MyLocalizations.of(context).trans('RON'),symbol:MyLocalizations.of(context).trans('ro'),order: listaOrder[11][29]),
    ]);

    Node centimetriScarpe=Node(name:MyLocalizations.of(context).trans('centimetro',), symbol: "[cm]",order: listaOrder[12][0],
        leafNodes: [
          Node(isMultiplication: false, coefficientPer: 1.5, coefficientPlus: 1.5, isSum: false, name: MyLocalizations.of(context).trans('eu_cina'),order: listaOrder[12][1]),
          Node(isMultiplication: true, coefficientPer: 2.54, name: MyLocalizations.of(context).trans('pollice'),symbol: '[in]',order: listaOrder[12][2], 
          leafNodes: [
            Node(isMultiplication: false, coefficientPer: 3.0, coefficientPlus: 4, isSum: true, name: MyLocalizations.of(context).trans('uk_india_bambino'),order: listaOrder[12][3]),
            Node(isMultiplication: false, coefficientPer: 3.0, coefficientPlus: 8.3333333, name: MyLocalizations.of(context).trans('uk_india_uomo'),order: listaOrder[12][4]),
            Node(isMultiplication: false, coefficientPer: 3.0, coefficientPlus: 8.5, name: MyLocalizations.of(context).trans('uk_india_donna'),order: listaOrder[12][5]),
            Node(isMultiplication: false, coefficientPer: 3.0, coefficientPlus: 3.89, isSum: true, name: MyLocalizations.of(context).trans('usa_canada_bambino'),order: listaOrder[12][6]),
            Node(isMultiplication: false, coefficientPer: 3.0, coefficientPlus: 8.0, name: MyLocalizations.of(context).trans('usa_canada_uomo'),order: listaOrder[12][7]),
            Node(isMultiplication: false, coefficientPer: 3.0, coefficientPlus: 7.5, name: MyLocalizations.of(context).trans('usa_canada_donna'),order: listaOrder[12][8]),
          ]),
          Node(coefficientPlus: 1.5, isSum: false, name: MyLocalizations.of(context).trans('giappone'),order: listaOrder[12][9]),
          
    ]);

    Node bit=Node(name: "Bit",symbol: "[b]",order: listaOrder[13][0],
        leafNodes: [
          Node(isMultiplication: true, coefficientPer: 4.0, name: "Nibble",order: listaOrder[13][2],),
          Node(isMultiplication: true, coefficientPer: 1000.0, name: "Kilobit",symbol: "[kb]",order: listaOrder[13][3],),
          Node(isMultiplication: true, coefficientPer: 1000000.0, name: "Megabit",symbol: "[Mb]",order: listaOrder[13][7],),
          Node(isMultiplication: true, coefficientPer: 1000000000.0, name: "Gigabit",symbol: "[Gb]",order: listaOrder[13][11],),
          Node(isMultiplication: true, coefficientPer: 1000000000000.0, name: "Terabit",symbol: "[Tb]",order: listaOrder[13][15],),
          Node(isMultiplication: true, coefficientPer: 1000000000000000.0, name: "Petabit",symbol: "[Pb]",order: listaOrder[13][19],),
          Node(isMultiplication: true, coefficientPer: 1000000000000000000.0, name: "Exabit",symbol: "[Eb]",order: listaOrder[13][23],),
          Node(isMultiplication: true, coefficientPer: 1024.0, name: "Kibibit",symbol: "[Kibit]",order: listaOrder[13][5],leafNodes: [
            Node(isMultiplication: true, coefficientPer: 1024.0, name: "Mebibit",symbol: "[Mibit]",order: listaOrder[13][9],leafNodes: [
              Node(isMultiplication: true, coefficientPer: 1024.0, name: "Gibibit",symbol: "[Gibit]",order: listaOrder[13][13],leafNodes: [
                Node(isMultiplication: true, coefficientPer: 1024.0, name: "Tebibit",symbol: "[Tibit]",order: listaOrder[13][17],leafNodes: [
                  Node(isMultiplication: true, coefficientPer: 1024.0, name: "Pebibit",symbol: "[Pibit]",order: listaOrder[13][21],leafNodes: [
                    Node(isMultiplication: true, coefficientPer: 1024.0, name: "Exbibit",symbol: "[Eibit]",order: listaOrder[13][25])
                  ])
                ])
              ])
            ])
          ]),
          Node(isMultiplication: true, coefficientPer: 8.0, name: "Byte",symbol: "[B]",order: listaOrder[13][1],leafNodes: [
            Node(isMultiplication: true, coefficientPer: 1000.0, name: "Kilobyte",symbol: "[kB]",order: listaOrder[13][4],),
            Node(isMultiplication: true, coefficientPer: 1000000.0, name: "Megabyte",symbol: "[MB]",order: listaOrder[13][8],),
            Node(isMultiplication: true, coefficientPer: 1000000000.0, name: "Gigabyte",symbol: "[GB]",order: listaOrder[13][12],),
            Node(isMultiplication: true, coefficientPer: 1000000000000.0, name: "Terabyte",symbol: "[TB]",order: listaOrder[13][16],),
            Node(isMultiplication: true, coefficientPer: 1000000000000000.0, name: "Petabyte",symbol: "[PB]",order: listaOrder[13][20],),
            Node(isMultiplication: true, coefficientPer: 1000000000000000000.0, name: "Exabyte",symbol: "[EB]",order: listaOrder[13][24],),
            Node(isMultiplication: true, coefficientPer: 1024.0, name: "Kibibyte",symbol: "[KiB]",order: listaOrder[13][6],leafNodes: [
              Node(isMultiplication: true, coefficientPer: 1024.0, name: "Mebibyte",symbol: "[MiB]",order: listaOrder[13][10],leafNodes: [
                Node(isMultiplication: true, coefficientPer: 1024.0, name: "Gibibyte",symbol: "[GiB]",order: listaOrder[13][14],leafNodes: [
                  Node(isMultiplication: true, coefficientPer: 1024.0, name: "Tebibyte",symbol: "[TiB]",order: listaOrder[13][18],leafNodes: [
                    Node(isMultiplication: true, coefficientPer: 1024.0, name: "Pebibyte",symbol: "[PiB]",order: listaOrder[13][22],leafNodes: [
                      Node(isMultiplication: true, coefficientPer: 1024.0, name: "Exbibyte",symbol: "[EiB]",order: listaOrder[13][26])
                    ])
                  ])
                ])
              ])
            ]),
          ]),
        ]
    );

    Node watt=Node(name: MyLocalizations.of(context).trans('watt'), symbol: "[W]",order: listaOrder[14][0],
        leafNodes: [
          Node(isMultiplication: false, coefficientPer: 1000.0, name: MyLocalizations.of(context).trans('milliwatt'), symbol: "[W]",order: listaOrder[14][1],),
          Node(isMultiplication: true, coefficientPer: 1000.0, name: MyLocalizations.of(context).trans('kilowatt'), symbol: "[kW]",order: listaOrder[14][2],),
          Node(isMultiplication: true, coefficientPer: 1000000.0, name: MyLocalizations.of(context).trans('megawatt'), symbol: "[MW]",order: listaOrder[14][3],),
          Node(isMultiplication: true, coefficientPer: 1000000000.0, name: MyLocalizations.of(context).trans('gigawatt'), symbol: "[GW]",order: listaOrder[14][4],),
          Node(isMultiplication: true, coefficientPer: 735.49875, name: MyLocalizations.of(context).trans('cavallo_vapore_eurpeo'), symbol: "[hp(M)]",order: listaOrder[14][5],),
          Node(isMultiplication: true, coefficientPer: 745.69987158, name: MyLocalizations.of(context).trans('cavallo_vapore_imperiale'), symbol: "[hp(I)]",order: listaOrder[14][6],),
    ]);

    Node newton=Node(name: MyLocalizations.of(context).trans('newton'),symbol: "[N]",order: listaOrder[15][0],
        leafNodes: [
          Node(isMultiplication: false, coefficientPer: 100000.0, name: MyLocalizations.of(context).trans('dyne'),symbol: "[dyn]",order: listaOrder[15][1],),
          Node(isMultiplication: true, coefficientPer: 4.4482216152605 , name: MyLocalizations.of(context).trans('libbra_forza'),symbol: "[lbf]",order: listaOrder[15][2],),
          Node(isMultiplication: true, coefficientPer: 9.80665, name: MyLocalizations.of(context).trans('kilogrammo_forza'),symbol: "[kgf]",order: listaOrder[15][3],),
          Node(isMultiplication: true, coefficientPer: 0.138254954376, name: MyLocalizations.of(context).trans('poundal'),symbol: "[pdl]",order: listaOrder[15][4],),
    ]);

    Node newtonMetro=Node(name: MyLocalizations.of(context).trans('newton_metro'),symbol: "[N·m]",order: listaOrder[16][0],
        leafNodes: [
          Node(isMultiplication: false, coefficientPer: 100000.0, name: MyLocalizations.of(context).trans('dyne_metro'),symbol:"[dyn·m]",order: listaOrder[16][1],),
          Node(isMultiplication: false, coefficientPer: 0.7375621489 , name: MyLocalizations.of(context).trans('libbra_forza_piede'),symbol: "[lbf·ft]",order: listaOrder[16][2],),
          Node(isMultiplication: false, coefficientPer: 0.10196798205363515, name: MyLocalizations.of(context).trans('kilogrammo_forza_metro'),symbol: "[kgf·m]",order: listaOrder[16][3],),
          Node(isMultiplication: true, coefficientPer: 0.138254954376, name: MyLocalizations.of(context).trans('poundal_metro'),symbol: "[pdl·m]",order: listaOrder[16][4],),
    ]);

    Node chilometriLitro=Node(name: MyLocalizations.of(context).trans('chilometri_litro'),symbol: "[km/l]",order: listaOrder[17][0],
        leafNodes: [
          Node(conversionType: RECIPROCO_CONVERSION,coefficientPer: 100.0, name: MyLocalizations.of(context).trans('litri_100km'),symbol: "[l/100km]",order: listaOrder[17][1],),
          Node(coefficientPer: 0.4251437074 , name: MyLocalizations.of(context).trans('miglia_gallone_us'),symbol: "[mpg]",order: listaOrder[17][2],),
          Node(coefficientPer: 0.3540061899, name: MyLocalizations.of(context).trans('miglia_gallone_uk'),symbol: "[mpg]",order: listaOrder[17][3],),
    ]);

    Node baseDecimale=Node(name: MyLocalizations.of(context).trans('decimale'),base: 10,keyboardType: KEYBOARD_NUMBER_INTEGER,symbol: "[₁₀]",order: listaOrder[18][0],
        leafNodes: [
          Node(conversionType: BASE_CONVERSION,base: 16,keyboardType: KEYBOARD_COMPLETE,name: MyLocalizations.of(context).trans('esadecimale'),symbol: "[₁₆]",order: listaOrder[18][1],),
          Node(conversionType: BASE_CONVERSION,base: 8,keyboardType: KEYBOARD_NUMBER_INTEGER, name: MyLocalizations.of(context).trans('ottale'),symbol: "[₈]",order: listaOrder[18][2],),
          Node(conversionType: BASE_CONVERSION,base: 2,keyboardType: KEYBOARD_NUMBER_INTEGER, name: MyLocalizations.of(context).trans('binario'),symbol: "[₂]",order: listaOrder[18][3],),
    ]);


    return [metro,metroq, metroc,secondo, celsius, metriSecondo,si,grammo,pascal,joule,gradi,eur, centimetriScarpe,bit,watt,newton, newtonMetro, chilometriLitro, baseDecimale];
    //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    
}

List<SearchUnit> initializeSearchUnits(Function onTap, Map jsonSearch) {

  return [
          SearchUnit(iconAsset: "lunghezza", unitName: jsonSearch["lunghezza"], onTap: (){onTap(0);}),
          SearchUnit(iconAsset: "lunghezza", unitName: jsonSearch["metro"], onTap: (){onTap(0);}),
          SearchUnit(iconAsset: "lunghezza", unitName: jsonSearch["centimetro"], onTap: (){onTap(0);}),
          SearchUnit(iconAsset: "lunghezza", unitName: jsonSearch["pollice"], onTap: (){onTap(0);}),
          SearchUnit(iconAsset: "lunghezza", unitName: jsonSearch["piede"], onTap: (){onTap(0);}),
          SearchUnit(iconAsset: "lunghezza", unitName: jsonSearch["miglio_marino"], onTap: (){onTap( 0);}),
          SearchUnit(iconAsset: "lunghezza", unitName: jsonSearch["miglio_terrestre"], onTap: (){onTap(0);}),
          SearchUnit(iconAsset: "lunghezza", unitName: jsonSearch["yard"], onTap: (){onTap(0);}),
          SearchUnit(iconAsset: "lunghezza", unitName: jsonSearch["millimetro"], onTap: (){onTap(0);}),
          SearchUnit(iconAsset: "lunghezza", unitName: jsonSearch["micrometro"], onTap: (){onTap(0);}),
          SearchUnit(iconAsset: "lunghezza", unitName: jsonSearch["nanometro"], onTap: (){onTap(0);}),
          SearchUnit(iconAsset: "lunghezza", unitName: jsonSearch["angstrom"], onTap: (){onTap(0);}),
          SearchUnit(iconAsset: "lunghezza", unitName: jsonSearch["picometro"], onTap: (){onTap( 0);}),
          SearchUnit(iconAsset: "lunghezza", unitName: jsonSearch["chilometro"], onTap: (){onTap(0);}),
          SearchUnit(iconAsset: "lunghezza", unitName: jsonSearch["unita_astronomica"], onTap: (){onTap(0);}),
          SearchUnit(iconAsset: "lunghezza", unitName: jsonSearch["anno_luce"], onTap: (){onTap(0);}),
          SearchUnit(iconAsset: "lunghezza", unitName: jsonSearch["parsec"], onTap: (){onTap(0);}),
    
          SearchUnit(iconAsset: "area", unitName: jsonSearch["superficie"], onTap: (){onTap(1);}),
          SearchUnit(iconAsset: "area", unitName: jsonSearch["metro_quadrato"], onTap: (){onTap(1);}),
          SearchUnit(iconAsset: "area", unitName: jsonSearch["centimetro_quadrato"], onTap: (){onTap(1);}),
          SearchUnit(iconAsset: "area", unitName: jsonSearch["pollice_quadrato"], onTap: (){onTap(1);}),
          SearchUnit(iconAsset: "area", unitName: jsonSearch["piede_quadrato"], onTap: (){onTap(1);}),
          SearchUnit(iconAsset: "area", unitName: jsonSearch["miglio_quadrato"], onTap: (){onTap(1);}),
          SearchUnit(iconAsset: "area", unitName: jsonSearch["yard_quadrato"], onTap: (){onTap(1);}),
          SearchUnit(iconAsset: "area", unitName: jsonSearch["millimetro_quadrato"], onTap: (){onTap(1);}),
          SearchUnit(iconAsset: "area", unitName: jsonSearch["chilometro_quadrato"], onTap: (){onTap(1);}),
          SearchUnit(iconAsset: "area", unitName: jsonSearch["ettaro"], onTap: (){onTap(1);}),
          SearchUnit(iconAsset: "area", unitName: jsonSearch["acri"], onTap: (){onTap(1);}),
          SearchUnit(iconAsset: "area", unitName: jsonSearch["ara"], onTap: (){onTap(1);}),
          
          SearchUnit(iconAsset: "volume", unitName: jsonSearch["volume"], onTap: (){onTap(2);}),
          SearchUnit(iconAsset: "volume", unitName: jsonSearch["metro_cubo"], onTap: (){onTap();}),
          SearchUnit(iconAsset: "volume", unitName: jsonSearch["litro"], onTap: (){onTap(2);}),
          SearchUnit(iconAsset: "volume", unitName: jsonSearch["gallone_imperiale"], onTap: (){onTap(2);}),
          SearchUnit(iconAsset: "volume", unitName: jsonSearch["gallone_us"], onTap: (){onTap(2);}),
          SearchUnit(iconAsset: "volume", unitName: jsonSearch["pinta_imperiale"], onTap: (){onTap(2);}),
          SearchUnit(iconAsset: "volume", unitName: jsonSearch["pinta_us"], onTap: (){onTap(2);}),
          SearchUnit(iconAsset: "volume", unitName: jsonSearch["millilitro"], onTap: (){onTap(2);}),
          SearchUnit(iconAsset: "volume", unitName: jsonSearch["tablespoon_us"], onTap: (){onTap(2);}),
          SearchUnit(iconAsset: "volume", unitName: jsonSearch["tablespoon_australian"], onTap: (){onTap(2);}),
          SearchUnit(iconAsset: "volume", unitName: jsonSearch["cup_us"], onTap: (){onTap(2);}),
          SearchUnit(iconAsset: "volume", unitName: jsonSearch["centimetro_cubo"], onTap: (){onTap(2);}),
          SearchUnit(iconAsset: "volume", unitName: jsonSearch["piede_cubo"], onTap: (){onTap(2);}),
          SearchUnit(iconAsset: "volume", unitName: jsonSearch["pollice_cubo"], onTap: (){onTap(2);}),
          SearchUnit(iconAsset: "volume", unitName: jsonSearch["millimetro_cubo"], onTap: (){onTap(2);}),
    
          SearchUnit(iconAsset: "tempo", unitName: jsonSearch["tempo"], onTap: (){onTap(3);}),
          SearchUnit(iconAsset: "tempo", unitName: jsonSearch["secondo"], onTap: (){onTap(3);}),
          SearchUnit(iconAsset: "tempo", unitName: jsonSearch["decimo_secondo"], onTap: (){onTap(3);}),
          SearchUnit(iconAsset: "tempo", unitName: jsonSearch["centesimo_secondo"], onTap: (){onTap(3);}),
          SearchUnit(iconAsset: "tempo", unitName: jsonSearch["millisecondo"], onTap: (){onTap(3);}),
          SearchUnit(iconAsset: "tempo", unitName: jsonSearch["microsecondo"], onTap: (){onTap(3);}),
          SearchUnit(iconAsset: "tempo", unitName: jsonSearch["nanosecondo"], onTap: (){onTap(3);}),
          SearchUnit(iconAsset: "tempo", unitName: jsonSearch["minuti"], onTap: (){onTap(3);}),
          SearchUnit(iconAsset: "tempo", unitName: jsonSearch["ore"], onTap: (){onTap(3);}),
          SearchUnit(iconAsset: "tempo", unitName: jsonSearch["giorni"], onTap: (){onTap(3);}),
          SearchUnit(iconAsset: "tempo", unitName: jsonSearch["settimane"], onTap: (){onTap(3);}),
          SearchUnit(iconAsset: "tempo", unitName: jsonSearch["anno"], onTap: (){onTap(3);}),
          SearchUnit(iconAsset: "tempo", unitName: jsonSearch["lustro"], onTap: (){onTap(3);}),
          SearchUnit(iconAsset: "tempo", unitName: jsonSearch["decade"], onTap: (){onTap(3);}),
          SearchUnit(iconAsset: "tempo", unitName: jsonSearch["secolo"], onTap: (){onTap(3);}),
          SearchUnit(iconAsset: "tempo", unitName: jsonSearch["millennio"], onTap: (){onTap(3);}),
    
          SearchUnit(iconAsset: "temperatura", unitName: jsonSearch["temperatura"], onTap: (){onTap(4);}),
          SearchUnit(iconAsset: "temperatura", unitName: jsonSearch["fahrenheit"], onTap: (){onTap(4);}),
          SearchUnit(iconAsset: "temperatura", unitName: jsonSearch["celsius"], onTap: (){onTap(4);}),
          SearchUnit(iconAsset: "temperatura", unitName: jsonSearch["kelvin"], onTap: (){onTap(4);}),
          SearchUnit(iconAsset: "temperatura", unitName: "Delisle", onTap: (){onTap(4);}),
          SearchUnit(iconAsset: "temperatura", unitName: "Rømer", onTap: (){onTap(4);}),
          SearchUnit(iconAsset: "temperatura", unitName: "Reamur", onTap: (){onTap(4);}),
          SearchUnit(iconAsset: "temperatura", unitName: "Rankine", onTap: (){onTap(4);}),
    
          SearchUnit(iconAsset: "velocita", unitName: jsonSearch["velocita"], onTap: (){onTap(5);}),
          SearchUnit(iconAsset: "velocita", unitName: jsonSearch["metri_secondo"], onTap: (){onTap(5);}),
          SearchUnit(iconAsset: "velocita", unitName: jsonSearch["chilometri_ora"], onTap: (){onTap(5);}),
          SearchUnit(iconAsset: "velocita", unitName: jsonSearch["miglia_ora"], onTap: (){onTap(5);}),
          SearchUnit(iconAsset: "velocita", unitName: jsonSearch["nodi"], onTap: (){onTap(5);}),
          SearchUnit(iconAsset: "velocita", unitName: jsonSearch["piedi_secondo"], onTap: (){onTap(5);}),

          SearchUnit(iconAsset: "prefissi", unitName: jsonSearch["prefissi_si"], onTap: (){onTap(6);}),
          SearchUnit(iconAsset: "prefissi", unitName: "Base", onTap: (){onTap(6);}),
          SearchUnit(iconAsset: "prefissi", unitName: "Deca", onTap: (){onTap(6);}),
          SearchUnit(iconAsset: "prefissi", unitName: "Hecto", onTap: (){onTap(6);}),
          SearchUnit(iconAsset: "prefissi", unitName: "Kilo", onTap: (){onTap(6);}),
          SearchUnit(iconAsset: "prefissi", unitName: "Mega", onTap: (){onTap(6);}),
          SearchUnit(iconAsset: "prefissi", unitName: "Giga", onTap: (){onTap(6);}),
          SearchUnit(iconAsset: "prefissi", unitName: "Tera", onTap: (){onTap(6);}),
          SearchUnit(iconAsset: "prefissi", unitName: "Peta", onTap: (){onTap(6);}),
          SearchUnit(iconAsset: "prefissi", unitName: "Exa", onTap: (){onTap(6);}),
          SearchUnit(iconAsset: "prefissi", unitName: "Zetta", onTap: (){onTap(6);}),
          SearchUnit(iconAsset: "prefissi", unitName: "Yotta", onTap: (){onTap(6);}),
          SearchUnit(iconAsset: "prefissi", unitName: "Deci", onTap: (){onTap(6);}),
          SearchUnit(iconAsset: "prefissi", unitName: "Centi", onTap: (){onTap(6);}),
          SearchUnit(iconAsset: "prefissi", unitName: "Milli", onTap: (){onTap(6);}),
          SearchUnit(iconAsset: "prefissi", unitName: "Micro", onTap: (){onTap(6);}),
          SearchUnit(iconAsset: "prefissi", unitName: "Nano", onTap: (){onTap(6);}),
          SearchUnit(iconAsset: "prefissi", unitName: "Pico", onTap: (){onTap(6);}),
          SearchUnit(iconAsset: "prefissi", unitName: "Femto", onTap: (){onTap(6);}),
          SearchUnit(iconAsset: "prefissi", unitName: "Atto", onTap: (){onTap(6);}),
          SearchUnit(iconAsset: "prefissi", unitName: "Zepto", onTap: (){onTap(6);}),
          SearchUnit(iconAsset: "prefissi", unitName: "Yocto", onTap: (){onTap(6);}),

          SearchUnit(iconAsset: "massa", unitName: jsonSearch["massa"], onTap: (){onTap(7);}),
          SearchUnit(iconAsset: "massa", unitName: jsonSearch["grammo"], onTap: (){onTap(7);}),
          SearchUnit(iconAsset: "massa", unitName: jsonSearch["ettogrammo"], onTap: (){onTap(7);}),
          SearchUnit(iconAsset: "massa", unitName: jsonSearch["chilogrammo"], onTap: (){onTap(7);}),
          SearchUnit(iconAsset: "massa", unitName: jsonSearch["libbra"], onTap: (){onTap(7);}),
          SearchUnit(iconAsset: "massa", unitName: jsonSearch["quintale"], onTap: (){onTap(7);}),
          SearchUnit(iconAsset: "massa", unitName: jsonSearch["tonnellata"], onTap: (){onTap(7);}),
          SearchUnit(iconAsset: "massa", unitName: jsonSearch["milligrammo"], onTap: (){onTap(7);}),
          SearchUnit(iconAsset: "massa", unitName: jsonSearch["uma"], onTap: (){onTap(7);}),
          SearchUnit(iconAsset: "massa", unitName: jsonSearch["carato"], onTap: (){onTap(7);}),

          SearchUnit(iconAsset: "pressione", unitName: jsonSearch["pressione"], onTap: (){onTap(8);}),
          SearchUnit(iconAsset: "pressione", unitName: jsonSearch["pascal"], onTap: (){onTap( 8);}),
          SearchUnit(iconAsset: "pressione", unitName: jsonSearch["atmosfere"], onTap: (){onTap(8);}),
          SearchUnit(iconAsset: "pressione", unitName: jsonSearch["bar"], onTap: (){onTap(8);}),
          SearchUnit(iconAsset: "pressione", unitName: jsonSearch["millibar"], onTap: (){onTap(8);}),
          SearchUnit(iconAsset: "pressione", unitName: jsonSearch["psi"], onTap: (){onTap(8);}),
          SearchUnit(iconAsset: "pressione", unitName: jsonSearch["torr"], onTap: (){onTap(8);}),

          SearchUnit(iconAsset: "energia", unitName: jsonSearch["energia"], onTap: (){onTap(9);}),
          SearchUnit(iconAsset: "energia", unitName: jsonSearch["joule"], onTap: (){onTap(9);}),
          SearchUnit(iconAsset: "energia", unitName: jsonSearch["calorie"], onTap: (){onTap(9);}),
          SearchUnit(iconAsset: "energia", unitName: jsonSearch["kilowattora"], onTap: (){onTap(9);}),
          SearchUnit(iconAsset: "energia", unitName: jsonSearch["elettronvolt"], onTap: (){onTap(9);}),

          SearchUnit(iconAsset: "angoli", unitName: jsonSearch["angoli"], onTap: (){onTap(10);}),
          SearchUnit(iconAsset: "angoli", unitName: jsonSearch["gradi"], onTap: (){onTap(10);}),
          SearchUnit(iconAsset: "angoli", unitName: jsonSearch["primi"], onTap: (){onTap(10);}),
          SearchUnit(iconAsset: "angoli", unitName: jsonSearch["secondi"], onTap: (){onTap(10);}),
          SearchUnit(iconAsset: "angoli", unitName: jsonSearch["radianti"], onTap: (){onTap(10);}),

          SearchUnit(iconAsset: "valuta", unitName: jsonSearch["valuta"], onTap: (){onTap(11);}),
          SearchUnit(iconAsset: "valuta", unitName: jsonSearch["USD"], onTap: (){onTap(11);}),
          SearchUnit(iconAsset: "valuta", unitName: jsonSearch["EUR"], onTap: (){onTap(11);}),
          SearchUnit(iconAsset: "valuta", unitName: jsonSearch["GBP"], onTap: (){onTap(11);}),
          SearchUnit(iconAsset: "valuta", unitName: jsonSearch["INR"], onTap: (){onTap(11);}),
          SearchUnit(iconAsset: "valuta", unitName: jsonSearch["CNY"], onTap: (){onTap(11);}),
          SearchUnit(iconAsset: "valuta", unitName: jsonSearch["JPY"], onTap: (){onTap(11);}),
          SearchUnit(iconAsset: "valuta", unitName: jsonSearch["CHF"], onTap: (){onTap(11);}),
          SearchUnit(iconAsset: "valuta", unitName: jsonSearch["SEK"], onTap: (){onTap(11);}),
          SearchUnit(iconAsset: "valuta", unitName: jsonSearch["RUB"], onTap: (){onTap(11);}),
          SearchUnit(iconAsset: "valuta", unitName: jsonSearch["CAD"], onTap: (){onTap(11);}),
          SearchUnit(iconAsset: "valuta", unitName: jsonSearch["KRW"], onTap: (){onTap(11);}),
          SearchUnit(iconAsset: "valuta", unitName: jsonSearch["BRL"], onTap: (){onTap(11);}),
          SearchUnit(iconAsset: "valuta", unitName: jsonSearch["HKD"], onTap: (){onTap(11);}),
          SearchUnit(iconAsset: "valuta", unitName: jsonSearch["AUD"], onTap: (){onTap(11);}),
          SearchUnit(iconAsset: "valuta", unitName: jsonSearch["NZD"], onTap: (){onTap(11);}),
          SearchUnit(iconAsset: "valuta", unitName: jsonSearch["MXN"], onTap: (){onTap(11);}),
          SearchUnit(iconAsset: "valuta", unitName: jsonSearch["SGD"], onTap: (){onTap(11);}),
          SearchUnit(iconAsset: "valuta", unitName: jsonSearch["NOK"], onTap: (){onTap(11);}),
          SearchUnit(iconAsset: "valuta", unitName: jsonSearch["TRY"], onTap: (){onTap(11);}),
          SearchUnit(iconAsset: "valuta", unitName: jsonSearch["ZAR"], onTap: (){onTap(11);}),
          SearchUnit(iconAsset: "valuta", unitName: jsonSearch["DKK"], onTap: (){onTap(11);}),
          SearchUnit(iconAsset: "valuta", unitName: jsonSearch["PLN"], onTap: (){onTap(11);}),
          SearchUnit(iconAsset: "valuta", unitName: jsonSearch["THB"], onTap: (){onTap(11);}),
          SearchUnit(iconAsset: "valuta", unitName: jsonSearch["MYR"], onTap: (){onTap(11);}),
          SearchUnit(iconAsset: "valuta", unitName: jsonSearch["HUF"], onTap: (){onTap(11);}),
          SearchUnit(iconAsset: "valuta", unitName: jsonSearch["CZK"], onTap: (){onTap(11);}),
          SearchUnit(iconAsset: "valuta", unitName: jsonSearch["ILS"], onTap: (){onTap(11);}),
          SearchUnit(iconAsset: "valuta", unitName: jsonSearch["IDR"], onTap: (){onTap(11);}),
          SearchUnit(iconAsset: "valuta", unitName: jsonSearch["PHP"], onTap: (){onTap(11);}),
          SearchUnit(iconAsset: "valuta", unitName: jsonSearch["RON"], onTap: (){onTap(11);}),

          SearchUnit(iconAsset: "scarpe", unitName: jsonSearch["taglia_scarpe"], onTap: (){onTap(12);}),

          SearchUnit(iconAsset: "dati", unitName: jsonSearch["dati_digitali"], onTap: (){onTap(13);}),
          SearchUnit(iconAsset: "dati", unitName: "Bit", onTap: (){onTap(13);}),
          SearchUnit(iconAsset: "dati", unitName: "Nibble", onTap: (){onTap(13);}),
          SearchUnit(iconAsset: "dati", unitName: "Kilobit", onTap: (){onTap(13);}),
          SearchUnit(iconAsset: "dati", unitName: "Megabit", onTap: (){onTap(13);}),
          SearchUnit(iconAsset: "dati", unitName: "Gigabit", onTap: (){onTap(13);}),
          SearchUnit(iconAsset: "dati", unitName: "Terabit", onTap: (){onTap(13);}),
          SearchUnit(iconAsset: "dati", unitName: "Petabit", onTap: (){onTap(13);}),
          SearchUnit(iconAsset: "dati", unitName: "Exabit", onTap: (){onTap(13);}),
          SearchUnit(iconAsset: "dati", unitName: "Kibibit", onTap: (){onTap(13);}),
          SearchUnit(iconAsset: "dati", unitName: "Mebibit", onTap: (){onTap(13);}),
          SearchUnit(iconAsset: "dati", unitName: "Gibibit", onTap: (){onTap(13);}),
          SearchUnit(iconAsset: "dati", unitName: "Tebibit", onTap: (){onTap(13);}),
          SearchUnit(iconAsset: "dati", unitName: "Pebibit", onTap: (){onTap(13);}),
          SearchUnit(iconAsset: "dati", unitName: "Exbibit", onTap: (){onTap(13);}),
          SearchUnit(iconAsset: "dati", unitName: "Byte", onTap: (){onTap(13);}),
          SearchUnit(iconAsset: "dati", unitName: "Kilobyte", onTap: (){onTap(13);}),
          SearchUnit(iconAsset: "dati", unitName: "Megabyte", onTap: (){onTap(13);}),
          SearchUnit(iconAsset: "dati", unitName: "Gigabyte", onTap: (){onTap(13);}),
          SearchUnit(iconAsset: "dati", unitName: "Terabyte", onTap: (){onTap(13);}),
          SearchUnit(iconAsset: "dati", unitName: "Petabyte", onTap: (){onTap(13);}),
          SearchUnit(iconAsset: "dati", unitName: "Kibibyte", onTap: (){onTap(13);}),
          SearchUnit(iconAsset: "dati", unitName: "Mebibyte", onTap: (){onTap(13);}),
          SearchUnit(iconAsset: "dati", unitName: "Gibibyte", onTap: (){onTap(13);}),
          SearchUnit(iconAsset: "dati", unitName: "Tebibyte", onTap: (){onTap(13);}),
          SearchUnit(iconAsset: "dati", unitName: "Pebibyte", onTap: (){onTap(13);}),
          SearchUnit(iconAsset: "dati", unitName: "Exbibyte", onTap: (){onTap(13);}),

          SearchUnit(iconAsset: "potenza", unitName: jsonSearch["potenza"], onTap: (){onTap(14);}),
          SearchUnit(iconAsset: "potenza", unitName: jsonSearch["watt"], onTap: (){onTap(14);}),
          SearchUnit(iconAsset: "potenza", unitName: jsonSearch["milliwatt"], onTap: (){onTap(14);}),
          SearchUnit(iconAsset: "potenza", unitName: jsonSearch["kilowatt"], onTap: (){onTap(14);}),
          SearchUnit(iconAsset: "potenza", unitName: jsonSearch["megawatt"], onTap: (){onTap(14);}),
          SearchUnit(iconAsset: "potenza", unitName: jsonSearch["gigawatt"], onTap: (){onTap(14);}),
          SearchUnit(iconAsset: "potenza", unitName: jsonSearch["cavallo_vapore_eurpeo"], onTap: (){onTap(14);}),
          SearchUnit(iconAsset: "potenza", unitName: jsonSearch["cavallo_vapore_imperiale"], onTap: (){onTap(14);}),

          SearchUnit(iconAsset: "forza", unitName: jsonSearch["forza"], onTap: (){onTap(15);}),
          SearchUnit(iconAsset: "forza", unitName: jsonSearch["newton"], onTap: (){onTap(15);}),
          SearchUnit(iconAsset: "forza", unitName: jsonSearch["dyne"], onTap: (){onTap(15);}),
          SearchUnit(iconAsset: "forza", unitName: jsonSearch["libbra_forza"], onTap: (){onTap(15);}),
          SearchUnit(iconAsset: "forza", unitName: jsonSearch["kilogrammo_forza"], onTap: (){onTap(15);}),
          SearchUnit(iconAsset: "forza", unitName: jsonSearch["poundal"], onTap: (){onTap(15);}),

          SearchUnit(iconAsset: "torque", unitName: jsonSearch["momento"], onTap: (){onTap(16);}),
          SearchUnit(iconAsset: "torque", unitName: jsonSearch["newton_metro"], onTap: (){onTap(16);}),
          SearchUnit(iconAsset: "torque", unitName: jsonSearch["dyne_metro"], onTap: (){onTap(16);}),
          SearchUnit(iconAsset: "torque", unitName: jsonSearch["libbra_forza_piede"], onTap: (){onTap(16);}),
          SearchUnit(iconAsset: "torque", unitName: jsonSearch["kilogrammo_forza_metro"], onTap: (){onTap(16);}),
          SearchUnit(iconAsset: "torque", unitName: jsonSearch["poundal_metro"], onTap: (){onTap(16);}),

          SearchUnit(iconAsset: "consumo", unitName: jsonSearch["consumo_carburante"], onTap: (){onTap(17);}),
          SearchUnit(iconAsset: "consumo", unitName: jsonSearch["chilometri_litro"], onTap: (){onTap(17);}),
          SearchUnit(iconAsset: "consumo", unitName: jsonSearch["litri_100km"], onTap: (){onTap(17);}),
          SearchUnit(iconAsset: "consumo", unitName: jsonSearch["miglia_gallone_us"], onTap: (){onTap(17);}),
          SearchUnit(iconAsset: "consumo", unitName: jsonSearch["miglia_gallone_uk"], onTap: (){onTap(17);}),

          SearchUnit(iconAsset: "conversione_base", unitName: jsonSearch["basi_numeriche"], onTap: (){onTap(18);}),
          SearchUnit(iconAsset: "conversione_base", unitName: jsonSearch["decimale"], onTap: (){onTap(18);}),
          SearchUnit(iconAsset: "conversione_base", unitName: jsonSearch["esadecimale"], onTap: (){onTap(18);}),
          SearchUnit(iconAsset: "conversione_base", unitName: jsonSearch["ottale"], onTap: (){onTap(18);}),
          SearchUnit(iconAsset: "conversione_base", unitName: jsonSearch["binario"], onTap: (){onTap(18);}),
        ];
}
List<SearchGridTile> initializeGridSearch(Function onTap, Map jsonSearch, bool darkMode){
  return [
          SearchGridTile(iconAsset: "lunghezza", footer: jsonSearch["lunghezza"], onTap: (){onTap(0);}, darkMode: darkMode,),
          SearchGridTile(iconAsset: "area", footer: jsonSearch["superficie"], onTap: (){onTap(1);}, darkMode: darkMode,),
          SearchGridTile(iconAsset: "volume", footer: jsonSearch["volume"], onTap: (){onTap(2);}, darkMode: darkMode,),
          SearchGridTile(iconAsset: "tempo", footer: jsonSearch["tempo"], onTap: (){onTap(3);}, darkMode: darkMode,),
          SearchGridTile(iconAsset: "temperatura", footer: jsonSearch["temperatura"], onTap: (){onTap(4);}, darkMode: darkMode,),
          SearchGridTile(iconAsset: "velocita", footer: jsonSearch["velocita"], onTap: (){onTap(5);}, darkMode: darkMode,),
          SearchGridTile(iconAsset: "massa", footer: jsonSearch["massa"], onTap: (){onTap(7);}, darkMode: darkMode,),
          SearchGridTile(iconAsset: "pressione", footer: jsonSearch["pressione"], onTap: (){onTap(8);}, darkMode: darkMode,),
          SearchGridTile(iconAsset: "energia", footer: jsonSearch["energia"], onTap: (){onTap(9);}, darkMode: darkMode,),
          SearchGridTile(iconAsset: "angoli", footer: jsonSearch["angoli"], onTap: (){onTap(10);}, darkMode: darkMode,),
          SearchGridTile(iconAsset: "valuta", footer: jsonSearch["valuta"], onTap: (){onTap(11);}, darkMode: darkMode,),
          SearchGridTile(iconAsset: "potenza", footer: jsonSearch["potenza"], onTap: (){onTap(14);}, darkMode: darkMode,),
          SearchGridTile(iconAsset: "forza", footer: jsonSearch["forza"], onTap: (){onTap(15);}, darkMode: darkMode,),
          SearchGridTile(iconAsset: "conversione_base", footer: jsonSearch["basi_numeriche"], onTap: (){onTap(18);}, darkMode: darkMode,),
          SearchGridTile(iconAsset: "consumo", footer: jsonSearch["consumo_carburante"], onTap: (){onTap(17);}, darkMode: darkMode,),
          SearchGridTile(iconAsset: "torque", footer: jsonSearch["momento"], onTap: (){onTap(16);}, darkMode: darkMode,),
          SearchGridTile(iconAsset: "dati", footer: jsonSearch["dati_digitali"], onTap: (){onTap(13);}, darkMode: darkMode,),
          SearchGridTile(iconAsset: "scarpe", footer: jsonSearch["taglia_scarpe"], onTap: (){onTap(12);}, darkMode: darkMode,),
          SearchGridTile(iconAsset: "prefissi", footer: jsonSearch["prefissi_si"], onTap: (){onTap(6);}, darkMode: darkMode,),
        ];
}