import 'package:flutter/material.dart';

class RectButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool primary;
  final Icon? icon;
  final double height;
  final double width;
  final double borderRadius;
  final Widget? child;

  const RectButton(
      {this.onPressed,
      required this.primary,
      this.icon,
      this.height = 48.0,
      this.width = 48.0,
      this.borderRadius = 10.0,
      this.child,
      super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return Theme.of(context)
                    .colorScheme
                    .surface; // Colore quando il pulsante è disabilitato
              }
              return primary
                  ? Theme.of(context).colorScheme.onPrimary
                  : Colors.black; // Colore in base al parametro 'primary'
            },
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            // Forma rotonda
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  borderRadius), // Raggio del bordo arrotondato
              side: BorderSide(
                color: onPressed != null
                    ? Theme.of(context).colorScheme.inversePrimary
                    : Theme.of(context).colorScheme.onInverseSurface,

                width: primary && onPressed != null
                    ? 2.0
                    : 1.0, // Larghezza del bordo in base al parametro 'primary'
              ),
            ),
          ),
        ),
        child: child ?? Center(child: icon), // Icona centrata
      ),
    );
  }
}
