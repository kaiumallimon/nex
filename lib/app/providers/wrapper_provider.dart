import 'package:flutter/material.dart';

class WrapperProvider extends ChangeNotifier {
  PageController? _pageController;

  PageController get pageController {
    _pageController ??= PageController();
    return _pageController!;
  }

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }
}
