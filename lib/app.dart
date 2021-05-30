import 'package:flutter/material.dart';
import 'package:packet_tracer/screens/auth_screen.dart';

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Название этой залупы',
              style: TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AuthScreen(isRegistration: false),
                  ),
                );
              },
              child: SizedBox(
                width: 200,
                child: Center(child: Text('Войти')),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AuthScreen(isRegistration: true),
                  ),
                );
              },
              child: SizedBox(
                width: 200,
                child: Center(child: Text('Зарегистрироваться')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
