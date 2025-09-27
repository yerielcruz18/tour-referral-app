import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  String selectedPeriod = 'Weekly';
  
  // Mock data - will be replaced with Firebase later
  final List<Map<String, dynamic>> leaderboardData = [
    {'rank': 1, 'name': 'Maria Santos', 'points': 3250, 'shares': 65, 'change': 'up', 'avatar': '👩'},
    {'rank': 2, 'name': 'Juan Cruz', 'points': 2980, 'shares': 59, 'change': 'up', 'avatar': '👨'},
    {'rank': 3, 'name': 'Ana Reyes', 'points': 2750, 'shares': 55, 'change': 'down', 'avatar': '👩‍🦰'},
    {'rank': 4, 'name': 'Pedro Garcia', 'points': 2500, 'shares': 50, 'change': 'same', 'avatar': '🧔'},
    {'rank': 5, 'name': 'Lisa Chen', 'points': 2350, 'shares': 47, 'change': 'up', 'avatar': '👩‍💼'},
    {'rank': 6, 'name': 'Carlos Mendoza', 'points': 2200, 'shares': 44, 'change': 'up', 'avatar': '👨‍💼'},
    {'rank': 7, 'name': 'Sofia Tan', 'points': 2100, 'shares': 42, 'change': 'down', 'avatar': '👱‍♀️'},
    {'rank': 8, 'name': 'Roberto Lee', 'points': 1950, 'shares': 39, 'change': 'same', 'avatar': '👨‍🦱'},
    {'rank': 9, 'name': 'Diana Torres', 'points': 1800, 'shares': 36, 'change': 'up', 'avatar': '👩‍🦱'},
    {'rank': 10, 'name': 'Miguel Lim', 'points': 1650, 'shares': 33, 'change': 'down', 'avatar': '👨‍🎓'},
    {'rank': 11, 'name': 'Rosa Villa', 'points': 1500, 'shares': 30, 'change': 'up', 'avatar': '👵'},
    {'rank': 12, 'name': 'YOU', 'points': 1250, 'shares': 25, 'change': 'up', 'avatar': '🌟', 'isCurrentUser': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Leaderboard',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Period Selector
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPeriodChip('Daily'),
                _buildPeriodChip('Weekly'),
                _buildPeriodChip('Monthly'),
                _buildPeriodChip('All Time'),
              ],
            ),
          ),
          
          // Top 3 Podium
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[700]!, Colors.blue],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // 2nd Place
                _buildPodiumPlace(
                  rank: 2,
                  name: leaderboardData[1]['name'],
                  points: leaderboardData[1]['points'],
                  avatar: leaderboardData[1]['avatar'],
                  height: 100,
                  color: Colors.grey[400]!,
                ),
                SizedBox(width: 10),
                // 1st Place
                _buildPodiumPlace(
                  rank: 1,
                  name: leaderboardData[0]['name'],
                  points: leaderboardData[0]['points'],
                  avatar: leaderboardData[0]['avatar'],
                  height: 120,
                  color: Colors.amber,
                ),
                SizedBox(width: 10),
                // 3rd Place
                _buildPodiumPlace(
                  rank: 3,
                  name: leaderboardData[2]['name'],
                  points: leaderboardData[2]['points'],
                  avatar: leaderboardData[2]['avatar'],
                  height: 80,
                  color: Colors.brown[300]!,
                ),
              ],
            ),
          ),
          
          // Your Rank Banner (if not in top 3)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: Colors.blue[50],
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '#12',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Current Rank',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '1,250 points • 25 shares',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.arrow_upward, color: Colors.green, size: 16),
                      Text(
                        ' +3',
                        style: GoogleFonts.poppins(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Full Leaderboard List
          Expanded(
            child: ListView.builder(
              itemCount: leaderboardData.length - 3, // Skip top 3
              itemBuilder: (context, index) {
                final user = leaderboardData[index + 3]; // Start from 4th
                final isCurrentUser = user['isCurrentUser'] ?? false;
                
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: isCurrentUser ? Colors.blue[50] : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: isCurrentUser 
                      ? Border.all(color: Colors.blue, width: 2)
                      : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Rank
                        Container(
                          width: 30,
                          child: Text(
                            '#${user['rank']}',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: isCurrentUser ? Colors.blue : Colors.grey[600],
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        // Avatar
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isCurrentUser ? Colors.blue[100] : Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              user['avatar'],
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    title: Text(
                      user['name'],
                      style: GoogleFonts.poppins(
                        fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.w500,
                        color: isCurrentUser ? Colors.blue : null,
                      ),
                    ),
                    subtitle: Text(
                      '${user['shares']} shares',
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Change indicator
                        if (user['change'] == 'up')
                          Icon(Icons.arrow_upward, color: Colors.green, size: 16),
                        if (user['change'] == 'down')
                          Icon(Icons.arrow_downward, color: Colors.red, size: 16),
                        if (user['change'] == 'same')
                          Icon(Icons.remove, color: Colors.grey, size: 16),
                        SizedBox(width: 8),
                        // Points
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${user['points']}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isCurrentUser ? Colors.blue : null,
                              ),
                            ),
                            Text(
                              'points',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPeriodChip(String period) {
    final isSelected = selectedPeriod == period;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPeriod = period;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          period,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
  
  Widget _buildPodiumPlace({
    required int rank,
    required String name,
    required int points,
    required String avatar,
    required double height,
    required Color color,
  }) {
    return Column(
      children: [
        // Avatar with crown for 1st
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 3),
              ),
              child: Center(
                child: Text(avatar, style: TextStyle(fontSize: 28)),
              ),
            ),
            if (rank == 1)
              Positioned(
                top: -5,
                child: Text('👑', style: TextStyle(fontSize: 24)),
              ),
          ],
        ),
        SizedBox(height: 8),
        // Name
        Text(
          name.split(' ')[0], // First name only
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        // Points
        Text(
          '$points pts',
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        SizedBox(height: 8),
        // Podium
        Container(
          width: 80,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Center(
            child: Text(
              '$rank',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}