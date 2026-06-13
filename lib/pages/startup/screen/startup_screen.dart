import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:exchange_customer/core/constants/colors.dart';
import 'package:exchange_customer/core/constants/images.dart';
import 'package:exchange_customer/pages/startup/cubit/startup_cubit.dart';
import 'package:exchange_customer/pages/startup/cubit/startup_state.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen>
    with TickerProviderStateMixin {
  // Logo
  late AnimationController _logoController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;

  // Rings
  late AnimationController _ringController;
  late Animation<double> _ring1;
  late Animation<double> _ring2;
  late Animation<double> _ring3;

  // Text
  late AnimationController _textController;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;

  // Loading dots
  late AnimationController _dotsController;

  // Particles
  late AnimationController _particlesController;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startSequence();
    context.read<StartupCubit>().isLogin();
  }

  void _initAnimations() {
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ).drive(Tween(begin: 0.0, end: 1.0));
    _logoOpacity = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeIn,
    ).drive(Tween(begin: 0.0, end: 1.0));

    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _ring1 = CurvedAnimation(
      parent: _ringController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));
    _ring2 = CurvedAnimation(
      parent: _ringController,
      curve: const Interval(0.15, 0.85, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));
    _ring3 = CurvedAnimation(
      parent: _ringController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ).drive(Tween(begin: 0.0, end: 1.0));

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _textOpacity = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ).drive(Tween(begin: 0.0, end: 1.0));
    _textSlide = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ).drive(Tween(begin: const Offset(0, 0.4), end: Offset.zero));

    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _particlesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _logoController.forward();
    _ringController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _textController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _ringController.dispose();
    _textController.dispose();
    _dotsController.dispose();
    _particlesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StartupCubit, StartupState<StartupDestination>>(
      listener: (context, state) {
        state.whenOrNull(
          success: (destination) {
            switch (destination) {
              case StartupDestination.home:
                context.go('/home');
              case StartupDestination.signin:
                context.go('/signin');
              case StartupDestination.onboarding:
                context.go('/onboarding');
            }
          },
        );
      },
      child: Scaffold(
        body: Stack(
          children: [
            _buildBackground(),
            _buildParticles(),
            _buildContent(),
            _buildBottomInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF022C22),
                  const Color(0xFF064E3B),
                  const Color(0xFF065F46),
                ]
              : [
                  const Color(0xFF047857),
                  const Color(0xFF059669),
                  const Color(0xFF10B981),
                ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  Widget _buildParticles() {
    return AnimatedBuilder(
      animation: _particlesController,
      builder: (context, _) {
        return CustomPaint(
          painter: _ParticlesPainter(_particlesController.value),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLogoSection(),
          const SizedBox(height: 40),
          _buildTextSection(),
          const SizedBox(height: 60),
          _buildLoadingDots(),
        ],
      ),
    );
  }

  Widget _buildLogoSection() {
    return AnimatedBuilder(
      animation: _ringController,
      builder: (context, child) {
        return SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Ring 3 (outermost)
              _buildRing(180, _ring3, 0.05),
              // Ring 2
              _buildRing(148, _ring2, 0.10),
              // Ring 1
              _buildRing(118, _ring1, 0.18),
              // Logo
              child!,
            ],
          ),
        );
      },
      child: AnimatedBuilder(
        animation: _logoController,
        builder: (context, child) {
          return Transform.scale(
            scale: _logoScale.value,
            child: Opacity(
              opacity: _logoOpacity.value.clamp(0.0, 1.0),
              child: child,
            ),
          );
        },
        child: Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.kThirtColor.withOpacity(0.6),
                blurRadius: 30,
                spreadRadius: 8,
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.15),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipOval(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Image.asset(
                AppImages.klogo,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.currency_exchange_rounded,
                  size: 48,
                  color: AppColors.kPrimaryColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRing(double size, Animation<double> animation, double opacity) {
    return Container(
      width: size * animation.value,
      height: size * animation.value,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(
            opacity * (1 - animation.value * 0.5),
          ),
          width: 1.5,
        ),
      ),
    );
  }

  Widget _buildTextSection() {
    return SlideTransition(
      position: _textSlide,
      child: FadeTransition(
        opacity: _textOpacity,
        child: Column(
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Colors.white, Color(0xFFA7F3D0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: const Text(
                'ExChange',
                style: TextStyle(
                  fontFamily: 'Cairo-Bold',
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 1.5,
                  height: 1.1,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: const Text(
                'نظام إدارة الصرافة والعملات',
                style: TextStyle(
                  fontFamily: 'Cairo-Bold',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingDots() {
    return FadeTransition(
      opacity: _textOpacity,
      child: AnimatedBuilder(
        animation: _dotsController,
        builder: (context, _) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (i) {
              final delay = i / 3;
              final t = (_dotsController.value - delay).clamp(0.0, 1.0);
              final scale = 0.5 + 0.5 * math.sin(t * math.pi * 2);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4 + 0.6 * scale),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildBottomInfo() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: _textOpacity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 30, height: 1, color: Colors.white24),
                const SizedBox(width: 10),
                const Text(
                  'خدمات الصرف المالي الآمنة',
                  style: TextStyle(
                    fontFamily: 'Cairo-Bold',
                    fontSize: 12,
                    color: Colors.white38,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 10),
                Container(width: 30, height: 1, color: Colors.white24),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'v1.0.0',
              style: TextStyle(
                fontFamily: 'Cairo-Bold',
                fontSize: 11,
                color: Colors.white24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Particles Painter ───────────────────────────────────────────────────────

class _ParticlesPainter extends CustomPainter {
  final double progress;

  static final List<_Particle> _particles = List.generate(18, (i) {
    final rng = math.Random(i * 37 + 13);
    return _Particle(
      x: rng.nextDouble(),
      y: rng.nextDouble(),
      radius: 1.5 + rng.nextDouble() * 2.5,
      speed: 0.03 + rng.nextDouble() * 0.06,
      phase: rng.nextDouble(),
      drift: (rng.nextDouble() - 0.5) * 0.02,
    );
  });

  _ParticlesPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in _particles) {
      final yPos = ((p.y + progress * p.speed) % 1.0);
      final xPos = p.x + math.sin(progress * math.pi * 2 + p.phase) * p.drift;
      final opacity =
          0.1 + 0.2 * math.sin((progress + p.phase) * math.pi * 2).abs();

      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(
        Offset(xPos * size.width, yPos * size.height),
        p.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlesPainter old) => old.progress != progress;
}

class _Particle {
  final double x;
  final double y;
  final double radius;
  final double speed;
  final double phase;
  final double drift;

  const _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.phase,
    required this.drift,
  });
}
