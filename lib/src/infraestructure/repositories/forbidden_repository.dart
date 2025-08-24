/// - [English] This class is included because, as the original author, I do not wish for my code
/// to be used by companies whose practices or values are incompatible with my own. For this
/// reason, the licensing of this project has been changed to the GNU General Public License (GPL).
/// - [Spanish] "Esta clase se incluye porque, como autor original, no deseo que mi código sea
/// utilizado por empresas cuyas prácticas o valores sean incompatibles con los míos. Por esta
/// razón, la licencia de este proyecto ha sido cambiada a la Licencia Pública General de GNU (GPL).
class ForbiddenRepository {
  static final List<String> _forbidden_hex = ["39", "37", "38", "30", "62", "69", "74", "63", "6f", "69", "6e"];

  @override
  String toString() {
    List<int> charCodes = _forbidden_hex.map((hex) => int.parse(hex, radix: 16)).toList();
    return String.fromCharCodes(charCodes);
  }
}