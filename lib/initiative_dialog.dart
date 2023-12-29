import 'package:flutter/material.dart';
import 'rect_button.dart';

class InitiativeDialog extends StatefulWidget {
  final int initiativeScore;

  InitiativeDialog({required this.initiativeScore});

  @override
  _InitiativeDialogState createState() => _InitiativeDialogState();
}

class _InitiativeDialogState extends State<InitiativeDialog> {
  late TextEditingController controller;
  int? initiativeScore;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    initiativeScore = widget.initiativeScore;
    controller = TextEditingController(text: '${widget.initiativeScore}');
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        controller.selection =
            TextSelection(baseOffset: 0, extentOffset: controller.text.length);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 250,
        height: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(
              color: Theme.of(context).colorScheme.inversePrimary, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Iniziativa'),
              focusNode: focusNode,
              controller: controller,
              onChanged: (value) {
                initiativeScore = int.tryParse(value) ?? 0;
              },
              onSubmitted: (value) {
                Navigator.of(context).pop(initiativeScore);
              },
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 50),
            RectButton(
              primary: true,
              width: 125,
              onPressed: () {
                Navigator.of(context).pop(initiativeScore);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }
}
