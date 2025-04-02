import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey.shade100,
      ),
      home: const DatePickerScreen(),
    );
  }
}

class DatePickerScreen extends StatefulWidget {
  const DatePickerScreen({Key? key}) : super(key: key);

  @override
  State<DatePickerScreen> createState() => _DatePickerScreenState();
}

class _DatePickerScreenState extends State<DatePickerScreen> {
  DateTime selectedDate = DateTime(2023, 9, 5);
  final DateTime today = DateTime(2023, 9, 4);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
              )
            ],
            border: Border.all(color: Colors.purple.withOpacity(0.5), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Quick selection buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Expanded(child: _quickDateButton("Today", today)),
                    const SizedBox(width: 12),
                    Expanded(child: _quickDateButton("Next Monday", _getNextMonday())),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          _quickDateButton("Next Tuesday", _getNextTuesday()),
                          Positioned(
                            right: -5,
                            top: -5,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  "3",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          _quickDateButton("After 1 week", today.add(const Duration(days: 7))),
                          Positioned(
                            right: -5,
                            top: -5,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: Colors.pink,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  "6",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Calendar title
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          selectedDate = DateTime(selectedDate.year, selectedDate.month - 1, 1);
                        });
                      },
                    ),
                    const Text(
                      "September 2023",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          selectedDate = DateTime(selectedDate.year, selectedDate.month + 1, 1);
                        });
                      },
                    ),
                  ],
                ),
              ),

              // Calendar weekday headers
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    _WeekdayLabel("Sun"),
                    _WeekdayLabel("Mon"),
                    _WeekdayLabel("Tue"),
                    _WeekdayLabel("Wed"),
                    _WeekdayLabel("Thu"),
                    _WeekdayLabel("Fri"),
                    _WeekdayLabel("Sat"),
                  ],
                ),
              ),

              // Calendar days
              _buildCalendarGrid(),

              const SizedBox(height: 16),

              // Resolution indicator
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text("396 Hug × 472 Hug"),
                ),
              ),

              // Bottom bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('d MMM yyyy').format(selectedDate),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    TextButton(
                      child: const Text("Cancel"),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // primary: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text("Save"),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final DateTime firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final int daysInMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
    
    // Calculate the number of empty cells before the first day of the month
    final int firstWeekdayOfMonth = firstDayOfMonth.weekday % 7; // 0 for Sunday

    List<Widget> calendarCells = [];

    // Add empty cells for days before the start of the month
    for (int i = 0; i < firstWeekdayOfMonth; i++) {
      calendarCells.add(const SizedBox(width: 40, height: 40));
    }

    // Add cells for each day of the month
    for (int day = 1; day <= daysInMonth; day++) {
      final DateTime currentDate = DateTime(selectedDate.year, selectedDate.month, day);
      final bool isSelected = currentDate.day == selectedDate.day;
      final bool isToday = currentDate.day == today.day && 
                         currentDate.month == today.month && 
                         currentDate.year == today.year;
      
      Widget dayCell;
      
      if (isSelected) {
        dayCell = Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              day.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      } else if (isToday) {
        dayCell = Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              day.toString(),
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      } else {
        dayCell = SizedBox(
          width: 40,
          height: 40,
          child: Center(
            child: Text(
              day.toString(),
              style: TextStyle(
                color: Colors.black.withOpacity(0.8),
              ),
            ),
          ),
        );
      }

      calendarCells.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selectedDate = DateTime(selectedDate.year, selectedDate.month, day);
            });
          },
          child: dayCell,
        ),
      );
    }

    // Create rows of 7 days each
    List<Widget> calendarRows = [];
    for (int i = 0; i < calendarCells.length; i += 7) {
      final rowCells = calendarCells.skip(i).take(7).toList();
      calendarRows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: rowCells,
          ),
        ),
      );
    }

    return Column(children: calendarRows);
  }

  DateTime _getNextMonday() {
    DateTime date = today;
    while (date.weekday != DateTime.monday) {
      date = date.add(const Duration(days: 1));
    }
    return date;
  }

  DateTime _getNextTuesday() {
    DateTime date = today;
    while (date.weekday != DateTime.tuesday) {
      date = date.add(const Duration(days: 1));
    }
    return date;
  }

  Widget _quickDateButton(String text, DateTime date) {
    final bool isSelected = date.day == selectedDate.day && 
                          date.month == selectedDate.month && 
                          date.year == selectedDate.year;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDate = date;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.blue.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.blue,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _WeekdayLabel extends StatelessWidget {
  final String text;
  
  const _WeekdayLabel(this.text);
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black.withOpacity(0.6),
          ),
        ),
      ),
    );
  }
}