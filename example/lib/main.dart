import 'package:flutter/material.dart';
import 'package:flutter_ibadah/flutter_ibadah.dart';

import 'strings.dart';

void main() {
  runApp(const MyApp());
}

/// Cities across several countries and timezones, to show that the widget is
/// no longer tied to Bangladesh.
const List<IbadahLocation> worldLocations = [
  IbadahLocation(city: 'Dhaka', country: 'Bangladesh'),
  IbadahLocation(city: 'Mecca', country: 'Saudi Arabia'),
  IbadahLocation(city: 'Istanbul', country: 'Turkey'),
  IbadahLocation(city: 'Cairo', country: 'Egypt'),
  IbadahLocation(city: 'Jakarta', country: 'Indonesia'),
  IbadahLocation(city: 'Kuala Lumpur', country: 'Malaysia'),
  IbadahLocation(city: 'London', country: 'United Kingdom'),
  IbadahLocation(city: 'Toronto', country: 'Canada'),
  IbadahLocation(city: 'New York', country: 'United States'),
];

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
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 4, vsync: this);

  String currentLocale = 'en';
  bool isDarkTheme = false;

  /// Bound to the "Global" tab's widget: pull down to refresh, or watch its
  /// status change as it fetches / retries.
  final IbadahController ibadahController = IbadahController();

  /// Driven by the dropdowns on the "Calculation" tab.
  IbadahCalculationMethod method = IbadahCalculationMethod.karachi;
  IbadahSchool school = IbadahSchool.hanafi;

  IbadahTheme get _theme =>
      isDarkTheme ? IbadahTheme.dark() : IbadahTheme.light();

  @override
  void dispose() {
    _tabs.dispose();
    ibadahController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: isDarkTheme
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData.light(useMaterial3: true),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
            actions: [
              IconButton(
                tooltip: isDarkTheme ? 'Light theme' : 'Dark theme',
                icon: Icon(isDarkTheme ? Icons.light_mode : Icons.dark_mode),
                onPressed: () => setState(() => isDarkTheme = !isDarkTheme),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.language),
                onSelected: (value) => setState(() => currentLocale = value),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'en', child: Text('English')),
                  PopupMenuItem(value: 'bn', child: Text('বাংলা')),
                  PopupMenuItem(value: 'ar', child: Text('العربية')),
                ],
              ),
            ],
            bottom: TabBar(
              controller: _tabs,
              isScrollable: true,
              tabs: const [
                Tab(text: 'Global'),
                Tab(text: 'Bangladesh'),
                Tab(text: 'Calculation'),
                Tab(text: 'Theming'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabs,
            children: [
              _buildGlobalTab(),
              _buildBangladeshTab(),
              _buildCalculationTab(),
              _buildThemingTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _page({required List<Widget> children}) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      );

  Widget _note(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(text, style: Theme.of(context).textTheme.bodySmall),
      );

  Widget _section(String title, Widget child) => Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 4),
                child:
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
              ),
              const SizedBox(height: 8),
              child,
            ],
          ),
        ),
      );

  // --------------------------------------------------------------- Global ---

  /// Cities from nine countries, plus the controller status line. Pull to
  /// refresh drives `IbadahController.refresh()`.
  Widget _buildGlobalTab() {
    return RefreshIndicator(
      onRefresh: ibadahController.refresh,
      child: _page(
        children: [
          _note(
            'Any country, not just Bangladesh. Tap the location chip to pick '
            'a city — the times and the countdown follow that city\'s own '
            'timezone, even when this device is somewhere else.',
          ),
          _buildControllerStatus(),
          _section(
            'Worldwide locations',
            IbadahWidget(
              controller: ibadahController,
              locations: worldLocations,
              initialLocation: worldLocations.first,
              currentLocale: currentLocale,
              supportedLocals: demoLocales,
              ibadahStrings: demoStrings,
              ibadahTheme: _theme,
            ),
          ),
        ],
      ),
    );
  }

  /// A live read-out of everything [IbadahController] exposes.
  Widget _buildControllerStatus() {
    return ListenableBuilder(
      listenable: ibadahController,
      builder: (context, _) {
        final updated = ibadahController.lastUpdated;
        final error = ibadahController.errorMessage;
        final location = ibadahController.location;
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status: ${ibadahController.status.name}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (location != null)
                        Text(
                          'Location: ${location.city}, ${location.country}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      if (updated != null)
                        Text(
                          'Updated: ${updated.hour}:'
                          '${updated.minute.toString().padLeft(2, '0')}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      if (error != null)
                        Text(
                          error,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: Theme.of(context).colorScheme.error),
                        ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: ibadahController.refresh,
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Refresh'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ----------------------------------------------------------- Bangladesh ---

  /// No `locations`, no `calculationMethod`, no `school` — the pre-0.3.0 call
  /// site, unchanged. Still the 64 districts, still Karachi/Hanafi, still
  /// opening on Dhaka.
  Widget _buildBangladeshTab() {
    return _page(
      children: [
        _note(
          'Passing no location list keeps the original behaviour: the 64 '
          'districts of Bangladesh, the Karachi method and the Hanafi school, '
          'opening on Dhaka. Existing code needs no changes.',
        ),
        _section(
          'Defaults (unchanged from 0.2.x)',
          IbadahWidget(
            currentLocale: currentLocale,
            supportedLocals: demoLocales,
            ibadahStrings: demoStrings,
            ibadahTheme: _theme,
          ),
        ),
        const SizedBox(height: 16),
        _section(
          'Localized district labels',
          IbadahWidget(
            currentLocale: currentLocale,
            supportedLocals: demoLocales,
            ibadahStrings: demoStrings,
            ibadahTheme: _theme,
            locations: const [
              IbadahLocation(
                  city: 'Dhaka', country: 'Bangladesh', label: 'ঢাকা'),
              IbadahLocation(
                  city: 'Chattogram',
                  country: 'Bangladesh',
                  label: 'চট্টগ্রাম'),
              IbadahLocation(
                  city: 'Sylhet', country: 'Bangladesh', label: 'সিলেট'),
              IbadahLocation(
                  city: 'Khulna', country: 'Bangladesh', label: 'খুলনা'),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------- Calculation ---

  /// The same city under different conventions — the times visibly move.
  Widget _buildCalculationTab() {
    return _page(
      children: [
        _note(
          'Fajr and Isha depend on whose solar angles you follow, and Asr on '
          'the juristic school. Change either and watch the times move.',
        ),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<IbadahCalculationMethod>(
                initialValue: method,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Method',
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final m in IbadahCalculationMethod.values)
                    DropdownMenuItem(
                      value: m,
                      child: Text(m.name, overflow: TextOverflow.ellipsis),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => method = value);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<IbadahSchool>(
                initialValue: school,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'School',
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final s in IbadahSchool.values)
                    DropdownMenuItem(value: s, child: Text(s.name)),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => school = value);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _section(
          'method: ${method.name} (${method.id}) · school: ${school.name}',
          IbadahWidget(
            locations: worldLocations,
            calculationMethod: method,
            school: school,
            currentLocale: currentLocale,
            supportedLocals: demoLocales,
            ibadahStrings: demoStrings,
            ibadahTheme: _theme,
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------- Theming ---

  Widget _buildThemingTab() {
    return _page(
      children: [
        _note('The same widget under each of the three theme constructors.'),
        _section(
          'IbadahTheme.fromSeed(Colors.green)',
          IbadahWidget(
            locations: worldLocations,
            currentLocale: currentLocale,
            supportedLocals: demoLocales,
            ibadahStrings: demoStrings,
            ibadahTheme: IbadahTheme.fromSeed(
              seedColor: Colors.green,
              brightness: isDarkTheme ? Brightness.dark : Brightness.light,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _section(
          'Fully custom, with a gradient',
          IbadahWidget(
            locations: worldLocations,
            currentLocale: currentLocale,
            supportedLocals: demoLocales,
            ibadahStrings: demoStrings,
            useGradient: true,
            ibadahTheme: const IbadahTheme(
              backgroundColor: Color(0xFFF8F8FF),
              salatIconBackground: Colors.white,
              backgroundGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
              ),
              primaryColor: Color(0xFF000000),
              secondaryColor: Color(0xFF43641A),
              foregroundOnBackground: Color(0xFF12111A),
              foregroundOnPrimary: Color(0xFFFFFFFF),
              foregroundOnSecondary: Color(0xFFFFFFFF),
              border: Color(0xFFE7E7E8),
              previousPrayerColor: Color(0xFFC4C4C4),
              currentPrayerColor: Color(0xFF000000),
              upcomingPrayerColor: Color(0xFF575660),
            ),
          ),
        ),
      ],
    );
  }
}
