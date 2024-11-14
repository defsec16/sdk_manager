// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(title: 'Flutter App'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   List<Category> categories = [];
//   List<HistoryItem> historyItems = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchCategories();
//     fetchHistoryItems();
//   }

//   Future<void> fetchCategories() async {
//     try {
//       final response = await Dio().get('/api/categories/');
//       setState(() {
//         categories = response.data.map<Category>((category) => Category.fromJson(category)).toList();
//       });
//     } catch (e) {
//       print('Error fetching categories: $e');
//     }
//   }

//   Future<void> fetchHistoryItems() async {
//     // Логика получения истории чатов
//     setState(() {
//       // Замените на актуальную логику получения данных из API
//       historyItems = [
//         HistoryItem(title: 'Какая самая длинная река?', answer: 'Самая длинная река - это', timestamp: DateTime.now()),
//         // ... other history items
//       ];
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Column(
//         children: [
//           // История
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('История', style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold)),
//                 Container(
//                   height: 150,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: historyItems.length,
//                     itemBuilder: (context, index) {
//                       final item = historyItems[index];
//                       return Card(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(item.title, style: TextStyle(fontWeight: FontWeight.bold)),
//                               SizedBox(height: 4),
//                               Text(item.answer),
//                               SizedBox(height: 4),
//                               Text('${item.timestamp.day} ${item.timestamp.month} ${item.timestamp.year}, ${item.timestamp.hour}:${item.timestamp.minute}'),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Категории
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Категории', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                 ...categories.map((category) => Card(
//                   color: Colors.primaries[categories.indexOf(category) % Colors.primaries.length],
//                   child: ListTile(
//                     title: Text(category.name),
//                     onTap: () {
//                       // Логика открытия чата с подставленным текстом
//                     },
//                   ),
//                 )),
//               ],
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Главная'),
//           BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Настройки'),
//           BottomNavigationBarItem(
//             icon: Container(
//               decoration: BoxDecoration(
//                 color: Colors.green,
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(Icons.message, color: Colors.white),
//             ),
//             label: '',
//           ),
//         ],
//         onTap: (index) {
//           // Логика обработки нажатий на кнопки
//         },
//       ),
//     );
//   }
// }

// class Category {
//   final String name;

//   Category({required this.name});

//   factory Category.fromJson(Map<String, dynamic> json) {
//     return Category(name: json['name']);
//   }
// }

// class HistoryItem {
//   final String title;
//   final String answer;
//   final DateTime timestamp;

//   HistoryItem({required this.title, required this.answer, required this.timestamp});
// }