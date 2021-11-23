class ChatService{
   static bool validatelcl(String _lclValue) {
    print(double.parse(_lclValue));
    print(double.parse(_lclValue));
    if (!_lclValue.isEmpty && double.parse(_lclValue) < 2000.0 && double.parse(_lclValue) >= 0.0) {
      return true;
    }
    return false;
  }

  static  bool validateUcl(String _uclValue) {
    print(double.parse(_uclValue));
    print(double.parse(_uclValue));
    if (!_uclValue.isEmpty && double.parse(_uclValue) < 2000.0 && double.parse(_uclValue) >= 0.0) {
      return true;
    }
    return false;
  }
}