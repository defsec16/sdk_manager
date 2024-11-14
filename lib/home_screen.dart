import 'dart:convert';
import 'package:b1/model/model_json.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<HistoryItem> historyItems = [];
  late List<Category> categories=[];

  @override
  void initState() {
    super.initState();
    _loadJsonData();
  }

  // Загрузка JSON из assets
  Future<void> _loadJsonData() async {
    final String response = await rootBundle.loadString('assets/data.json');
    final data = json.decode(response);

    setState(() {
      historyItems = (data['history'] as List)
          .map((item) => HistoryItem.fromJson(item))
          .toList();
      categories = (data['categories'] as List)
          .map((item) => Category.fromJson(item))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Главная'),
      ),
      body: historyItems.isEmpty || categories.isEmpty
          ? Center(child: CircularProgressIndicator()) // Показываем индикатор загрузки
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // История запросов
                  Text(
                    'История запросов',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 160,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: historyItems.map((historyItem) {
                        return _buildHistoryCard(
                          historyItem.question,
                          historyItem.answer,
                          historyItem.date,
                          context,
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Категории
                  Text(
                    'Категории',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...categories.map((category) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(category.categoryName, style: TextStyle(fontSize: 15)),
                        SizedBox(
                          height: 160,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: category.subCategories.map((subCategory) {
                              return _buildCategoryCard(
                                subCategory.title,
                                subCategory.description,
                                context,
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
    );
  }

  // Виджет для истории запросов
 Widget _buildHistoryCard(String question, String answer, String date, BuildContext context) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Здесь мы добавляем обрезку текста для вопроса
          Text(
            question,
            overflow: TextOverflow.ellipsis, // Обрезать текст с многоточием
            maxLines: 3, // Ограничим максимальное количество строк
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          // Обрезаем и для ответа, если нужно
          Text(
            answer,
            overflow: TextOverflow.ellipsis,
            maxLines: 3, // Ограничим количество строк
          ),
          SizedBox(height: 24),
          // Дата, без изменений
          Text(
            date,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}

  // Виджет для карточки категории
  Widget _buildCategoryCard(String title, String description, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 24,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
