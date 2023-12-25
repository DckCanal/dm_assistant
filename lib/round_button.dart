import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool primary;
  final Icon icon;
  final double radius;

  RoundButton(
      {this.onPressed,
      required this.primary,
      required this.icon,
      this.radius = 48.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: radius,
      width: radius,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.grey; // Colore quando il pulsante è disabilitato
              }
              return primary
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context)
                      .colorScheme
                      .scrim; // Colore in base al parametro 'primary'
            },
          ),
          //   shape: MaterialStateProperty.all<CircleBorder>(
          //     // Forma rotonda
          //     CircleBorder(
          //       side: BorderSide(
          //         color: Theme.of(context).colorScheme.outline,
          //         width: primary
          //             ? 3.0
          //             : 2.0, // Larghezza del bordo in base al parametro 'primary'
          //       ),
          //     ),
          //   ),
          // ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            // Forma rotonda
            RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(radius), // Raggio del bordo arrotondato
              side: BorderSide(
                color: onPressed != null
                    ? Theme.of(context).colorScheme.inversePrimary
                    : Theme.of(context).colorScheme.onInverseSurface,
                width: primary && onPressed != null
                    ? 3.0
                    : 2.0, // Larghezza del bordo in base al parametro 'primary'
              ),
            ),
          ),
        ),
        // child: SizedBox(
        //   width: radius * sqrt(2), // Larghezza basata sul raggio
        //   height: radius * sqrt(2), // Altezza basata sul raggio
        child: Center(child: icon), // Icona centrata
        //), // Icona del pulsante
      ),
    );
  }
}
