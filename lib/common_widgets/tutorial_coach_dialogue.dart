import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoachmarkDesc extends StatefulWidget {
  CoachmarkDesc({
    Key? key,
    required this.text,
    this.skip = 'wizardSkip',
    this.next = 'wizardNext',
    this.onSkip,
    this.onNext,
  }) : super(key: key);

  final String text;
  final String skip;
  final String next;
  final VoidCallback? onSkip;
  final VoidCallback? onNext;

  @override
  State<CoachmarkDesc> createState() => _CoachmarkDescState();
}

class _CoachmarkDescState extends State<CoachmarkDesc>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 20,
      duration: const Duration(milliseconds: 800),
    )..repeat(min: 0, max: 20, reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose(); // Dispose the AnimationController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, animationController.value),
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: widget.onSkip, child: Text(widget.skip.tr)),
                SizedBox(width: 16),
                ElevatedButton(onPressed: widget.onNext, child: Text(widget.next.tr))
              ],
            )
          ],
        ),
      ),
    );
  }
}