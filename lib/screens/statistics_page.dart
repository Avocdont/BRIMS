import 'dart:math';
import 'package:brims/provider/household%20providers/household_provider.dart';
import 'package:brims/provider/profiling%20providers/person_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../database/tables/enums.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  // --- Enhanced Color Palette (Matching Main Page) ---
  static const Color primaryBackground = Color(0xFFF5F7FA);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color navBackground = Color(0xFF40C4FF);
  static const Color selectedAccent = Color(0xFF0288D1);
  static const Color actionGreen = Color(0xFF00C853);
  static const Color primaryText = Color(0xFF1A1A1A);
  static const Color secondaryText = Color(0xFF555555);
  static const Color dividerColor = Color(0xFFE0E0E0);

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

    // Age Groups
    final int unknownAge = persons.where((p) => p.age == null).length;
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
    final int minors =
        persons.where((p) => p.age != null && p.age! < 18).length;

    return Container(
      color: primaryBackground,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. OVERVIEW ---
            Text(
              "Overview",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: primaryText,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                _buildKpiCard(
                    "Population", "$totalPop", Icons.groups, Colors.blue),
                _buildKpiCard("Households", "$totalHouseholds", Icons.home,
                    Colors.orange),
                _buildKpiCard(
                    "Voters", "$totalVoters", Icons.how_to_vote, Colors.purple),
              ],
            ),

            const SizedBox(height: 48),

            // --- 2. DEMOGRAPHICS ---
            Text(
              "Demographics",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: primaryText,
              ),
            ),
            const SizedBox(height: 20),

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
                                  Text(
                                    "$totalPop",
                                    style: GoogleFonts.poppins(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: primaryText,
                                    ),
                                  ),
                                  Text(
                                    "Total",
                                    style: GoogleFonts.poppins(
                                      color: secondaryText,
                                      fontSize: 12,
                                    ),
                                  ),
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
                        _buildAgeBar(
                            "Unknown Age", unknownAge, totalPop, Colors.grey),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 48),

            // --- 3. VULNERABLE SECTORS ---
            Text(
              "Vulnerable Groups",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: primaryText,
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
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

  // --- WIDGET HELPERS ---

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }

  Widget _buildKpiCard(String title, String value, IconData icon, Color color) {
    return SizedBox(
      width: 260,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: primaryText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: secondaryText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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
      width: 190,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 90,
            width: 90,
            child: Stack(
              children: [
                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: percentage,
                    strokeWidth: 10,
                    color: color,
                    backgroundColor: color.withOpacity(0.12),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Center(
                  child: Icon(icon, color: color, size: 36),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            "$count",
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: secondaryText,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "${(percentage * 100).toStringAsFixed(1)}% of Pop.",
            style: GoogleFonts.poppins(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(
      String label, int count, double percentage, Color color) {
    return Column(
      children: [
        Text(
          "${(percentage * 100).toStringAsFixed(0)}%",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "$label ($count)",
          style: GoogleFonts.poppins(
            color: secondaryText,
            fontSize: 13,
          ),
        ),
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
            width: 110,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: primaryText,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: percentage.clamp(0.01, 1.0),
                  child: Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 45,
            child: Text(
              "$count",
              textAlign: TextAlign.end,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- CUSTOM PAINTER ---
class DonutChartPainter extends CustomPainter {
  final double value1;
  final double value2;
  final Color color1;
  final Color color2;

  DonutChartPainter({
    required this.value1,
    required this.value2,
    required this.color1,
    required this.color2,
  });

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
      ..color = const Color(0xFFF0F0F0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawArc(rect, 0, 2 * pi, false, bgPaint);

    double startAngle = -pi / 2;
    double sweepAngle1 = (value1 / total) * 2 * pi;
    double sweepAngle2 = (value2 / total) * 2 * pi;

    if (value1 > 0) {
      canvas.drawArc(rect, startAngle, sweepAngle1, false, paint1);
    }
    if (value2 > 0) {
      canvas.drawArc(
          rect, startAngle + sweepAngle1, sweepAngle2, false, paint2);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
