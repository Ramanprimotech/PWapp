extension Validator on String {
  bool isValidEmail() {
    return RegExp(
            r"^[a-zA-Z0-9.!#\$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\$")
        .hasMatch(this);
  }
}
