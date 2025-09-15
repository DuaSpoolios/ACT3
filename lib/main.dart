import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4, // 4 tabs
        child: _TabsNonScrollableDemo(),
      ),
    );
  }
}
class _TabsNonScrollableDemo extends StatefulWidget {
  @override
  __TabsNonScrollableDemoState createState() => __TabsNonScrollableDemoState();
}

class __TabsNonScrollableDemoState extends State<_TabsNonScrollableDemo>
    with SingleTickerProviderStateMixin, RestorationMixin {
  late TabController _tabController;
  final RestorableInt tabIndex = RestorableInt(0);

  @override
  String get restorationId => 'tab_non_scrollable_demo';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');
    _tabController.index = tabIndex.value;
  }
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );
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

  @override
  Widget build(BuildContext context) {
    final tabs = ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4'];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Tabs Demo'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          tabs: [for (final tab in tabs) Tab(text: tab)],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
//TAB 1: Text + AlertDialog added
          Container(
            color: Colors.blue[50],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hello from Tab 1!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text("Alert"),
                          content: Text("This is an Alert Dialog in Tab 1."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("OK"),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text("Show Alert Dialog"),
                  ),
                ],
              ),
            ),
          ),

//TAB 2: Image + TextField (with ClipRRect) This is with the image added in the 2nd tab
          Container(
            color: Colors.green[50],
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Enter some random text about literally anything",
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  //This is where I input the image of the cat
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      'https://images.squarespace-cdn.com/content/v1/607f89e638219e13eee71b1e/1684821560422-SD5V37BAG28BURTLIXUQ/michael-sum-LEpfefQf4rU-unsplash.jpg',
                      width: 300,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ),

//TAB 3: Button + Snackbar
          Container(
            color: Colors.purple[50],
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Button pressed in Tab 3!')),
                  );
                },
                child: Text("Click me"),
              ),
            ),
          ),

//TAB 4: These have the lists with details for all three items
          Container(
            color: Colors.orange[50],
            child: ListView(
              padding: EdgeInsets.all(10),
              children: const [
                Card(
                  elevation: 4,
                  child: ListTile(
                    title: Text("Item 1"),
                    subtitle: Text("This is something about item1"),
                  ),
                ),
                Card(
                  elevation: 4,
                  child: ListTile(
                    title: Text("Item 2"),
                    subtitle: Text("This is something else with item2"),
                  ),
                ),
                Card(
                  elevation: 4,
                  child: ListTile(
                    title: Text("Item 3"),
                    subtitle: Text("Here's more details about item3"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.teal,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "This is a bottom app Bar",
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
