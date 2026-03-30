import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../theme/profile_palette.dart';
import '../../utils/display_name.dart';
import '../../widgets/top_alert.dart';

/// Kişisel bilgiler — ad soyad düzenleme (Firebase Auth + Firestore).
class ProfilePersonalInfoPage extends StatefulWidget {
  const ProfilePersonalInfoPage({super.key});

  @override
  State<ProfilePersonalInfoPage> createState() => _ProfilePersonalInfoPageState();
}

class _ProfilePersonalInfoPageState extends State<ProfilePersonalInfoPage> {
  final _authService = AuthService();
  final _nameController = TextEditingController();
  bool _loading = true;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadInitial() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    var text = user.displayName?.trim();
    if (text == null || text.isEmpty) {
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        final fs = doc.data()?['displayName'] as String?;
        if (fs != null && fs.trim().isNotEmpty) {
          text = fs.trim();
        }
      } catch (_) {}
    }
    text ??= displayNameFromUser(user);
    if (mounted) {
      _nameController.text = text;
      setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      TopAlert.show(context, message: 'Ad soyad boş olamaz.', type: TopAlertType.warning);
      return;
    }
    setState(() => _saving = true);
    try {
      await _authService.updateDisplayName(name);
      if (!mounted) return;
      TopAlert.show(context, message: 'Bilgileriniz güncellendi.', type: TopAlertType.success);
      Navigator.of(context).pop(true);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      TopAlert.show(context, message: _mapError(e), type: TopAlertType.error);
    } catch (_) {
      if (!mounted) return;
      TopAlert.show(context, message: 'Kaydedilemedi. Tekrar deneyin.', type: TopAlertType.error);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _mapError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-display-name':
        return 'Geçerli bir ad soyad girin.';
      default:
        return 'Güncelleme başarısız: ${e.message ?? e.code}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = ProfilePalette.of(context);

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: p.bg,
        foregroundColor: p.textPrimary,
        elevation: 0,
        title: Text(
          'Kişisel Bilgiler',
          style: ProfileTypography.jakarta(p, 18, FontWeight.w700, height: 24),
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: p.iconAccent2))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Profilinde görünecek adını ve soyadını düzenleyebilirsin.',
                    style: ProfileTypography.manrope(14, FontWeight.w500, p.textMuted, height: 20),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: p.surface,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: p.isDark ? 0.05 : 0.06),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      child: TextField(
                        controller: _nameController,
                        style: ProfileTypography.manrope(16, FontWeight.w600, p.textPrimary, height: 22),
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: 'Ad Soyad',
                          labelStyle: ProfileTypography.manrope(14, FontWeight.w500, p.textMuted, height: 20),
                          border: InputBorder.none,
                          filled: false,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  FilledButton(
                    onPressed: _saving ? null : _save,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0D6EFD),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                    ),
                    child: _saving
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Text(
                            'Kaydet',
                            style: ProfileTypography.manrope(16, FontWeight.w700, Colors.white, height: 22),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
