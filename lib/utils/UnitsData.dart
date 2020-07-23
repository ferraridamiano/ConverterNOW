import 'Utils.dart';
import 'UtilsConversion.dart';

initializeUnits(listaOrder, currencyValues){
  Node metro=Node(name: 'metro',symbol:"[m]",order: listaOrder[0][0],
        leafNodes: [
          Node(isMultiplication: false, coefficientPer: 100.0, name: 'centimetro',symbol:"[cm]",order: listaOrder[0][1], leafNodes: [
            Node(isMultiplication: true, coefficientPer: 2.54, name: 'pollice',symbol:"[in]",order: listaOrder[0][2], leafNodes: [
              Node(isMultiplication: true, coefficientPer: 12.0, name: 'piede',symbol:"[ft]",order: listaOrder[0][3]),
            ]),
          ]),
          Node(isMultiplication: true, coefficientPer: 1852.0, name: 'miglio_marino',symbol:"[M]",order: listaOrder[0][4],),
          Node(isMultiplication: true, coefficientPer: 0.9144, name: 'yard',symbol:"[yd]",order: listaOrder[0][5], leafNodes: [
            Node(isMultiplication: true, coefficientPer: 1760.0, name: 'miglio_terrestre',symbol:"[mi]",order: listaOrder[0][6],),
          ]),
          Node(isMultiplication: false, coefficientPer: 1000.0, name: 'millimetro',symbol:"[mm]",order: listaOrder[0][7],),
          Node(isMultiplication: false, coefficientPer: 1000000.0, name: 'micrometro',symbol:"[µm]", order: listaOrder[0][8],),
          Node(isMultiplication: false, coefficientPer: 1000000000.0, name: 'nanometro',symbol:"[nm]",order: listaOrder[0][9],),
          Node(isMultiplication: false, coefficientPer: 10000000000.0, name: 'angstrom',symbol:"[Å]",order: listaOrder[0][10],),
          Node(isMultiplication: false, coefficientPer: 1000000000000.0, name: 'picometro',symbol:"[pm]",order: listaOrder[0][11],),
          Node(isMultiplication: true, coefficientPer: 1000.0, name: 'chilometro',symbol:"[km]",order: listaOrder[0][12],leafNodes: [
            Node(isMultiplication: true, coefficientPer: 149597870.7, name: 'unita_astronomica',symbol:"[au]",order: listaOrder[0][13],leafNodes: [
              Node(isMultiplication: true, coefficientPer: 63241.1, name: 'anno_luce',symbol:"[ly]",order: listaOrder[0][14],leafNodes: [
                Node(isMultiplication: true, coefficientPer: 3.26, name: 'parsec',symbol:"[pc]",order: listaOrder[0][15],),
              ]),
            ]),
          ]),
        ]);

    Node metroq=Node(name: 'metro_quadrato',symbol:"[m²]",order: listaOrder[1][0],leafNodes: [
      Node(isMultiplication: false, coefficientPer: 10000.0, name: 'centimetro_quadrato',symbol:"[cm²]",order: listaOrder[1][1], leafNodes: [
        Node(isMultiplication: true, coefficientPer: 6.4516, name: 'pollice_quadrato',symbol:"[in²]",order: listaOrder[1][2], leafNodes: [
          Node(isMultiplication: true, coefficientPer: 144.0, name: 'piede_quadrato',symbol:"[ft²]",order: listaOrder[1][3]),
        ]),
      ]),
      Node(isMultiplication: false, coefficientPer: 1000000.0, name: 'millimetro_quadrato',symbol:"[mm²]",order: listaOrder[1][4],),
      Node(isMultiplication: true, coefficientPer: 10000.0, name: 'ettaro',symbol:"[he]",order: listaOrder[1][5],),
      Node(isMultiplication: true, coefficientPer: 1000000.0, name:  'chilometro_quadrato',symbol:"[km²]",order: listaOrder[1][6],),
      Node(isMultiplication: true, coefficientPer: 0.83612736, name: 'yard_quadrato',symbol:"[yd²]",order: listaOrder[1][7], leafNodes: [
        Node(isMultiplication: true, coefficientPer: 3097600.0, name: 'miglio_quadrato',symbol:"[mi²]",order: listaOrder[1][8]),
        Node(isMultiplication: true, coefficientPer: 4840.0, name:  'acri',symbol:"[ac]",order: listaOrder[1][9],),
      ]),
      Node(isMultiplication: true, coefficientPer: 100.0, name:  'ara',symbol:"[a]",order: listaOrder[1][10],),
    ]);

    Node metroc=Node(name:  'metro_cubo',symbol:"[m³]",order: listaOrder[2][0],leafNodes: [
      Node(isMultiplication: false, coefficientPer: 1000.0, name:  'litro',symbol:"[l]",order: listaOrder[2][1],leafNodes: [
        Node(isMultiplication: true, coefficientPer: 4.54609, name:  'gallone_imperiale',symbol:"[imp gal]",order: listaOrder[2][2],),
        Node(isMultiplication: true, coefficientPer: 3.785411784, name:  'gallone_us',symbol:"[US gal]",order: listaOrder[2][3],),
        Node(isMultiplication: true, coefficientPer: 0.56826125, name:  'pinta_imperiale',symbol:"[imp pt]",order: listaOrder[2][4],),
        Node(isMultiplication: true, coefficientPer: 0.473176473, name:  'pinta_us',symbol:"[US pt]",order: listaOrder[2][5],),
        Node(isMultiplication: false, coefficientPer: 1000.0, name:  'millilitro',symbol:"[ml]",order: listaOrder[2][6], leafNodes: [
          Node(isMultiplication: true, coefficientPer: 14.8, name:  'tablespoon_us',symbol:"[tbsp.]",order: listaOrder[2][7],),
          Node(isMultiplication: true, coefficientPer: 20.0, name:  'tablespoon_australian',symbol:"[tbsp.]",order:listaOrder[2][8],),
          Node(isMultiplication: true, coefficientPer: 240.0, name:  'cup_us',symbol:"[cup]",order: listaOrder[2][9],),
        ]),
      ]),
      Node(isMultiplication: false, coefficientPer: 1000000.0, name:  'centimetro_cubo',symbol:"[cm³]",order: listaOrder[2][10], leafNodes: [
        Node(isMultiplication: true, coefficientPer: 16.387064, name:  'pollice_cubo',symbol:"[in³]",order: listaOrder[2][11], leafNodes: [
          Node(isMultiplication: true, coefficientPer: 1728.0, name:  'piede_cubo',symbol:"[ft³]",order: listaOrder[2][12],),
        ]),
      ]),
      Node(isMultiplication: false, coefficientPer: 1000000000.0, name:  'millimetro_cubo',symbol:"[mm³]",order: listaOrder[2][13],),
    ]);

    Node secondo=Node(name:  'secondo',symbol:"[s]",order: listaOrder[3][0],
        leafNodes: [
          Node(isMultiplication: false, coefficientPer: 10.0, name:  'decimo_secondo',symbol:"[ds]",order: listaOrder[3][1],),
          Node(isMultiplication: false, coefficientPer: 100.0, name:  'centesimo_secondo',symbol:"[cs]", order: listaOrder[3][2],),
          Node(isMultiplication: false, coefficientPer: 1000.0, name:  'millisecondo',symbol:"[ms]",order: listaOrder[3][3],),
          Node(isMultiplication: false, coefficientPer: 1000000.0, name:  'microsecondo',symbol:"[µs]",order: listaOrder[3][4],),
          Node(isMultiplication: false, coefficientPer: 1000000000.0, name:  'nanosecondo',symbol:"[ns]",order: listaOrder[3][5],),
          Node(isMultiplication: true, coefficientPer: 60.0, name:  'minuti', symbol:"[min]",order: listaOrder[3][6],leafNodes: [
            Node(isMultiplication: true, coefficientPer: 60.0, name:  'ore',symbol:"[h]",order: listaOrder[3][7],leafNodes: [
              Node(isMultiplication: true, coefficientPer: 24.0, name:  'giorni',symbol:"[d]",order: listaOrder[3][8],leafNodes: [
                Node(isMultiplication: true, coefficientPer: 7.0, name:  'settimane',order: listaOrder[3][9],),
                Node(isMultiplication: true, coefficientPer: 365.0, name:  'anno',symbol:"[a]",order: listaOrder[3][10],leafNodes: [
                  Node(isMultiplication: true, coefficientPer: 5.0, name:  'lustro',order: listaOrder[3][11],),
                  Node(isMultiplication: true, coefficientPer: 10.0, name:  'decade',order: listaOrder[3][12],),
                  Node(isMultiplication: true, coefficientPer: 100.0, name:  'secolo',symbol:"[c.]",order: listaOrder[3][13],),
                  Node(isMultiplication: true, coefficientPer: 1000.0, name:  'millennio',order: listaOrder[3][14],),
                ]),
              ]),
            ]),
          ]),
        ]);

    Node celsius=Node(name:  'fahrenheit',symbol:"[°F]",order: listaOrder[4][0],leafNodes:[
      Node(isMultiplication: true, coefficientPer: 1.8, isSum: true, coefficientPlus: 32.0, name:  'celsius',symbol:"[°C]",order: listaOrder[4][1],leafNodes: [
        Node(isSum: false, coefficientPlus: 273.15, name:  'kelvin',symbol:"[K]",order: listaOrder[4][2],),
        Node(isMultiplication: true, coefficientPer: 5/4, name: "reamur",symbol:"[°Re]",order: listaOrder[4][3],),
        Node(isMultiplication: true, coefficientPer: 40/21, isSum: true, coefficientPlus: -100/7,  name: "romer",symbol:"[°Rø]",order: listaOrder[4][4],),
        Node(isMultiplication: true, coefficientPer: -2/3, isSum: true, coefficientPlus: 100,  name: "delisle",symbol:"[°De]",order: listaOrder[4][5],),
      ]),
      Node(isSum: false, coefficientPlus: 459.67, name: "rankine",symbol:"[°R]",order: listaOrder[4][6],),
    ]);

    Node metriSecondo=Node(name:  'metri_secondo',symbol:"[m/s]", order: listaOrder[5][0], leafNodes: [
      Node(isMultiplication: false, coefficientPer: 3.6, name:  'chilometri_ora',symbol:"[km/h]",order: listaOrder[5][1], leafNodes:[
        Node(isMultiplication: true, coefficientPer: 1.609344, name:  'miglia_ora',symbol:"[mph]",order: listaOrder[5][2],),
        Node(isMultiplication: true, coefficientPer: 1.852, name:  'nodi',symbol:"[kts]",order: listaOrder[5][3],),
      ]),
      Node(isMultiplication: true, coefficientPer: 0.3048, name:  'piedi_secondo',symbol:"[ft/s]",order: listaOrder[5][4],),
    ]);

    Node si=Node(name: "base",symbol:"[10º]",order: listaOrder[6][0],
        leafNodes: [
          Node(isMultiplication: true, coefficientPer: 10.0, name: "deca",symbol:"[da][10¹]",order: listaOrder[6][1],),
          Node(isMultiplication: true, coefficientPer: 100.0, name: "hecto",symbol:"[h][10²]",order: listaOrder[6][2],),
          Node(isMultiplication: true, coefficientPer: 1000.0, name: "kilo",symbol:"[k][10³]",order: listaOrder[6][3],),
          Node(isMultiplication: true, coefficientPer: 1000000.0, name: "mega",symbol:"[M][10⁶]",order: listaOrder[6][4],),
          Node(isMultiplication: true, coefficientPer: 1000000000.0, name: "giga",symbol:"[G][10⁹]",order: listaOrder[6][5],),
          Node(isMultiplication: true, coefficientPer: 1000000000000.0, name: "tera",symbol:"[T][10¹²]",order: listaOrder[6][6],),
          Node(isMultiplication: true, coefficientPer: 1000000000000000.0, name: "peta",symbol:"[P][10¹⁵]",order: listaOrder[6][7],),
          Node(isMultiplication: true, coefficientPer: 1000000000000000000.0, name: "exa",symbol:"[E][10¹⁸]",order: listaOrder[6][8],),
          Node(isMultiplication: true, coefficientPer: 1000000000000000000000.0, name: "zetta",symbol:"[Z][10²¹]",order: listaOrder[6][9],),
          Node(isMultiplication: true, coefficientPer: 1000000000000000000000000.0, name: "yotta",symbol:"[Y][10²⁴]",order: listaOrder[6][10],),
          Node(isMultiplication: false, coefficientPer: 10.0, name: "deci",symbol:"[d][10⁻¹]",order: listaOrder[6][11],),
          Node(isMultiplication: false, coefficientPer: 100.0, name: "centi",symbol:"[c][10⁻²]",order: listaOrder[6][12],),
          Node(isMultiplication: false, coefficientPer: 1000.0, name: "milli",symbol:"[m][10⁻³]",order: listaOrder[6][13],),
          Node(isMultiplication: false, coefficientPer: 1000000.0, name: "micro",symbol:"[µ][10⁻⁶]",order: listaOrder[6][14],),
          Node(isMultiplication: false, coefficientPer: 1000000000.0, name: "nano",symbol:"[n][10⁻⁹]",order: listaOrder[6][15],),
          Node(isMultiplication: false, coefficientPer: 1000000000000.0, name: "pico",symbol:"[p][10⁻¹²]",order: listaOrder[6][16],),
          Node(isMultiplication: false, coefficientPer: 1000000000000000.0, name: "femto",symbol:"[f][10⁻¹⁵]",order: listaOrder[6][17],),
          Node(isMultiplication: false, coefficientPer: 1000000000000000000.0, name: "atto",symbol:"[a][10⁻¹⁸]",order: listaOrder[6][18],),
          Node(isMultiplication: false, coefficientPer: 1000000000000000000000.0, name: "zepto",symbol:"[z][10⁻²¹]",order: listaOrder[6][19],),
          Node(isMultiplication: false, coefficientPer: 1000000000000000000000000.0, name: "yocto",symbol:"[y][10⁻²⁴]",order: listaOrder[6][20],),
        ]
    );

    Node grammo=Node(name:  'grammo',symbol:"[g]",order: listaOrder[7][0],
      leafNodes: [
      Node(isMultiplication: true, coefficientPer: 100.0, name:  'ettogrammo',symbol:"[hg]",order: listaOrder[7][1],),
      Node(isMultiplication: true, coefficientPer: 1000.0, name:  'chilogrammo',symbol:"[kg]",order: listaOrder[7][2],leafNodes:[
        Node(isMultiplication: true, coefficientPer: 0.45359237, name:  'libbra',symbol:"[lb]",order: listaOrder[7][3],leafNodes: [
          Node(isMultiplication: false, coefficientPer: 16.0, name:  'oncia',symbol:"[oz]",order: listaOrder[7][4],)
        ]),
      ]),
      Node(isMultiplication: true, coefficientPer: 100000.0, name:  'quintale',order: listaOrder[7][5],),
      Node(isMultiplication: true, coefficientPer: 1000000.0, name:  'tonnellata',symbol:"[t]",order: listaOrder[7][6],),
      Node(isMultiplication: false, coefficientPer: 100.0, name:  'centigrammo',symbol:"[cg]",order: listaOrder[7][7],),
      Node(isMultiplication: false, coefficientPer: 1000.0, name:  'milligrammo',symbol:"[mg]",order: listaOrder[7][8],),
      Node(isMultiplication: true, coefficientPer: 1.660539e-24, name:  'uma',symbol:"[u]",order: listaOrder[7][9],),
      Node(isMultiplication: true, coefficientPer: 0.2, name:  'carato',symbol:"[ct]",order: listaOrder[7][10],),
    ]);

    Node pascal=Node(name:  'pascal',symbol:"[Pa]",order: listaOrder[8][0],
        leafNodes: [
          Node(isMultiplication: true, coefficientPer: 101325.0, name:  'atmosfere',symbol:"[atm]",order: listaOrder[8][1],leafNodes:[
            Node(isMultiplication: true, coefficientPer: 0.987, name:  'bar',symbol:"[bar]",order: listaOrder[8][2],leafNodes:[
              Node(isMultiplication: false, coefficientPer: 1000.0, name:  'millibar',symbol:"[mbar]",order: listaOrder[8][3],),
            ]),
          ]),
          Node(isMultiplication: true, coefficientPer: 6894.757293168, name:  'psi',symbol:"[psi]",order: listaOrder[8][4],),
          Node(isMultiplication: true, coefficientPer: 133.322368421, name:  'torr',symbol:"(mmHg) [torr]",order: listaOrder[8][5],),
    ]);

    Node joule=Node(name:  'joule',symbol:"[J]",order: listaOrder[9][0],
        leafNodes: [
          Node(isMultiplication: true, coefficientPer: 4.1867999409, name:  'calorie',symbol:"[cal]",order: listaOrder[9][1]),
          Node(isMultiplication: true, coefficientPer: 3600000.0, name:  'kilowattora',symbol:"[kwh]",order: listaOrder[9][2],),
          Node(isMultiplication: true, coefficientPer: 1.60217646e-19, name:  'elettronvolt',symbol:"[eV]",order: listaOrder[9][3],),
        ]);
    Node gradi=Node(name: 'gradi',symbol:"[°]",order: listaOrder[10][0],
        leafNodes: [
          Node(isMultiplication: false, coefficientPer: 60.0, name:  'primi',symbol:"[']",order: listaOrder[10][1]),
          Node(isMultiplication: false, coefficientPer: 3600.0, name:  'secondi',symbol:"['']",order: listaOrder[10][2]),
          Node(isMultiplication: true, coefficientPer: 57.295779513, name:  'radianti',symbol:"[rad]",order: listaOrder[10][3]),
    ]);

    Node eur=Node(name: 'EUR', symbol: 'eu',order: listaOrder[11][0],
        leafNodes: [
          Node(isMultiplication: false, coefficientPer: currencyValues['USD'], name:  'USD',symbol: 'us',order: listaOrder[11][1]),
          Node(isMultiplication: false, coefficientPer: currencyValues['GBP'], name:  'GBP',symbol: 'gb',order: listaOrder[11][2]),
          Node(isMultiplication: false, coefficientPer: currencyValues['INR'], name:  'INR',symbol: 'in',order: listaOrder[11][3]),
          Node(isMultiplication: false, coefficientPer: currencyValues['CNY'], name:  'CNY',symbol: 'cn',order: listaOrder[11][4]),
          Node(isMultiplication: false, coefficientPer: currencyValues['JPY'], name:  'JPY',symbol: 'jp',order: listaOrder[11][5]),
          Node(isMultiplication: false, coefficientPer: currencyValues['CHF'], name:  'CHF',symbol: 'ch',order: listaOrder[11][6]),
          Node(isMultiplication: false, coefficientPer: currencyValues['SEK'], name:  'SEK',symbol: 'se',order: listaOrder[11][7]),
          Node(isMultiplication: false, coefficientPer: currencyValues['RUB'], name:  'RUB',symbol: 'ru',order: listaOrder[11][8]),
          Node(isMultiplication: false, coefficientPer: currencyValues['CAD'], name:  'CAD',symbol: 'ca',order: listaOrder[11][9]),
          Node(isMultiplication: false, coefficientPer: currencyValues['KRW'], name:  'KRW',symbol: 'kr',order: listaOrder[11][10]),
          Node(isMultiplication: false, coefficientPer: currencyValues['BRL'], name:  'BRL',symbol: 'br',order: listaOrder[11][11]),
          Node(isMultiplication: false, coefficientPer: currencyValues['HKD'], name:  'HKD',symbol: 'hk',order: listaOrder[11][12]),
          Node(isMultiplication: false, coefficientPer: currencyValues['AUD'], name:  'AUD',symbol: 'au',order: listaOrder[11][13]),
          Node(isMultiplication: false, coefficientPer: currencyValues['NZD'], name:  'NZD',symbol: 'nz',order: listaOrder[11][14]),
          Node(isMultiplication: false, coefficientPer: currencyValues['MXN'], name:  'MXN',symbol: 'mx',order: listaOrder[11][15]),
          Node(isMultiplication: false, coefficientPer: currencyValues['SGD'], name:  'SGD',symbol: 'sg',order: listaOrder[11][16]),
          Node(isMultiplication: false, coefficientPer: currencyValues['NOK'], name:  'NOK',symbol: 'no',order: listaOrder[11][17]),
          Node(isMultiplication: false, coefficientPer: currencyValues['TRY'], name:  'TRY',symbol: 'tr',order: listaOrder[11][18]),
          Node(isMultiplication: false, coefficientPer: currencyValues['ZAR'], name:  'ZAR',symbol: 'za',order: listaOrder[11][19]),
          Node(isMultiplication: false, coefficientPer: currencyValues['DKK'], name:  'DKK',symbol: 'dk',order: listaOrder[11][20]),
          Node(isMultiplication: false, coefficientPer: currencyValues['PLN'], name:  'PLN',symbol: 'pl',order: listaOrder[11][21]),
          Node(isMultiplication: false, coefficientPer: currencyValues['THB'], name:  'THB',symbol: 'th',order: listaOrder[11][22]),
          Node(isMultiplication: false, coefficientPer: currencyValues['MYR'], name:  'MYR',symbol: 'my',order: listaOrder[11][23]),
          Node(isMultiplication: false, coefficientPer: currencyValues['HUF'], name:  'HUF',symbol: 'hu',order: listaOrder[11][24]),
          Node(isMultiplication: false, coefficientPer: currencyValues['CZK'], name:  'CZK',symbol: 'cz',order: listaOrder[11][25]),
          Node(isMultiplication: false, coefficientPer: currencyValues['ILS'], name:  'ILS',symbol: 'il',order: listaOrder[11][26]),
          Node(isMultiplication: false, coefficientPer: currencyValues['IDR'], name:  'IDR',symbol: 'id',order: listaOrder[11][27]),
          Node(isMultiplication: false, coefficientPer: currencyValues['PHP'], name:  'PHP',symbol: 'ph',order: listaOrder[11][28]),
          Node(isMultiplication: false, coefficientPer: currencyValues['RON'], name:  'RON',symbol: 'ro',order: listaOrder[11][29]),
    ]);

    Node centimetriScarpe=Node(name: 'centimetro', symbol: "[cm]",order: listaOrder[12][0],
        leafNodes: [
          Node(isMultiplication: false, coefficientPer: 1.5, coefficientPlus: 1.5, isSum: false, name:  'eu_cina',order: listaOrder[12][1]),
          Node(isMultiplication: true, coefficientPer: 2.54, name:  'pollice',symbol: '[in]',order: listaOrder[12][2], 
          leafNodes: [
            Node(isMultiplication: false, coefficientPer: 3.0, coefficientPlus: 4, isSum: true, name:  'uk_india_bambino',order: listaOrder[12][3]),
            Node(isMultiplication: false, coefficientPer: 3.0, coefficientPlus: 8.3333333, name:  'uk_india_uomo',order: listaOrder[12][4]),
            Node(isMultiplication: false, coefficientPer: 3.0, coefficientPlus: 8.5, name:  'uk_india_donna',order: listaOrder[12][5]),
            Node(isMultiplication: false, coefficientPer: 3.0, coefficientPlus: 3.89, isSum: true, name:  'usa_canada_bambino',order: listaOrder[12][6]),
            Node(isMultiplication: false, coefficientPer: 3.0, coefficientPlus: 8.0, name:  'usa_canada_uomo',order: listaOrder[12][7]),
            Node(isMultiplication: false, coefficientPer: 3.0, coefficientPlus: 7.5, name:  'usa_canada_donna',order: listaOrder[12][8]),
          ]),
          Node(coefficientPlus: 1.5, isSum: false, name:  'giappone',order: listaOrder[12][9]),
          
    ]);

    Node bit=Node(name: "bit",symbol: "[b]",order: listaOrder[13][0],
        leafNodes: [
          Node(isMultiplication: true, coefficientPer: 4.0, name: "nibble",order: listaOrder[13][2],),
          Node(isMultiplication: true, coefficientPer: 1000.0, name: "kilobit",symbol: "[kb]",order: listaOrder[13][3],),
          Node(isMultiplication: true, coefficientPer: 1000000.0, name: "megabit",symbol: "[Mb]",order: listaOrder[13][7],),
          Node(isMultiplication: true, coefficientPer: 1000000000.0, name: "gigabit",symbol: "[Gb]",order: listaOrder[13][11],),
          Node(isMultiplication: true, coefficientPer: 1000000000000.0, name: "terabit",symbol: "[Tb]",order: listaOrder[13][15],),
          Node(isMultiplication: true, coefficientPer: 1000000000000000.0, name: "petabit",symbol: "[Pb]",order: listaOrder[13][19],),
          Node(isMultiplication: true, coefficientPer: 1000000000000000000.0, name: "exabit",symbol: "[Eb]",order: listaOrder[13][23],),
          Node(isMultiplication: true, coefficientPer: 1024.0, name: "kibibit",symbol: "[Kibit]",order: listaOrder[13][5],leafNodes: [
            Node(isMultiplication: true, coefficientPer: 1024.0, name: "mebibit",symbol: "[Mibit]",order: listaOrder[13][9],leafNodes: [
              Node(isMultiplication: true, coefficientPer: 1024.0, name: "gibibit",symbol: "[Gibit]",order: listaOrder[13][13],leafNodes: [
                Node(isMultiplication: true, coefficientPer: 1024.0, name: "tebibit",symbol: "[Tibit]",order: listaOrder[13][17],leafNodes: [
                  Node(isMultiplication: true, coefficientPer: 1024.0, name: "pebibit",symbol: "[Pibit]",order: listaOrder[13][21],leafNodes: [
                    Node(isMultiplication: true, coefficientPer: 1024.0, name: "exbibit",symbol: "[Eibit]",order: listaOrder[13][25])
                  ])
                ])
              ])
            ])
          ]),
          Node(isMultiplication: true, coefficientPer: 8.0, name: "byte",symbol: "[B]",order: listaOrder[13][1],leafNodes: [
            Node(isMultiplication: true, coefficientPer: 1000.0, name: "kilobyte",symbol: "[kB]",order: listaOrder[13][4],),
            Node(isMultiplication: true, coefficientPer: 1000000.0, name: "megabyte",symbol: "[MB]",order: listaOrder[13][8],),
            Node(isMultiplication: true, coefficientPer: 1000000000.0, name: "gigabyte",symbol: "[GB]",order: listaOrder[13][12],),
            Node(isMultiplication: true, coefficientPer: 1000000000000.0, name: "terabyte",symbol: "[TB]",order: listaOrder[13][16],),
            Node(isMultiplication: true, coefficientPer: 1000000000000000.0, name: "petabyte",symbol: "[PB]",order: listaOrder[13][20],),
            Node(isMultiplication: true, coefficientPer: 1000000000000000000.0, name: "exabyte",symbol: "[EB]",order: listaOrder[13][24],),
            Node(isMultiplication: true, coefficientPer: 1024.0, name: "kibibyte",symbol: "[KiB]",order: listaOrder[13][6],leafNodes: [
              Node(isMultiplication: true, coefficientPer: 1024.0, name: "mebibyte",symbol: "[MiB]",order: listaOrder[13][10],leafNodes: [
                Node(isMultiplication: true, coefficientPer: 1024.0, name: "gibibyte",symbol: "[GiB]",order: listaOrder[13][14],leafNodes: [
                  Node(isMultiplication: true, coefficientPer: 1024.0, name: "tebibyte",symbol: "[TiB]",order: listaOrder[13][18],leafNodes: [
                    Node(isMultiplication: true, coefficientPer: 1024.0, name: "pebibyte",symbol: "[PiB]",order: listaOrder[13][22],leafNodes: [
                      Node(isMultiplication: true, coefficientPer: 1024.0, name: "exbibyte",symbol: "[EiB]",order: listaOrder[13][26])
                    ])
                  ])
                ])
              ])
            ]),
          ]),
        ]
    );

    Node watt=Node(name:  'watt', symbol: "[W]",order: listaOrder[14][0],
        leafNodes: [
          Node(isMultiplication: false, coefficientPer: 1000.0, name:  'milliwatt', symbol: "[W]",order: listaOrder[14][1],),
          Node(isMultiplication: true, coefficientPer: 1000.0, name:  'kilowatt', symbol: "[kW]",order: listaOrder[14][2],),
          Node(isMultiplication: true, coefficientPer: 1000000.0, name:  'megawatt', symbol: "[MW]",order: listaOrder[14][3],),
          Node(isMultiplication: true, coefficientPer: 1000000000.0, name:  'gigawatt', symbol: "[GW]",order: listaOrder[14][4],),
          Node(isMultiplication: true, coefficientPer: 735.49875, name:  'cavallo_vapore_eurpeo', symbol: "[hp(M)]",order: listaOrder[14][5],),
          Node(isMultiplication: true, coefficientPer: 745.69987158, name:  'cavallo_vapore_imperiale', symbol: "[hp(I)]",order: listaOrder[14][6],),
    ]);

    Node newton=Node(name:  'newton',symbol: "[N]",order: listaOrder[15][0],
        leafNodes: [
          Node(isMultiplication: false, coefficientPer: 100000.0, name:  'dyne',symbol: "[dyn]",order: listaOrder[15][1],),
          Node(isMultiplication: true, coefficientPer: 4.4482216152605 , name:  'libbra_forza',symbol: "[lbf]",order: listaOrder[15][2],),
          Node(isMultiplication: true, coefficientPer: 9.80665, name:  'kilogrammo_forza',symbol: "[kgf]",order: listaOrder[15][3],),
          Node(isMultiplication: true, coefficientPer: 0.138254954376, name:  'poundal',symbol: "[pdl]",order: listaOrder[15][4],),
    ]);

    Node newtonMetro=Node(name:  'newton_metro',symbol: "[N·m]",order: listaOrder[16][0],
        leafNodes: [
          Node(isMultiplication: false, coefficientPer: 100000.0, name:  'dyne_metro',symbol:"[dyn·m]",order: listaOrder[16][1],),
          Node(isMultiplication: false, coefficientPer: 0.7375621489 , name:  'libbra_forza_piede',symbol: "[lbf·ft]",order: listaOrder[16][2],),
          Node(isMultiplication: false, coefficientPer: 0.10196798205363515, name:  'kilogrammo_forza_metro',symbol: "[kgf·m]",order: listaOrder[16][3],),
          Node(isMultiplication: true, coefficientPer: 0.138254954376, name:  'poundal_metro',symbol: "[pdl·m]",order: listaOrder[16][4],),
    ]);

    Node chilometriLitro=Node(name:  'chilometri_litro',symbol: "[km/l]",order: listaOrder[17][0],
        leafNodes: [
          Node(conversionType: RECIPROCO_CONVERSION,coefficientPer: 100.0, name:  'litri_100km',symbol: "[l/100km]",order: listaOrder[17][1],),
          Node(coefficientPer: 0.4251437074 , name:  'miglia_gallone_us',symbol: "[mpg]",order: listaOrder[17][2],),
          Node(coefficientPer: 0.3540061899, name:  'miglia_gallone_uk',symbol: "[mpg]",order: listaOrder[17][3],),
    ]);

    Node baseDecimale=Node(name:  'decimale',base: 10,keyboardType: KEYBOARD_NUMBER_INTEGER,symbol: "[₁₀]",order: listaOrder[18][0],
        leafNodes: [
          Node(conversionType: BASE_CONVERSION,base: 16,keyboardType: KEYBOARD_COMPLETE,name:  'esadecimale',symbol: "[₁₆]",order: listaOrder[18][1],),
          Node(conversionType: BASE_CONVERSION,base: 8,keyboardType: KEYBOARD_NUMBER_INTEGER, name:  'ottale',symbol: "[₈]",order: listaOrder[18][2],),
          Node(conversionType: BASE_CONVERSION,base: 2,keyboardType: KEYBOARD_NUMBER_INTEGER, name:  'binario',symbol: "[₂]",order: listaOrder[18][3],),
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