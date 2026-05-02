import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.title,
    required this.child,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.padding = const EdgeInsets.all(16),
    this.scrollable = true,
    this.centerTitle = false,
    this.contentMaxWidth = 960,
  });

  final String? title;
  final Widget child;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final EdgeInsetsGeometry padding;
  final bool scrollable;
  final bool centerTitle;
  final double contentMaxWidth;

  @override
  Widget build(BuildContext context) {
    final Widget content = Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: contentMaxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );

    return Scaffold(
      appBar: title == null
          ? null
          : AppBar(
              title: Text(
                title!,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              centerTitle: centerTitle,
              actions: actions,
            ),
      body: SafeArea(
        child: scrollable ? SingleChildScrollView(child: content) : content,
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
