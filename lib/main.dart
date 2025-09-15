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
        primaryColor: const Color(0xFFE6E6FA),
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE6E6FA), 
            foregroundColor: Colors.purple,  
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE6E6FA),     
          foregroundColor: Colors.purple,       
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

  //Pet stats
  int hunger = 50;   
  int happiness = 50; 
  int energy = 50;    

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
  void _sleep()=> setState(() {
        energy= _clamp(energy + 25);
        hunger= _clamp(hunger + 10);
      });
  @override
  Widget build(BuildContext context) {
    final tabs = ['Feed', 'Play', 'Sleep', 'Stats'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Digital Pet'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.purple,         
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.purple,
          tabs: [for (final t in tabs) Tab(text: t)],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
        //Feed
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.restaurant),
              label: const Text("Feed Pet"),
              onPressed: () {
                _feed();
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text("Pet fed!")));
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
                    const SnackBar(content: Text("Your pet is happier!")));
              },
            ),
          ),
//Sleep
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.bedtime),
              label: const Text("Put Pet to Sleep"),
              onPressed: () {
                _sleep();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Your pet had a nice nap!")));
              },
            ),
          ),
//Stats
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://cdn.shopify.com/s/files/1/2668/1922/files/british-shorthair-1.jpg?v=1689089942',
                    width: 250,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Hunger:    $hunger",
                  style: const TextStyle(fontSize: 20, color: Colors.purple),
                ),
                const SizedBox(height: 8),
                Text(
                  "Happiness: $happiness",
                  style: const TextStyle(fontSize: 20, color: Colors.purple),
                ),
                const SizedBox(height: 8),
                Text(
                  "Energy:    $energy",
                  style: const TextStyle(fontSize: 20, color: Colors.purple),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomAppBar(
        color: Color(0xFFE6E6FA), 
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Digital Pet – Activity 3",
            style: TextStyle(color: Colors.purple, fontSize: 16), 
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
