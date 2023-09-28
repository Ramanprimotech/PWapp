import 'package:flutter/services.dart';

class InputHelper {
  static const int phoneLength = 14;
  static List<TextInputFormatter> phoneFormatter = [
    FilteringTextInputFormatter.digitsOnly,
    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
    _PhoneNumberFormatter(),
    LengthLimitingTextInputFormatter(phoneLength),
  ];

  static String phoneRegular(String phone) {
    String data = phone;
    data = data.replaceAll("(", "");
    data = data.replaceAll(")", "");
    data = data.replaceAll("-", "");
    data = data.replaceAll(" ", "");
    return data;
  }

  static String phoneToFormat(String x) {
    x = "(${x.substring(0, 3)}) ${x.substring(3, 6)}-${x.substring(6, x.length)}";
    return x;
  }
}

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();

    if (newTextLength >= 1) {
      newText.write('(');
      if (newValue.selection.end >= 1) selectionIndex++;
    }
    if (newTextLength >= 4) {
      newText.write('${newValue.text.substring(0, usedSubstringIndex = 3)}) ');
      if (newValue.selection.end >= 3) selectionIndex += 2;
    }
    if (newTextLength >= 7) {
      newText.write('${newValue.text.substring(3, usedSubstringIndex = 6)}-');
      if (newValue.selection.end >= 6) selectionIndex++;
    }
    if (newTextLength >= 11) {
      newText.write('${newValue.text.substring(6, usedSubstringIndex = 10)} ');
      if (newValue.selection.end >= 10) selectionIndex++;
    }

    if (newTextLength >= usedSubstringIndex) {
      newText.write(newValue.text.substring(usedSubstringIndex));
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
