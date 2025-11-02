import 'package:get/get.dart';

class NameController extends GetxController {
  var names = <String>[].obs; // daftar nama yang bisa berubah secara real-time
  var inputText = ''.obs;     // menyimpan teks yang diketik pengguna

  void addName() {
    if (inputText.value.trim().isNotEmpty) {
      names.add(inputText.value.trim());
      inputText.value = ''; // reset input setelah ditambahkan
    }
  }
}
