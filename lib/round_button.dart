import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool primary;
  final Icon icon;
  final double radius;

  const RoundButton(
      {this.onPressed,
      required this.primary,
      required this.icon,
      this.radius = 48.0,
      super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: radius,
      width: radius,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          elevation: MaterialStateProperty.all(0),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.grey; // Colore quando il pulsante è disabilitato
              }
              return primary
                  ? Theme.of(context).colorScheme.onPrimary
                  : Colors.black; // Colore in base al parametro 'primary'
            },
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
              side: BorderSide(
                color: onPressed != null
                    ? Theme.of(context).colorScheme.inversePrimary
                    : Theme.of(context).colorScheme.onInverseSurface,
                width: primary && onPressed != null ? 2.0 : 1.0,
              ),
            ),
          ),
        ),
        child: Center(child: icon),
      ),
    );
    // return Ink(
    //     decoration: ShapeDecoration(
    //       shape: const CircleBorder(),
    //       //color: Theme.of(context).colorScheme.inversePrimary,
    //       color: switch (primary) {
    //         true => Theme.of(context).colorScheme.onPrimary,
    //         false => Colors.black,
    //       },
    //     ),
    //     child: IconButton.filledTonal(
    //       icon: icon,
    //       iconSize: radius / 2,
    //       onPressed: onPressed,
    //     ));
  }
}
