import 'package:flutter/material.dart';
import './MainPage.dart';

void main() => runApp(new ExampleApplication());

class ExampleApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     theme :ThemeData(
    primarySwatch:Colors.blue,
),
      home: MainPage());
  }
}

  
  // class Item {
  //   Item({
  //     required this.id,
  //     required this.name,
  //     required this.price,
  //     required this.description,
  //      required this.id2,
  //     required this.name2,
  //     required this.price2,
  //     required this.description2,
  //   });
  
  //   int id;
  //   String name;
  //   double price;
  //   String description;
  //     int id2;
  //   String name2;
  //   double price2;
  //   String description2;
  // }
  
  // class TableExample extends StatefulWidget {
  
  //   @override
  //   State<StatefulWidget> createState() {
  //     return TableExampleState();
  //   }
  // }
  
  // class TableExampleState extends State<TableExample> {
  
  //   List<Item> _items = [];
  
  //   @override
  //   void initState() {
  //     super.initState();
  //     setState(() {
  //       _items = _generateItems();
  //     });
  //   }
  
  //   List<Item> _generateItems() {
  //     return List.generate(5, (int index) {
  //       return Item(
  //         id: index,
  //         name: 'Item $index',
  //         price: index * 1000.00,
  //         description: 'Details of item $index',
  //          id2: index,
  //         name2: 'Item $index',
  //         price2: index * 1000.00,
  //         description2: 'Details of item $index',
  //       );
  //     });
  //   }
  
  //   TableRow _buildTableRow(Item item) {
  //     return TableRow(
  //       key: ValueKey(item.id),
  //       decoration: BoxDecoration(
  //         color: Colors.lightBlueAccent,
  //       ),
  //       children: [
  //         TableCell(
  //           verticalAlignment: TableCellVerticalAlignment.bottom,
  //           child: SizedBox(
  //             height: 50,
  //             child: Center(
  //               child: Text(item.id.toString()),
  //             ),
  //           ),
  //         ),
  //         TableCell(
  //           verticalAlignment: TableCellVerticalAlignment.middle,
  //           child: Padding(
  //             padding: const EdgeInsets.all(5),
  //             child: Text(item.name),
  //           ),
  //         ),
  //         TableCell(
  //           verticalAlignment: TableCellVerticalAlignment.middle,
  //           child: Padding(
  //             padding: const EdgeInsets.all(5),
  //             child: Text(item.price.toString()),
  //           ),
  //         ),
  //         TableCell(
  //           child: Padding(
  //             padding: const EdgeInsets.all(5),
  //             child: Text(item.description),
  //           ),
  //         ),

  //          TableCell(
  //           verticalAlignment: TableCellVerticalAlignment.bottom,
  //           child: SizedBox(
  //             height: 50,
  //             child: Center(
  //               child: Text(item.id.toString()),
  //             ),
  //           ),
  //         ),
  //         TableCell(
  //           verticalAlignment: TableCellVerticalAlignment.middle,
  //           child: Padding(
  //             padding: const EdgeInsets.all(5),
  //             child: Text(item.name),
  //           ),
  //         ),
  //         TableCell(
  //           verticalAlignment: TableCellVerticalAlignment.middle,
  //           child: Padding(
  //             padding: const EdgeInsets.all(5),
  //             child: Text(item.price.toString()),
  //           ),
  //         ),
  //         TableCell(
  //           child: Padding(
  //             padding: const EdgeInsets.all(5),
  //             child: Text(item.description),
  //           ),
  //         ),
  //       ]
  //     );
  //   }
  
  //   @override
  //   Widget build(BuildContext context) {
  //     return Scaffold(
  //       appBar: AppBar(
  //         title: const Text('Woolha.com Flutter Tutorial'),
  //       ),
  //       body: Table(
  //         // border: TableBorder(
  //         //     bottom: BorderSide(color: Colors.red, width: 2),
  //         //     horizontalInside: BorderSide(color: Colors.red, width: 2),
  //         // ),
  //         // border: TableBorder.all(color: Colors.red, width: 2),
  //         border: TableBorder.symmetric(
  //           inside: BorderSide(color: Colors.blue, width: 2),
  //           outside: BorderSide(color: Colors.red, width: 5),
  //         ),
  //         defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
  //         defaultColumnWidth: IntrinsicColumnWidth(),
         
  //         // textDirection: TextDirection.rtl,
  //         textBaseline: TextBaseline.alphabetic, // Pass this argument when using [TableCellVerticalAlignment.fill]
  //         children: _items.map((item) => _buildTableRow(item))
  //             .toList(),
  //       ),
  //     );
  //   }
  // }