import 'package:flutter/material.dart';

class WrapperProvider extends ChangeNotifier {
  final PageController _pageController = PageController();

  PageController get pageController => _pageController;

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    notifyListeners();
  }
}
