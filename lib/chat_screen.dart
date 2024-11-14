import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScrollController _scrollController = ScrollController();
  bool _isTextFieldNotEmpty = false;
  @override
  void initState() {
    super.initState();
    // Загружаем сообщения
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.loadMessages();

    // Отправляем приветственное сообщение и прокручиваем до последнего сообщения
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatProvider.sendWelcomeMessage();
      if (_scrollController.hasClients) {
        _scrollToBottom();
      }
    });
    chatProvider.textController.addListener(_onTextChanged);
  }
  void _onTextChanged() {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false); // Получаем провайдер внутри функции
    setState(() {
      _isTextFieldNotEmpty = chatProvider.textController.text.isNotEmpty;
    });
  }
  @override
  void dispose() {
    _scrollController.dispose(); // Освобождаем контроллер
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.textController.removeListener(_onTextChanged);
    super.dispose();
  }

  // Прокрутка до последнего сообщения
  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  // Функция для копирования текста в буфер обмена
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Текст скопирован в буфер обмена!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context); 
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Чат'),
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          return Column(
            children: [
              // Список сообщений
              Expanded(
                child: ListView.separated(
                  controller: _scrollController, // Используем контроллер для прокрутки
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    var message = chatProvider.messages[index];
                    bool isBot = message.sender == "Бот"; // Проверка, что сообщение от бота
                    bool isWelcomeMessage = message.text == "Привет! Чем могу помочь?"; // Приветственное сообщение
                    return ListTile(
                      tileColor: isBot ? Colors.green[200] : Colors.white, // Зелёный фон для сообщений бота
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: isBot ? Colors.green : Colors.blue, // Уникальный цвет для бота
                            child: isBot
                                ? Icon(Icons.circle, color: Colors.white) // Иконка робота для бота
                                : Icon(Icons.person, color: Colors.white), // Иконка человека для пользователя
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.sender,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(message.text),
                              ],
                            ),
                          ),
                          if (isBot && !isWelcomeMessage)
                            TextButton(
                              onPressed: () {
                                // Копируем текст сообщения бота в буфер обмена
                                Clipboard.setData(ClipboardData(text: message.text));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Текст скопирован в буфер обмена')),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Уменьшаем размеры кнопки
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12), // Скругляем края кнопки
                                  side: BorderSide(color: Colors.blue, width: 1), // Добавляем рамку
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.copy, color: Colors.blue, size: 16), // Меньшая иконка копирования
                                  SizedBox(width: 4), // Отступ между иконкой и текстом
                                  Text("Копировать", style: TextStyle(color: Colors.blue, fontSize: 14)), // Меньший текст
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(),
                ),
              ),

              // Поле ввода сообщения
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Поле ввода текста
                    Expanded(
                      child: TextField(
                        controller: chatProvider.textController,
                        decoration: InputDecoration(
                          hintText: 'Введите сообщение...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        ),
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => chatProvider.sendMessage(),
                      ),
                    ),
                    if (_isTextFieldNotEmpty)
                      IconButton(
                        icon: Icon(Icons.send, color: Colors.green),
                        onPressed: () {
                          chatProvider.sendMessage();
                          _scrollToBottom(); // Прокручиваем до последнего сообщения
                        },
                        color: Colors.green, // Зелёная кнопка
                      ),
                    
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ChatProvider with ChangeNotifier {
  List<Message> _messages = [];
  TextEditingController textController = TextEditingController();
  
  List<Message> get messages => _messages;

  // Initialize Hive and open the chatBox
  Future<void> initHive() async {
    if (!Hive.isBoxOpen('chatBox')) {
      await Hive.openBox('chatBox');
    }
    loadMessages(); // Load messages after opening the box
  }

  void sendWelcomeMessage() {
    final welcomeMessage = Message(
      sender: "Бот",
      text: "Привет! Чем могу помочь?",
    );
    _messages.add(welcomeMessage);
    // Ожидаем завершения фазы построения виджетов перед вызовом notifyListeners
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    _saveMessages();
  }

  void sendMessage() async {
    if (textController.text.isEmpty) return;

    final userMessage = Message(
      sender: "Вы",
      text: textController.text,
    );

    _messages.add(userMessage);
    notifyListeners();
    _saveMessages(); // Save messages
    // Отправка запроса к API
    // String assistantResponse = await _getAssistantResponse(userMessage.text);
    // final botMessage = Message(
    //   sender: "Бот",
    //   text: assistantResponse,
    // );
    // Добавляем ответ бота и уведомляем об изменении
    // _messages.add(botMessage);
    // notifyListeners();
    _saveMessages(); // Сохраняем обновленные сообщения

    // textController.clear();
    sendBotReply(userMessage.text);
    textController.clear();
  }
  // Future<String> _getAssistantResponse(String userText) async {
  //   // Подготовка данных для отправки запроса к API
  //   final url = Uri.parse('https://your-api-url/api/chat/send_message');
  //   final response = await http.post(
  //     url,
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode({
  //       'message': userText,
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     final responseData = jsonDecode(response.body);
  //     // Предполагаем, что API возвращает объект с полем 'response'
  //     return responseData['response'] ?? 'Извините, я не понял ваш запрос.';
  //   } else {
  //     return 'Ошибка подключения к API.';
  //   }
  // }
  void sendBotReply(String userText) {
    String botResponse;

    if (userText.toLowerCase().contains("самая длинная река")) {
      botResponse = "Самая длинная река в мире — Нил или Амазонка.";
    } else if (userText.toLowerCase().contains("самая высокая гора")) {
      botResponse = "Самая высокая гора в мире — Эверест";
    } else if (userText.toLowerCase().contains("clean")) {
      //metod clean chat
      _messages.clear(); // Очищаем список сообщений
      botResponse = "Чат очищен."; 
    } else {
      botResponse = "Извините, я пока не знаю ответа на этот вопрос.";
    }

    final botMessage = Message(
      sender: "Бот",
      text: botResponse,
    );

    _messages.add(botMessage);
    notifyListeners();
    _saveMessages(); // Save messages after bot reply
  }

  // Save messages in Hive
  void _saveMessages() {
    final chatBox = Hive.box('chatBox');
    List<String> messageList = _messages.map((msg) => msg.toJson()).toList();
    chatBox.put('messages', messageList);
  }

  // Load messages from Hive
  void loadMessages() {
    final chatBox = Hive.box('chatBox');
    List<String>? savedMessages = chatBox.get('messages')?.cast<String>();
    if (savedMessages != null) {
      _messages = savedMessages.map((msgJson) => Message.fromJson(msgJson)).toList();
      // Ожидаем завершения фазы построения виджетов перед вызовом notifyListeners
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }
}

class Message {
  final String sender;
  final String text;

  Message({required this.sender, required this.text});

  // Преобразование Message в JSON строку
  String toJson() {
    return jsonEncode({'sender': sender, 'text': text});
  }

  // Преобразование JSON строки в Message объект
  static Message fromJson(String jsonStr) {
    final jsonMap = jsonDecode(jsonStr);
    return Message(
      sender: jsonMap['sender'],
      text: jsonMap['text'],
    );
  }
}

