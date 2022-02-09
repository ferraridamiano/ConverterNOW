import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.routeError1,
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 40,),
            ElevatedButton.icon(
              icon: const Icon(Icons.home_outlined),
              label: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context)!.routeError2,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              onPressed: () => context.go('/'),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor)),
            )
          ],
        ),
      ),
    );
  }
}
