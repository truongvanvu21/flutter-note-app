import 'package:flutter/material.dart';

class EmptyNotesState extends StatelessWidget {
  const EmptyNotesState({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.note_alt_outlined,
              size: 90,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Ghi chú trống',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
