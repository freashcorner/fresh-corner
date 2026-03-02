import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart' as app_auth;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _phoneCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final List<TextEditingController> _otpCtrls =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
      List.generate(6, (_) => FocusNode());

  String _step = 'phone';
  bool _loading = false;
  ConfirmationResult? _confirmationResult;

  late AnimationController _slideCtrl;
  late Animation<Offset> _slideAnim;

  static const _green = Color(0xFF2ECC71);
  static const _darkGreen = Color(0xFF1A4731);

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut));
    _slideCtrl.forward();
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _nameCtrl.dispose();
    for (final c in _otpCtrls) c.dispose();
    for (final f in _otpFocusNodes) f.dispose();
    _slideCtrl.dispose();
    super.dispose();
  }

  void _goStep(String step) {
    _slideCtrl.reset();
    setState(() => _step = step);
    _slideCtrl.forward();
  }

  Future<void> _sendOTP() async {
    final phone = _phoneCtrl.text.trim();
    if (phone.isEmpty) { _showSnack('মোবাইল নম্বর দিন'); return; }
    setState(() => _loading = true);
    try {
      final formatted = phone.startsWith('+') ? phone : '+88$phone';
      _confirmationResult = await FirebaseAuth.instance.signInWithPhoneNumber(formatted);
      _goStep('otp');
    } catch (e) {
      _showSnack('OTP পাঠানো যায়নি। আবার চেষ্টা করুন।');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _verifyOTP() async {
    final code = _otpCtrls.map((c) => c.text).join();
    if (code.length < 6) { _showSnack('৬ সংখ্যার OTP দিন'); return; }
    setState(() => _loading = true);
    try {
      await _confirmationResult!.confirm(code);
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      final appUser = context.read<app_auth.AuthProvider>().appUser;
      if (appUser != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _goStep('register');
      }
    } catch (_) {
      _showSnack('OTP ভুল। আবার চেষ্টা করুন।');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _register() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) { _showSnack('আপনার নাম দিন'); return; }
    setState(() => _loading = true);
    try {
      await context.read<app_auth.AuthProvider>().register(name, _phoneCtrl.text.trim());
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } catch (_) {
      _showSnack('নিবন্ধন ব্যর্থ হয়েছে');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Green gradient top
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_darkGreen, _green],
              ),
            ),
          ),
          // Top content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SvgPicture.asset('assets/images/icon.svg', width: 48, height: 48),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'ফ্রেশ কর্নার',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'তাজা বাজার, দোরগোড়ায় ডেলিভারি',
                    style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.75)),
                  ),
                ],
              ),
            ),
          ),
          // Bottom sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: _slideAnim,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 24, offset: Offset(0, -4))],
                ),
                padding: EdgeInsets.fromLTRB(
                  24, 28, 24,
                  MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: _buildStepContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_step) {
      case 'otp':
        return _buildOtpStep();
      case 'register':
        return _buildRegisterStep();
      default:
        return _buildPhoneStep();
    }
  }

  Widget _buildPhoneStep() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('লগইন করুন', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A2332))),
        const SizedBox(height: 4),
        const Text('আপনার মোবাইল নম্বর দিন', style: TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 24),
        TextField(
          controller: _phoneCtrl,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: 'মোবাইল নম্বর',
            hintText: '01XXXXXXXXX',
            prefixText: '+88 ',
            prefixStyle: TextStyle(color: Color(0xFF1A2332), fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _loading ? null : _sendOTP,
            child: _loading
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('OTP পাঠান'),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            'লগইন করে আপনি আমাদের সেবার শর্তাবলী মেনে নিচ্ছেন',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpStep() {
    final phone = _phoneCtrl.text.trim();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => _goStep('phone'),
              child: Container(
                width: 32, height: 32,
                decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(9)),
                child: const Icon(Icons.arrow_back_ios_new, size: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('OTP যাচাই', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A2332))),
        const SizedBox(height: 4),
        Text(
          '+88 $phone নম্বরে OTP পাঠানো হয়েছে',
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(height: 28),
        // 6 OTP boxes
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (i) => _otpBox(i)),
        ),
        const SizedBox(height: 16),
        Center(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              children: [
                const TextSpan(text: 'OTP আসেনি? '),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: _loading ? null : _sendOTP,
                    child: const Text('আবার পাঠান', style: TextStyle(color: Color(0xFF2ECC71), fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _loading ? null : _verifyOTP,
            child: _loading
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('যাচাই করুন'),
          ),
        ),
      ],
    );
  }

  Widget _otpBox(int index) {
    final ctrl = _otpCtrls[index];
    final focus = _otpFocusNodes[index];
    return SizedBox(
      width: 44,
      child: TextField(
        controller: ctrl,
        focusNode: focus,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2ECC71)),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2ECC71), width: 2),
          ),
          filled: ctrl.text.isNotEmpty,
          fillColor: ctrl.text.isNotEmpty ? const Color(0xFFE8F5E9) : null,
        ),
        onChanged: (val) {
          if (val.isNotEmpty && index < 5) {
            _otpFocusNodes[index + 1].requestFocus();
          } else if (val.isEmpty && index > 0) {
            _otpFocusNodes[index - 1].requestFocus();
          }
          setState(() {});
        },
      ),
    );
  }

  Widget _buildRegisterStep() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('নিবন্ধন করুন', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A2332))),
        const SizedBox(height: 4),
        const Text('আপনার নাম দিয়ে একাউন্ট তৈরি করুন', style: TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 24),
        TextField(
          controller: _nameCtrl,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'আপনার নাম',
            prefixIcon: Icon(Icons.person_outline),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _loading ? null : _register,
            child: _loading
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('শুরু করুন'),
          ),
        ),
      ],
    );
  }
}
