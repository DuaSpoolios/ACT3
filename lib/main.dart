import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple, // button background
            foregroundColor: Colors.white, // text/icon color
          ),
        ),
      ),
      home: DefaultTabController(length: 4, child: const DigitalPetHome()),
    );
  }
}

class DigitalPetHome extends StatefulWidget {
  const DigitalPetHome({super.key});
  @override
  State<DigitalPetHome> createState() => _DigitalPetHomeState();
}

class _DigitalPetHomeState extends State<DigitalPetHome>
    with SingleTickerProviderStateMixin, RestorationMixin {
  late TabController _tabController;
  final RestorableInt tabIndex = RestorableInt(0);

  // ---- Pet state ----
  int hunger = 50; // 0 = full, 100 = starving
  int happiness = 50; // 0 = sad, 100 = very happy
  int energy = 50; // 0 = tired, 100 = full of energy

  @override
  String get restorationId => 'digital_pet_home';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');
    _tabController.index = tabIndex.value;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        tabIndex.value = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    tabIndex.dispose();
    super.dispose();
  }

  int _clamp(int v) => v.clamp(0, 100);
  void _feed() => setState(() => hunger = _clamp(hunger - 20));
  void _play() => setState(() {
    happiness = _clamp(happiness + 20);
    energy = _clamp(energy - 10);
  });
  void _sleep() => setState(() {
    energy = _clamp(energy + 25);
    hunger = _clamp(hunger + 10);
  });

  @override
  Widget build(BuildContext context) {
    final tabs = ['Feed', 'Play', 'Sleep', 'Stats'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('My Digital Pet'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.amber,
          tabs: [for (final t in tabs) Tab(text: t)],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Feed
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.restaurant),
              label: const Text("Feed Pet"),
              onPressed: () {
                _feed();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Pet fed!")));
              },
            ),
          ),
          // Play
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.sports_esports),
              label: const Text("Play with Pet"),
              onPressed: () {
                _play();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Your pet is happier!")),
                );
              },
            ),
          ),
          // Sleep
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.bedtime),
              label: const Text("Put Pet to Sleep"),
              onPressed: () {
                _sleep();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Your pet had a nice nap!")),
                );
              },
            ),
          ),
          // Stats
        Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            // 🐱 --- Add a cat picture here ---
            ClipRRect(
                borderRadius: BorderRadius.circular(12), // rounded corners (optional)
                child: Image.network(
                'https://cdn.shopify.com/s/files/1/2668/1922/files/british-shorthair-1.jpg?v=1689089942',
                width: 250,        // adjust size as you like
                height: 180,
                fit: BoxFit.cover, // crop/scale to fill
                ),
            ),
            const SizedBox(height: 20),

            Text(
                "Hunger:    $hunger",
                style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
                "Happiness: $happiness",
                style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
                "Energy:    $energy",
                style: const TextStyle(fontSize: 20),
            ),
            ],
        ),
        ),
      bottomNavigationBar: const BottomAppBar(
        color: Colors.purple,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Digital Pet – Activity 3",
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
