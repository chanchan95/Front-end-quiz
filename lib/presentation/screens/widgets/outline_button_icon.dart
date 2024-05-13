import 'package:flutter/material.dart';

class OutlinedButtonIcon extends StatefulWidget {
  final void Function()? onPressed;
  final IconData? icon;
  final String label;
  final Color color;
  final double? size;

  const OutlinedButtonIcon({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.color,
    this.size,
  });

  @override
  State<OutlinedButtonIcon> createState() => _OutlinedButtonIconState();
}

class _OutlinedButtonIconState extends State<OutlinedButtonIcon> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: widget.onPressed,
      icon: Icon(
        widget.icon,
        color: widget.color,
        size: widget.size,
      ),
      label: Text(
        widget.label,
        style: TextStyle(
          color: widget.color,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: widget.color,
        ),
        foregroundColor: widget.color,
      ),
    );
  }
}
