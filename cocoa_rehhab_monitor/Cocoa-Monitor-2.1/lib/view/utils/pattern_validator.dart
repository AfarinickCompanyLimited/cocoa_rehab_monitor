class RaIdPatternValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Farm reference number is required';
    }

    // Define the pattern using a regular expression
    const pattern = r'^(RA|RT)\/[A-Z]{2}\/[A-Z]{3}\/\d+$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return 'Invalid farm reference';
    }

    // // Additional validation based on the given list
    // final parts = value.split('/');

    // final regionCodes = ['WS', 'CR', 'WN']; // Replace with your actual list

    // if (!regionCodes.contains(parts[1])) {
    //   return 'Invalid region code';
    // }

    // final districtCodes = ['AKT', 'ASG']; // Replace with your actual list

    // if (!districtCodes.contains(parts[2])) {
    //   return 'Invalid district code';
    // }

    return null;
  }
}

class FarmReferencePatternValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Farm reference number is required';
    }

    // Define the pattern using a regular expression
    const pattern = r'^[A-Z]{3}/\d{3}/\d{2}/\d{3}/[SX]\d{2}/\d+$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return 'Invalid farm reference';
    }

    return null;
  }
}
