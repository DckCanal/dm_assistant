import 'package:dm_assistant/character.dart';
import 'package:dm_assistant/rect_button.dart';
import 'package:flutter/material.dart';

class NewCharDialog extends Dialog {
  const NewCharDialog({super.key});
  @override
  Widget build(BuildContext context) {
    String name = '';
    int initiativeBonus = 0;
    int? initiativeScore;
    return Dialog(
      child: Container(
        width: 500,
        decoration: BoxDecoration(
          color: Colors.black, 
          border: Border.all(
              color: Theme.of(context).colorScheme.inversePrimary, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const Text('Nuovo personaggio',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Nome'),
                    onChanged: (value) {
                      name = value;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    decoration:
                        const InputDecoration(labelText: 'Bonus di iniziativa'),
                    onChanged: (value) {
                      initiativeBonus = int.tryParse(value) ?? 0;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    decoration: const InputDecoration(
                        labelText: 'Punteggio di iniziativa (opzionale)'),
                    onChanged: (value) {
                      initiativeScore = int.tryParse(value);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RectButton(
                  primary: false,
                  width: 125,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Annulla',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(width: 20),
                RectButton(
                  primary: true,
                  width: 125,
                  onPressed: () {
                    Navigator.of(context)
                        .pop(Character(initiativeBonus, name, initiativeScore));
                  },
                  child: const Text('Aggiungi'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
