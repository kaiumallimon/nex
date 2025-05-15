import 'package:flutter/material.dart';

class WrapperProvider extends ChangeNotifier {
  PageController? _pageController;
  bool _isDisposed = false;

  WrapperProvider() {
    _initializeController();
  }

  void _initializeController() {
    _pageController = PageController(initialPage: _currentIndex);
    _isDisposed = false;
  }

  PageController get pageController {
    if (_isDisposed || _pageController == null) {
      _initializeController();
    }
    return _pageController!;
  }

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    if (index == _currentIndex) return;
    
    _currentIndex = index;
    if (!_isDisposed && _pageController != null && _pageController!.hasClients) {
      try {
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } catch (e) {
        // Ignore animation errors during transitions
      }
    }
    notifyListeners();
  }

  void reset() {
    if (_pageController != null) {
      if (_pageController!.hasClients) {
        try {
          _pageController!.jumpToPage(0);
        } catch (e) {
          // Ignore jump errors during transitions
        }
      }
      _pageController!.dispose();
    }
    _currentIndex = 0;
    _initializeController();
    notifyListeners();
  }

  @override
  void dispose() {
    if (_pageController != null) {
      if (_pageController!.hasClients) {
        try {
          _pageController!.jumpToPage(0);
        } catch (e) {
          // Ignore jump errors during disposal
        }
      }
      _pageController!.dispose();
    }
    _isDisposed = true;
    _pageController = null;
    super.dispose();
  }
}
