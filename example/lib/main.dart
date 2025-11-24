import 'package:flutter/material.dart';
import 'package:flutter_ibadah/flutter_ibadah.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Ibadah Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Ibadah Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String currentLocale = 'en';
  bool isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(isDarkTheme ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              setState(() {
                isDarkTheme = !isDarkTheme;
              });
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (String value) {
              setState(() {
                currentLocale = value;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'en',
                child: Text('English'),
              ),
              const PopupMenuItem<String>(
                value: 'bn',
                child: Text('বাংলা'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Example 1: Basic usage with light theme
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Basic Light Theme',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    IbadahWidget(
                      currentLocale: currentLocale,
                      supportedLocals: const ['en', 'bn'],
                      ibadahTheme: isDarkTheme
                          ? IbadahTheme.dark()
                          : IbadahTheme.light(),
                      ibadahStrings: const [
                        IbadahStrings(), // English
                        IbadahStrings(
                          // Bengali
                          ibadah: 'ইবাদত',
                          fajr: 'ফজর',
                          dhuhr: 'যুহর',
                          jummah: 'জুম্মা',
                          asr: 'আসর',
                          maghrib: 'মাগরিব',
                          isha: 'ইশা',
                          fajrNextDay: 'ফজর (পরের দিন)',
                          somethingWentWrong: 'কিছু ভুল হয়েছে',
                          upcoming: 'আসন্ন',
                          startIn: 'শুরু হবে',
                          am: 'সকাল',
                          pm: 'বিকাল',
                          searchHintText: 'জেলা খুঁজুন',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Example 2: Custom theme from seed color
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Custom Theme from Seed Color',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    IbadahWidget(
                      currentLocale: currentLocale,
                      supportedLocals: const ['en', 'bn'],
                      ibadahTheme: IbadahTheme.fromSeed(
                        seedColor: Colors.green,
                        brightness:
                            isDarkTheme ? Brightness.dark : Brightness.light,
                      ),
                      ibadahStrings: const [
                        IbadahStrings(), // English
                        IbadahStrings(
                          // Bengali
                          ibadah: 'ইবাদত',
                          fajr: 'ফজর',
                          dhuhr: 'যুহর',
                          jummah: 'জুম্মা',
                          asr: 'আসর',
                          maghrib: 'মাগরিব',
                          isha: 'ইশা',
                          fajrNextDay: 'ফজর (পরের দিন)',
                          somethingWentWrong: 'কিছু ভুল হয়েছে',
                          upcoming: 'আসন্ন',
                          startIn: 'শুরু হবে',
                          am: 'সকাল',
                          pm: 'বিকাল',
                          searchHintText: 'জেলা খুঁজুন',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Example 3: Fully custom theme
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fully Custom Theme',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    IbadahWidget(
                      currentLocale: currentLocale,
                      supportedLocals: const ['en', 'bn'],
                      ibadahTheme: const IbadahTheme(
                        backgroundColor: Color(0xFFF5F5F5),
                        primaryColor: Color(0xFF6200EE),
                        secondaryColor: Color(0xFF03DAC6),
                        foregroundOnBackground: Color(0xFF000000),
                        foregroundOnPrimary: Color(0xFFFFFFFF),
                        foregroundOnSecondary: Color(0xFF000000),
                        border: Color(0xFFE0E0E0),
                        previousPrayerColor: Color(0xFFB3B3B3),
                        currentPrayerColor: Color(0xFF1976D2),
                        upcomingPrayerColor: Color(0xFF2196F3),
                      ),
                      ibadahStrings: const [
                        IbadahStrings(), // English
                        IbadahStrings(
                          // Bengali
                          ibadah: 'ইবাদত',
                          fajr: 'ফজর',
                          dhuhr: 'যুহর',
                          jummah: 'জুম্মা',
                          asr: 'আসর',
                          maghrib: 'মাগরিব',
                          isha: 'ইশা',
                          fajrNextDay: 'ফজর (পরের দিন)',
                          somethingWentWrong: 'কিছু ভুল হয়েছে',
                          upcoming: 'আসন্ন',
                          startIn: 'শুরু হবে',
                          am: 'সকাল',
                          pm: 'বিকাল',
                          searchHintText: 'জেলা খুঁজুন',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
