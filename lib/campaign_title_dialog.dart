import 'package:flutter/material.dart';
import 'rect_button.dart';

class CampaignTitleDialog extends StatefulWidget {
  final String oldTitle;

  CampaignTitleDialog({required this.oldTitle});
  @override
  _CampaignTitleDialogState createState() => _CampaignTitleDialogState();
}

class _CampaignTitleDialogState extends State<CampaignTitleDialog> {
  String? newTitle;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    //initiativeScore = widget.initiativeScore;
    //controller = TextEditingController(text: '${widget.initiativeScore}');
    // focusNode.addListener(() {
    //   if (focusNode.hasFocus) {
    //     controller.selection =
    //         TextSelection(baseOffset: 0, extentOffset: controller.text.length);
    //   }
    // });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 300,
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
              //decoration: const InputDecoration(labelText: ''),
              onChanged: (value) {
                newTitle = value != '' ? value : widget.oldTitle;
              },
              onSubmitted: (value) {
                Navigator.of(context).pop(newTitle);
              },
              focusNode: focusNode,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 50),
            RectButton(
              primary: true,
              width: 125,
              onPressed: () {
                Navigator.of(context).pop(newTitle);
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
    //controller.dispose();
    super.dispose();
  }
}
