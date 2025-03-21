import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:translations/app_localizations.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.routeError1,
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.home_outlined),
              label: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  l10n.routeError2,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              onPressed: () => context.go('/'),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                    Theme.of(context).primaryColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}
