import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:remember_to_pay/app/modules/home/home_controller.dart';
import 'package:remember_to_pay/app/services/note/note_service.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:uuid/uuid.dart';

class AddNoteController extends Disposable {
  final formKey = GlobalKey<FormState>();
  final desc = TextEditingController();
  final dateText = TextEditingController();
  final date = RxNotifier<DateTime>(DateTime.now());

  final HomeController _homeController;
  final NoteService _noteService;

  AddNoteController(this._homeController, this._noteService);

  Future<void> onSaved() async {
    if (formKey.currentState!.validate()) {
      final note = await _noteService.addNote(
        Uuid().v4(),
        desc.text,
        date.value,
      );

      if (note != null) {
        _homeController.setNoteInList(
          note,
        );
        Modular.to.pop();
      }
    }
  }

  String? validatorDesc(String? value) {
    if (value == null || value.length < 1) {
      return 'Descrição inválida';
    }
    return null;
  }

  @override
  void dispose() {}
}
