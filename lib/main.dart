import 'package:flutter/material.dart';

void main() {
  runApp(const PetApp());
}

class PetApp extends StatelessWidget {
  const PetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFE6E6FA), // lavender
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE6E6FA),
          foregroundColor: Colors.purple,
        ),
      ),
      home: const PetTabs(),
    );
  }
}

class PetTabs extends StatefulWidget {
  const PetTabs({super.key});

  @override
  State<PetTabs> createState() => _PetTabsState();
}

class _PetTabsState extends State<PetTabs>
    with SingleTickerProviderStateMixin, RestorationMixin {
  late TabController _tabController;
  final RestorableInt tabIndex = RestorableInt(0);

  @override
  String get restorationId => 'pet_tabs';

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

  // ---- Pet Images ----
  final String dogImg =
      'https://images.unsplash.com/photo-1518717758536-85ae29035b6d?auto=format&fit=crop&w=800&q=80';
  final String catImg =
      'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?auto=format&fit=crop&w=800&q=80';
  final String hamsterImg =
      'https://images.pexels.com/photos/209096/pexels-photo-209096.jpeg?auto=compress&cs=tinysrgb&w=800';
  final String snakeImg =
      'https://images.pexels.com/photos/45246/green-tree-python-python-tree-python-green-45246.jpeg?auto=compress&cs=tinysrgb&w=800';
  // ---------------------

  Widget _petImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        url,
        width: 300,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stack) => Container(
          width: 300,
          height: 200,
          color: const Color(0xFFEDE7F6),
          alignment: Alignment.center,
          child: const Text(
            'Image failed to load',
            style: TextStyle(color: Colors.purple),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ['Dog', 'Cat', 'Penguin', 'Snake'];
    final images = [dogImg, catImg, hamsterImg, snakeImg];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Gallery'),
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
          for (final img in images)
            Center(child: _petImage(img)),
        ],
      ),
      bottomNavigationBar: const BottomAppBar(
        color: Color(0xFFE6E6FA),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Pet App – Dog • Cat • Penguin • Snake",
            style: TextStyle(color: Colors.purple, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
