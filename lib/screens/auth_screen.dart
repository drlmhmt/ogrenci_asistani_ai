import 'package:flutter/material.dart';

import 'onboarding_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onAuthSuccess() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              'Öğrenci Asistanı',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Hesabına giriş yap veya yeni hesap oluştur',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: const Color(0xFF3B82F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Giriş Yap'),
                  Tab(text: 'Kayıt Ol'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _LoginTab(
                    formKey: _loginFormKey,
                    onSuccess: _onAuthSuccess,
                  ),
                  _RegisterTab(
                    formKey: _registerFormKey,
                    onSuccess: _onAuthSuccess,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginTab extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final VoidCallback onSuccess;

  const _LoginTab({
    required this.formKey,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            _AuthTextField(
              label: 'E-posta',
              hint: 'ornek@email.com',
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) return 'E-posta gerekli';
                if (!v.contains('@')) return 'Geçerli e-posta girin';
                return null;
              },
            ),
            const SizedBox(height: 16),
            _AuthTextField(
              label: 'Şifre',
              hint: '••••••••',
              obscureText: true,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Şifre gerekli';
                if (v.length < 6) return 'En az 6 karakter';
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    onSuccess();
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Giriş Yap'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RegisterTab extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final VoidCallback onSuccess;

  const _RegisterTab({
    required this.formKey,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            _AuthTextField(
              label: 'Ad Soyad',
              hint: 'Adınızı girin',
              validator: (v) {
                if (v == null || v.isEmpty) return 'Ad soyad gerekli';
                return null;
              },
            ),
            const SizedBox(height: 16),
            _AuthTextField(
              label: 'E-posta',
              hint: 'ornek@email.com',
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) return 'E-posta gerekli';
                if (!v.contains('@')) return 'Geçerli e-posta girin';
                return null;
              },
            ),
            const SizedBox(height: 16),
            _AuthTextField(
              label: 'Şifre',
              hint: 'En az 6 karakter',
              obscureText: true,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Şifre gerekli';
                if (v.length < 6) return 'En az 6 karakter';
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    onSuccess();
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Kayıt Ol'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthTextField extends StatefulWidget {
  final String label;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _AuthTextField({
    required this.label,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
  });

  @override
  State<_AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<_AuthTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final obscure = widget.obscureText ? _obscure : false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          obscureText: obscure,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
            filled: true,
            fillColor: const Color(0xFF1E293B),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white54,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
