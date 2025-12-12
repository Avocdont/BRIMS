import 'dart:math';
import 'package:brims/provider/household%20providers/household_provider.dart';
import 'package:brims/provider/profiling%20providers/person_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/tables/enums.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PersonProvider>().getAllPersons();
      context.read<HouseholdProvider>().getAllHouseholds();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Get Data
    final personProvider = context.watch<PersonProvider>();
    final householdProvider = context.watch<HouseholdProvider>();
    final persons = personProvider.allPersons;
    final households = householdProvider.allHouseholds;

    // 2. Calculations
    final int totalPop = persons.length;
    final int totalHouseholds = households.length;
    final int totalVoters =
        persons.where((p) => p.registered_voter == true).length;

    // Demographics
    final int males = persons.where((p) => p.sex == Sex.male).length;
    final int females = persons.where((p) => p.sex == Sex.female).length;

    final int genderTotal = males + females;
    final int safeGenderBase = genderTotal == 0 ? 1 : genderTotal;
    final double malePct = (males / safeGenderBase);
    final double femalePct = (females / safeGenderBase);

    // --- REVISED AGE GROUPS LOGIC ---
    // Count unknowns separately
    final int unknownAge = persons.where((p) => p.age == null).length;

    // Strictly check for non-null age
    final int infants =
        persons.where((p) => p.age != null && p.age! <= 2).length;
    final int children = persons
        .where((p) => p.age != null && p.age! > 2 && p.age! <= 12)
        .length;
    final int teens = persons
        .where((p) => p.age != null && p.age! > 12 && p.age! <= 17)
        .length;
    final int adults = persons
        .where((p) => p.age != null && p.age! > 17 && p.age! < 60)
        .length;
    final int seniors =
        persons.where((p) => p.age != null && p.age! >= 60).length;

    // Vulnerable Sectors
    final int pwds = persons.where((p) => p.pwd == true).length;
    final int soloParents = persons
        .where((p) => p.solo_parent != null && p.solo_parent != SoloParent.no)
        .length;
    // Minors: Check for non-null and under 18
    final int minors =
        persons.where((p) => p.age != null && p.age! < 18).length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Barangay Statistics"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[200], height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. OVERVIEW ---
            const Text("Overview",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildKpiCard(
                    "Population", "$totalPop", Icons.groups, Colors.blue),
                _buildKpiCard("Households", "$totalHouseholds", Icons.home,
                    Colors.orange),
                _buildKpiCard(
                    "Voters", "$totalVoters", Icons.how_to_vote, Colors.purple),
              ],
            ),

            const SizedBox(height: 40),

            // --- 2. DEMOGRAPHICS ---
            const Text("Demographics",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SEX RATIO (Donut Chart)
                Expanded(
                  flex: 2,
                  child: _buildSectionCard(
                    title: "Gender Ratio",
                    child: Column(
                      children: [
                        SizedBox(
                          height: 180,
                          width: 180,
                          child: CustomPaint(
                            painter: DonutChartPainter(
                              value1: males.toDouble(),
                              value2: females.toDouble(),
                              color1: Colors.pinkAccent,
                              color2: Colors.blueAccent,
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("$totalPop",
                                      style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold)),
                                  const Text("Total",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildLegendItem(
                                "Male", males, malePct, Colors.blueAccent),
                            _buildLegendItem("Female", females, femalePct,
                                Colors.pinkAccent),
                          ],
                        )
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 24),

                // AGE DISTRIBUTION (Horizontal Bars)
                Expanded(
                  flex: 3,
                  child: _buildSectionCard(
                    title: "Age Groups",
                    child: Column(
                      children: [
                        _buildAgeBar("Infants (0-2)", infants, totalPop,
                            Colors.lightBlue),
                        const SizedBox(height: 12),
                        _buildAgeBar("Children (3-12)", children, totalPop,
                            Colors.green),
                        const SizedBox(height: 12),
                        _buildAgeBar(
                            "Teens (13-17)", teens, totalPop, Colors.orange),
                        const SizedBox(height: 12),
                        _buildAgeBar(
                            "Adults (18-59)", adults, totalPop, Colors.indigo),
                        const SizedBox(height: 12),
                        _buildAgeBar(
                            "Seniors (60+)", seniors, totalPop, Colors.teal),
                        const SizedBox(height: 12),
                        // NEW: Unknown Age Bar
                        _buildAgeBar(
                            "Unknown Age", unknownAge, totalPop, Colors.grey),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // --- 3. VULNERABLE SECTORS ---
            const Text("Vulnerable Groups",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.start,
                children: [
                  _buildCircularStatCard("Seniors", seniors, totalPop,
                      Icons.elderly_rounded, Colors.teal),
                  _buildCircularStatCard("PWDs", pwds, totalPop,
                      Icons.accessible_forward, Colors.redAccent),
                  _buildCircularStatCard("Solo Parents", soloParents, totalPop,
                      Icons.person_pin, Colors.orange),
                  _buildCircularStatCard("Minors", minors, totalPop,
                      Icons.child_care, Colors.indigo),
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPERS --- (Identical to your provided code)

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87)),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }

  Widget _buildKpiCard(String title, String value, IconData icon, Color color) {
    return SizedBox(
      width: 250,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold)),
                  Text(title,
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularStatCard(
      String title, int count, int total, IconData icon, Color color) {
    double percentage = total == 0 ? 0.0 : (count / total);

    return Container(
      width: 180,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 80,
            width: 80,
            child: Stack(
              children: [
                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: percentage,
                    strokeWidth: 8,
                    color: color,
                    backgroundColor: color.withOpacity(0.1),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Center(
                  child: Icon(icon, color: color, size: 32),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text("$count",
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(title,
              style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text("${(percentage * 100).toStringAsFixed(1)}% of Pop.",
              style: TextStyle(
                  color: color, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildLegendItem(
      String label, int count, double percentage, Color color) {
    return Column(
      children: [
        Text("${(percentage * 100).toStringAsFixed(0)}%",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        Text("$label ($count)",
            style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildAgeBar(String label, int count, int total, Color color) {
    double percentage = total == 0 ? 0 : (count / total);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
              width: 100,
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87))),
          const SizedBox(width: 12),
          Expanded(
            child: Stack(
              children: [
                Container(
                    height: 10,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(5))),
                FractionallySizedBox(
                  widthFactor: percentage.clamp(0.01, 1.0),
                  child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(5))),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
              width: 40,
              child: Text("$count",
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13))),
        ],
      ),
    );
  }
}

// --- CUSTOM PAINTER (Identical to your provided code) ---
class DonutChartPainter extends CustomPainter {
  final double value1;
  final double value2;
  final Color color1;
  final Color color2;

  DonutChartPainter(
      {required this.value1,
      required this.value2,
      required this.color1,
      required this.color2});

  @override
  void paint(Canvas canvas, Size size) {
    double total = value1 + value2;
    if (total == 0) total = 1;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    final strokeWidth = 25.0;

    final rect =
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);

    final paint1 = Paint()
      ..color = color1
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final paint2 = Paint()
      ..color = color2
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final bgPaint = Paint()
      ..color = Colors.grey[100]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawArc(rect, 0, 2 * pi, false, bgPaint);

    double startAngle = -pi / 2;
    double sweepAngle1 = (value1 / total) * 2 * pi;
    double sweepAngle2 = (value2 / total) * 2 * pi;

    if (value1 > 0)
      canvas.drawArc(rect, startAngle, sweepAngle1, false, paint1);
    if (value2 > 0)
      canvas.drawArc(
          rect, startAngle + sweepAngle1, sweepAngle2, false, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
