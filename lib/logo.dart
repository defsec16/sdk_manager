import 'package:flutter/material.dart';

class HomePage12 extends StatefulWidget {
  @override
  _HomePage12State createState() => _HomePage12State();
}

class _HomePage12State extends State<HomePage12> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Инициализация контроллера анимации
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    // Анимации для всех элементов
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1), // Начальная позиция снизу экрана
      end: Offset(0, 0),   // Конечная позиция на месте
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    // Запуск анимации
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Создаем букву с анимацией
  Widget _buildAnimatedLetter(String letter) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Text(
          letter,
          style: TextStyle(
            fontSize: 100,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Создаем букву "O" с фоновым изображением
  Widget _buildImageO() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipOval(
              child: Image.asset(
                'assets/o_image.png', // Изображение фона для буквы "O"
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              'O',
              style: TextStyle(
                fontSize: 100,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Создаем линию с анимацией
  Widget _buildAnimatedLine(double angle) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Transform.rotate(
          angle: angle,
          child: Container(
            width: 100,
            height: 4,
            color: Colors.pink,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Верхние линии
            Positioned(
              left: 50,
              top: 80,
              child: _buildAnimatedLine(0.3),
            ),
            Positioned(
              left: 150,
              top: 80,
              child: _buildAnimatedLine(0.3),
            ),
            Positioned(
              left: 250,
              top: 80,
              child: _buildAnimatedLine(0.3),
            ),
            
            // Буквы "L", "Y", "O", "N" по центру
            Positioned(
              left: 50,
              child: _buildAnimatedLetter('L'),
            ),
            Positioned(
              left: 150,
              child: _buildAnimatedLetter('Y'),
            ),
            Positioned(
              left: 250,
              child: _buildImageO(),
            ),
            Positioned(
              left: 350,
              child: _buildAnimatedLetter('N'),
            ),
 // Нижние линии
            Positioned(
              left: 50,
              bottom: 80,
              child: _buildAnimatedLine(-0.3),
            ),
            Positioned(
              left: 150,
              bottom: 80,
              child: _buildAnimatedLine(-0.3),
            ),
            Positioned(
              left: 250,
              bottom: 80,
              child: _buildAnimatedLine(-0.3),
            ),
          ],
        ),
      ),
    );
  }
}           