class AppValidator {
    String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Please enter an email';
    }
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a phone number';
    }
    if (value.length != 10) {
      return 'Please enter a correct 10-digit phone number';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a enter password';
    }

    return null;
  }

  String? validateUsername(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a username';
    }
    return null; // Return null if validation is successful
  }
  String? isEmpty(String? value) {
    if (value!.isEmpty) {
      return 'Please fill details';
    }
    return null; // Return null if validation is successful
  }

}