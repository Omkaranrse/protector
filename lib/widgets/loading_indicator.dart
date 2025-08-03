import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final String? message;
  final bool isOverlay;
  final Color? color;

  const LoadingIndicator({
    super.key,
    this.message,
    this.isOverlay = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? Theme.of(context).primaryColor,
          ),
        ),
        if (message != null) ...[  
          const SizedBox(height: 16),
          Text(
            message!,
            style: TextStyle(
              color: isOverlay ? Colors.white : null,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );

    if (isOverlay) {
      return Container(
        color: Colors.black54,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            child: content,
          ),
        ),
      );
    }

    return Center(child: content);
  }
}

// A widget that shows a loading overlay on top of another widget
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final String? loadingMessage;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    this.loadingMessage,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          LoadingIndicator(
            message: loadingMessage,
            isOverlay: true,
          ),
      ],
    );
  }
}