import 'package:finance_tracker/screens/settings/About.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/finance_provider.dart';
import 'bottom_bar.dart';
import '../income/income_screen.dart';
import '../expense/expense_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../settings/change_profile.dart';
import '../intro_screen/Login.dart';
import '../settings/notification.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FinanceProvider(),
      child: HomeScreen(),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DAAP1 Finance Tracker',
      debugShowCheckedModeBanner: false,
      home: ExpensePage(),
    );
  }
}

class ExpensePage extends StatefulWidget {
  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  int _selectedIndex = 1;
  Future<Map<String, double>>? _convertedBalancesFuture;
  final List<Widget> _pages = [];
  late FinanceProvider _financeProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _financeProvider = Provider.of<FinanceProvider>(context, listen: false);
    _financeProvider.addListener(_onFinanceDataChanged);

    _pages.addAll([
      AddIncomeScreen(),
      _buildHomePage(),
      AddExpenseScreen(),
    ]);

    _financeProvider.fetchIncomes();
    _financeProvider.fetchExpenses();

    _fetchAndUpdateConvertedBalances();
  }

  void _onFinanceDataChanged() {
    _fetchAndUpdateConvertedBalances();
  }

  Future<void> _fetchAndUpdateConvertedBalances() async {
    setState(() {
      _convertedBalancesFuture = _fetchConvertedBalances();
    });
  }

  Future<Map<String, double>> _fetchConvertedBalances() async {
    return await _financeProvider.convertBalanceToCurrencies();
  }

  @override
  void dispose() {
    _financeProvider.removeListener(_onFinanceDataChanged);
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _pickYearMonth(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: firstDayOfMonth,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      helpText: "Select Year and Month",
      selectableDayPredicate: (DateTime val) => val.day == 1,
    );

    if (pickedDate != null) {
      final String selectedCycle =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}";
      _financeProvider.setBudgetCycle(selectedCycle);
    }
  }

  Widget _buildHomePage() {
    return Consumer<FinanceProvider>(
      builder: (context, financeProvider, child) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[100],
                  ),
                  padding: EdgeInsets.all(2),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => _pickYearMonth(context),
                          ),
                          Text(
                            'Budget Cycle: ${financeProvider.currentCycle}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[800],
                            ),
                          ),
                          SizedBox(width: 48),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              title: 'Income',
                              amount:
                                  '${financeProvider.totalIncome.toStringAsFixed(2)} Birr',
                              color: Colors.green,
                              icon: Icons.arrow_downward,
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: _buildStatCard(
                              title: 'Expense',
                              amount:
                                  '${financeProvider.totalExpenses.toStringAsFixed(2)} Birr',
                              color: Colors.red,
                              icon: Icons.arrow_upward,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Your Remaining Balance',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[800],
                          fontFamily: 'Roboto',
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      SizedBox(height: 20),
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.4),
                              spreadRadius: 5,
                              blurRadius: 15,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${financeProvider.balance.toStringAsFixed(2)} Birr',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      FutureBuilder<Map<String, double>>(
                        future: _convertedBalancesFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                  'Failed to load currency conversion data'),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(
                              child: Text('No conversion data available'),
                            );
                          } else {
                            final convertedBalances = snapshot.data!;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              child: GridView.count(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 4 / 3,
                                children: _buildCurrencyConversionCards(
                                    convertedBalances),
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String amount,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(
              icon,
              color: color,
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    amount,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, String> currencySymbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'JPY': '¥',
    'ETB': 'ብር'
  };

  List<Widget> _buildCurrencyConversionCards(
      Map<String, double> convertedBalances) {
    return convertedBalances.entries.map((entry) {
      String currencyCode = entry.key;
      double value = entry.value;

      String symbol = currencySymbols[currencyCode] ?? currencyCode;

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [
              Colors.lightBlueAccent.withOpacity(0.6),
              Colors.lightBlue.withOpacity(0.6)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white.withOpacity(0.8),
              child: Text(
                symbol,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blueGrey[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              '$currencyCode Balance',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '$symbol${value.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
            size: 35,
          ),
          onPressed: () {
            // Navigate to the new page when the button is pressed
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Menu()),
            );
          },
        ),
        title: Text(
          'DAAP Finance Tracker',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 4.0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
              size: 35,
            ),
            onPressed: () {
              // Navigate to the new page when the button is pressed
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TodoList()),
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<TodoItem> _todoList = [];
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodoList();
  }

  Future<void> _loadTodoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? items = prefs.getStringList('todoList');
    if (items != null) {
      setState(() {
        _todoList = items.map((item) {
          List<String> parts = item.split('|');
          return TodoItem(
              description: parts[0], amount: double.parse(parts[1]));
        }).toList();
      });
    }
  }

  Future<void> _saveTodoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> items =
        _todoList.map((item) => '${item.description}|${item.amount}').toList();
    prefs.setStringList('todoList', items);
  }

  void _addTodoItem() {
    if (_descriptionController.text.isNotEmpty &&
        _amountController.text.isNotEmpty) {
      setState(() {
        _todoList.add(TodoItem(
          description: _descriptionController.text,
          amount: double.parse(_amountController.text),
        ));
        _saveTodoList();
        _descriptionController.clear();
        _amountController.clear();
      });
    }
  }

  void _editTodoItem(int index) {
    _descriptionController.text = _todoList[index].description;
    _amountController.text = _todoList[index].amount.toString();
    _removeTodoItem(index);
  }

  void _removeTodoItem(int index) {
    setState(() {
      _todoList.removeAt(index);
      _saveTodoList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'DAAP Finance Plan',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Align to stretch
          children: [
            // Amount Input Field
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  labelStyle: TextStyle(color: Colors.blueGrey), // Label color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                    borderSide: BorderSide(color: Colors.blue), // Border color
                  ),
                  filled: true,
                  fillColor: Colors.white, // Fill color
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 15, horizontal: 20), // Padding
                ),
              ),
            ),

            // Description Input Field
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.blueGrey), // Label color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                    borderSide: BorderSide(color: Colors.blue), // Border color
                  ),
                  filled: true,
                  fillColor: Colors.white, // Fill color
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 15, horizontal: 20), // Padding
                ),
              ),
            ),

            // Add Task Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ElevatedButton(
                onPressed: _addTodoItem,
                style: ElevatedButton.styleFrom(
                  iconColor: Colors.blue, // Button color
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(
                      vertical: 15, horizontal: 5), // Button padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                ),
                child: Text(
                  'Add Task',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),

            // Task List
            Expanded(
              child: ListView.builder(
                itemCount: _todoList.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    elevation: 2,
                    child: ListTile(
                      title: Text(
                        _todoList[index].description,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Amount: ${_todoList[index].amount.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editTodoItem(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeTodoItem(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}

class TodoItem {
  String description;
  double amount;

  TodoItem({required this.description, required this.amount});
}

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String username = '';
  String? email;
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Guest';
      email =
          prefs.getString('email') ?? 'example@example.com'; // Default email
      profileImageUrl = prefs.getString('profileImage');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DAAP Finance Settings',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
          // Profile Avatar and Name Section
          Container(
            color: Colors.blueAccent,
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: profileImageUrl != null
                      ? NetworkImage(profileImageUrl!)
                      : AssetImage('assets/profile.jpg') as ImageProvider,
                  backgroundColor: Colors.white,
                ),
                SizedBox(height: 10),
                Text(
                  username,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  email ?? '',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // Settings List Options
          ListTile(
            leading: Icon(Icons.person, color: Colors.blue),
            title: Text('Profile Settings'),
            subtitle: Text('Edit your profile information'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangeProfile()),
              );
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.notifications, color: Colors.blue),
            title: Text('Notification Settings'),
            subtitle: Text('Manage notification preferences'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationSettings()),
              );
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.info, color: Colors.blue),
            title: Text('Language'),
            subtitle: Text('Learn more about the application'),
            onTap: () {
              // Navigate to an "About" page or show a dialog
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.color_lens, color: Colors.blue),
            title: Text('Theme'),
            subtitle: Text('Choose a theme for the application'),
            onTap: () {
              // Open theme selection dialog
            },
          ),
          Divider(),

          ListTile(
              leading: Icon(Icons.info, color: Colors.blue),
              title: Text('About'),
              subtitle: Text('Learn more about the application'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              }),
          Divider(),

          ListTile(
            leading: Icon(Icons.lock, color: Colors.blue),
            title: Text('Logout'),
            subtitle: Text('Adjust privacy settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
