class UnitsModel {
  int id;
  String name;
  String lcl;
  String ucl;
  UnitsModel(this.id, this.name, this.lcl, this.ucl);
}

class Units {
  List<UnitsModel> units = [
    UnitsModel(1, 'H2O', '0', '78.74015'),
      UnitsModel(2, 'Hg', '0', '5.7918'),
    UnitsModel(3, 'ft H2O', '0', '6.56167'),
   
    UnitsModel(4, 'mm H2O', '0', '2000.0'),
   
    UnitsModel(5, 'mm Hg', '0', '147.111'),
    UnitsModel(6, 'psi', '0', '2.84466'),
    UnitsModel(7, 'Bar', '0', '0.196133'),
    UnitsModel(8, 'm Bar', '0', '19.6133'),
    UnitsModel(9, 'Pa', '0', '19613.3'),
    UnitsModel(10, 'KPa', '0', '19.613'),
    UnitsModel(11, 'torr', '0','147.118'),
    UnitsModel(12, 'atm', '0','0.193568'),
  ];
  List<String> unitsName = [
    'H2O',
    'ft H2O',
    'mm H2O',
    'Hg',
    'mm Hg',
    'psi',
    'Bar',
    'm Bar',
    'Pa',
    'KPa',
    'torr',
    'atm',
  ];
}
