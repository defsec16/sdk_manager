import 'package:b1/chat_screen.dart';
import 'package:b1/home_screen.dart';
import 'package:b1/logo.dart';
import 'package:b1/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация Hive с указанием пути для хранения данных
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  // Открытие бокса перед запуском приложения
  await Hive.openBox('chatBox');

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        title: 'Assistant App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage12(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    // ChatScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
          // BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Чат'),
          
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Настройки'),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,MaterialPageRoute(builder: (context)=>ChatScreen()));
      
        },
        child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white, // Цвет обводки
            width: 4.0,           // Толщина обводки
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0), // Внутренний отступ для иконки
          child: Icon(
            Icons.chat,
            // icon: Image.asset("assets/home.png", color: Colors.grey,),
            size: 30, // Размер иконки
            color: Colors.white, // Цвет иконки
          ),
        ),
      ),
      backgroundColor: Colors.green, 
      // child: Icon(Icons.chat),
      // backgroundColor: Colors.green,
      shape: CircleBorder(), 
    ),
    );
  }
}
