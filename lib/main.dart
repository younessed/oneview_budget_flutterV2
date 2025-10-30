
import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(const OneViewApp());

class OneViewApp extends StatelessWidget {
  const OneViewApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OneView Budget',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0618),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String currency = "MAD";
  double balance = 2340;
  double fixedPct = 0.58;
  double variablePct = 0.27;
  double savingPct = 0.72;
  double annualPct = 0.45;

  late final AnimationController _ringController;

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..repeat();
  }

  @override
  void dispose() {
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF160B2E), Color(0xFF100726), Color(0xFF0B051C)],
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Tu gères bien, continue comme ça 💪',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600, height: 1.25),
                ),
              ),
              const SizedBox(height: 12),
              // circular chart
              SizedBox(
                height: 340,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _ringController,
                      builder: (context, _) {
                        return CustomPaint(
                          size: const Size(300, 300),
                          painter: NeonRingPainter(progress: _ringController.value, fixedPct: fixedPct, variablePct: variablePct),
                        );
                      },
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${balance.toStringAsFixed(0)} $currency',
                            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _chip('Fixes', (fixedPct*100).toStringAsFixed(0)),
                            const SizedBox(width: 12),
                            _chip('Variables', (variablePct*100).toStringAsFixed(0)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // info line (global comparison)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: const Text('📊 Tes dépenses sont 9 % au-dessus de la moyenne nationale 💸'),
                ),
              ),
              const SizedBox(height: 14),
              // button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    barrierColor: Colors.black.withOpacity(0.4),
                    builder: (ctx) => const PerfectModelDialog(
                      saving: 0.72, fixed: 0.45, personal: 0.33,
                    ),
                  ),
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: const LinearGradient(colors: [Color(0xFF8B1CFB), Color(0xFFE657C7)]),
                      boxShadow: const [BoxShadow(color: Color(0x802C00FF), blurRadius: 22, spreadRadius: 2)],
                    ),
                    alignment: Alignment.center,
                    child: const Text('Voir modèle parfait', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              // Savings bar
              _metricBar(
                title: 'Épargne',
                value: savingPct,
                color: const Color(0xFF16E5D2),
                note: '📊 Ton épargne est 14 % supérieure à la moyenne des profils similaires 😎',
              ),
              const SizedBox(height: 8),
              // Annual provisions bar
              _metricBar(
                title: 'Provisions annuelles',
                value: annualPct,
                color: const Color(0xFFFF914D),
                note: '📊 Tes dépenses annuelles sont proches de la moyenne nationale ✨',
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(String label, String pct) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(children: [
        Text(label),
        const SizedBox(width: 8),
        Text('$pct %', style: const TextStyle(fontWeight: FontWeight.w600)),
      ]),
    );
  }

  Widget _metricBar({required String title, required double value, required Color color, required String note}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              Text('${(value*100).toStringAsFixed(0)} %', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: value,
              backgroundColor: Colors.white.withOpacity(0.10),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 8),
          Text(note),
        ],
      ),
    );
  }
}

class NeonRingPainter extends CustomPainter {
  final double progress;
  final double fixedPct;
  final double variablePct;
  NeonRingPainter({required this.progress, required this.fixedPct, required this.variablePct});
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width/2, size.height/2);
    final radius = size.width/2 - 8;

    // Outer glow ring
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..shader = const RadialGradient(
        colors: [Color(0x668B1CFB), Color(0x00E657C7)],
      ).createShader(Rect.fromCircle(center: center, radius: radius+30));
    canvas.drawCircle(center, radius+18, glowPaint);

    // Base track
    final base = Paint()
      ..color = const Color(0x22FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 26
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -math.pi*0.85, math.pi*1.7, false, base);

    // Variable arc (inner)
    final varPaint = Paint()
      ..shader = const LinearGradient(colors: [Color(0xFF6A2CF9), Color(0xFFE657C7)]).createShader(Rect.fromCircle(center: center, radius: radius-10))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 22
      ..strokeCap = StrokeCap.round;
    final varSweep = (math.pi*1.7) * variablePct;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius-10), -math.pi*0.85, varSweep, false, varPaint);

    // Fixed arc (outer)
    final fixPaint = Paint()
      ..shader = const LinearGradient(colors: [Color(0xFFE657C7), Color(0xFF6A2CF9)]).createShader(Rect.fromCircle(center: center, radius: radius+10))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 22
      ..strokeCap = StrokeCap.round;
    final fixSweep = (math.pi*1.7) * fixedPct;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius+10), -math.pi*0.85, fixSweep, false, fixPaint);
  }
  @override
  bool shouldRepaint(covariant NeonRingPainter oldDelegate) => true;
}

class PerfectModelDialog extends StatefulWidget {
  final double saving;
  final double fixed;
  final double personal;
  const PerfectModelDialog({super.key, required this.saving, required this.fixed, required this.personal});
  @override
  State<PerfectModelDialog> createState() => _PerfectModelDialogState();
}

class _PerfectModelDialogState extends State<PerfectModelDialog> with TickerProviderStateMixin {
  late final AnimationController a1 = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
  late final AnimationController a2 = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100));
  late final AnimationController a3 = AnimationController(vsync: this, duration: const Duration(milliseconds: 1300));

  @override
  void initState() {
    super.initState();
    a1.forward();
    Future.delayed(const Duration(milliseconds: 150), () => a2.forward());
    Future.delayed(const Duration(milliseconds: 300), () => a3.forward());
  }

  @override
  void dispose() {
    a1.dispose();
    a2.dispose();
    a3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
          boxShadow: const [BoxShadow(color: Color(0x402C00FF), blurRadius: 24)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 6),
            _gaugeRow('Épargne', widget.saving, a1),
            const SizedBox(height: 12),
            _gaugeRow('Fixes', widget.fixed, a2),
            const SizedBox(height: 12),
            _gaugeRow('Dépenses personnelles', widget.personal, a3),
            const SizedBox(height: 10),
            Text('Modèle parfait – repères visuels (vert/orange/rouge)', style: TextStyle(color: Colors.white.withOpacity(0.9))),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B1CFB),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Fermer'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gaugeRow(String label, double value, AnimationController controller) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 110,
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, _) => CustomPaint(
                painter: GaugePainter(progress: controller.value * value),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 110,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('${(value*100).toStringAsFixed(0)} %', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}

class GaugePainter extends CustomPainter {
  final double progress; // 0..1
  GaugePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w/2, h*0.9);
    final radius = math.min(w/2, h*0.9);

    final arcRect = Rect.fromCircle(center: center, radius: radius-10);
    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..color = Colors.white.withOpacity(0.08);
    canvas.drawArc(arcRect, math.pi, math.pi, false, basePaint);

    void drawZone(Color c, double start, double sweep){
      final p = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 12
        ..color = c.withOpacity(0.7);
      canvas.drawArc(arcRect, math.pi + start, sweep, false, p);
    }
    drawZone(const Color(0xFF16E5D2), 0, math.pi*0.45); // green
    drawZone(const Color(0xFFFFA24D), math.pi*0.45, math.pi*0.35); // orange
    drawZone(const Color(0xFFFF4D6D), math.pi*0.80, math.pi*0.20); // red

    final angle = math.pi + (math.pi * progress.clamp(0,1));
    final needleLen = radius-22;
    final needlePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
    final tip = Offset(center.dx + needleLen*math.cos(angle), center.dy + needleLen*math.sin(angle));
    canvas.drawLine(center, tip, needlePaint);
    final hub = Paint()..color = const Color(0xFFE657C7);
    canvas.drawCircle(center, 5, hub);
  }

  @override
  bool shouldRepaint(covariant GaugePainter oldDelegate) => oldDelegate.progress != progress;
}
