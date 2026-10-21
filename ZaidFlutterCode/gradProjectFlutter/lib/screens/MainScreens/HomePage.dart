import 'package:flutter/material.dart';
import 'package:blood_bank/shared/styles/components.dart';
import 'package:blood_bank/shared/styles/constants.dart';
import 'package:blood_bank/shared/styles/responsive_methods.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blood_bank/models/visits.dart';
import 'package:blood_bank/shared/network/AuthService.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  final String fullName;
  final String bloodType;
  final double? bloodBalance;
  final String nationalNumber;
  final String phone;
  final String email;
  final VoidCallback? onEditPhoto;
  final VoidCallback? onEditNationalNumber;
  final VoidCallback? onEditPhone;
  final VoidCallback? onEditEmail;

  const HomePage({
    super.key,
    this.fullName = 'Full name',
    this.bloodType = '—',
    this.bloodBalance,
    this.nationalNumber = 'Not provided',
    this.phone = 'Not provided',
    this.email = 'Not provided',
    this.onEditPhoto,
    this.onEditNationalNumber,
    this.onEditPhone,
    this.onEditEmail,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String fullName;
  late String bloodType;
  late String phone;
  late String email;
  Uint8List? _photo;
  bool _isPickingPhoto = false;

  @override
  void initState() {
    super.initState();
    fullName = widget.fullName;
    bloodType = widget.bloodType;
    phone = widget.phone;
    email = widget.email;
  }

  Future<void> _editText({
    required String label,
    required String value,
    required ValueChanged<String> onSave,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String)? validate,
  }) async {
    var editedValue = value == 'Not provided' || value == 'Full name'
        ? ''
        : value;
    final formKey = GlobalKey<FormState>();
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Edit $label'),
        content: Form(
          key: formKey,
          child: TextFormField(
            initialValue: editedValue,
            onChanged: (value) => editedValue = value,
            autofocus: true,
            keyboardType: keyboardType,
            decoration: InputDecoration(labelText: label),
            validator: (value) {
              final text = value?.trim() ?? '';
              if (text.isEmpty) return '$label is required.';
              return validate?.call(text);
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(dialogContext).pop(editedValue.trim());
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (!mounted || result == null) return;
    setState(() => onSave(result));
  }

  Future<void> _editBloodType() async {
    const types = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('Edit Blood Type'),
        children: [
          for (final type in types)
            SimpleDialogOption(
              onPressed: () => Navigator.of(dialogContext).pop(type),
              child: Text(type),
            ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
    if (mounted && result != null) setState(() => bloodType = result);
  }

  Future<void> _editPhoto() async {
    setState(() => _isPickingPhoto = true);
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
        requestFullMetadata: false,
      );
      if (image == null) return;
      final bytes = await image.readAsBytes();
      // Validate the image before replacing the current avatar.
      final decoded = await decodeImageFromList(bytes);
      decoded.dispose();
      if (!mounted) return;
      setState(() => _photo = bytes);
      widget.onEditPhoto?.call();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to load the selected photo.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isPickingPhoto = false);
    }
  }

  Widget _accountRow({
    required String label,
    required String value,
    required IconData icon,
    VoidCallback? onEdit,
  }) {
    return ListTile(
      leading: Icon(icon, color: mainColor),
      title: Text(label, style: GoogleFonts.inter()),
      subtitle: Text(
        value,
        style: GoogleFonts.inter(fontWeight: FontWeight.bold),
      ),
      trailing: IconButton(
        tooltip: 'Edit $label',
        onPressed: onEdit,
        icon: const Icon(Icons.edit, color: mainColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: mainColor,
            foregroundColor: Colors.white,
            centerTitle: true,
            title: Text('Account Details', style: GoogleFonts.inter()),
            //leading: IconButton(onPressed: onPressed, icon: icon), EDIT NEEDED: add a 3-line icon to traverse other pages
            actions: [
              IconButton(
                onPressed: () {
                  context.push('/notification-screen');
                },
                icon: Icon(Icons.notifications),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 24 : context.resWidth(0.05),
                vertical: isWide ? 24 : context.resHeight(0.03),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isWide ? 800 : 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.white,
                              backgroundImage: _photo == null
                                  ? null
                                  : MemoryImage(_photo!),
                              child: _photo == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 70,
                                      color: mainColor,
                                    )
                                  : null,
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Material(
                                color: mainColor,
                                shape: const CircleBorder(),
                                clipBehavior: Clip.antiAlias,
                                child: IconButton(
                                  tooltip: 'Edit profile photo',
                                  onPressed: _isPickingPhoto
                                      ? null
                                      : _editPhoto,
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: isWide ? 16 : context.resHeight(0.02)),
                      Semantics(
                        button: true,
                        label: 'Edit Full Name',
                        child: InkWell(
                          onTap: () => _editText(
                            label: 'Full Name',
                            value: fullName,
                            onSave: (value) => fullName = value,
                          ),
                          child: Text(
                            fullName,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Semantics(
                          label: 'Edit Blood Type: $bloodType',
                          button: true,
                          onTap: _editBloodType,
                          excludeSemantics: true,
                          child: GestureDetector(
                            onTap: _editBloodType,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: mainColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                bloodType,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: isWide ? 24 : context.resHeight(0.03)),
                      DefaultCard(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text('Blood balance', style: GoogleFonts.inter()),
                              Text(
                                widget.bloodBalance?.toString() ?? '—',
                                style: GoogleFonts.inter(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: mainColor,
                                ),
                              ),
                              Text('Units', style: GoogleFonts.inter()),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: isWide ? 24 : context.resHeight(0.03)),
                      DefaultCard(
                        child: Column(
                          children: [
                            _accountRow(
                              label: 'National Number',
                              value: widget.nationalNumber,
                              icon: Icons.badge_outlined,
                            ),
                            const Divider(height: 1),
                            _accountRow(
                              label: 'Phone',
                              value: phone,
                              icon: Icons.phone_outlined,
                              onEdit: () => _editText(
                                label: 'Phone',
                                value: phone,
                                keyboardType: TextInputType.phone,
                                validate: (value) =>
                                    RegExp(
                                      r'^\+?[0-9\s()\-]{7,20}$',
                                    ).hasMatch(value)
                                    ? null
                                    : 'Enter a valid phone number.',
                                onSave: (value) {
                                  phone = value;
                                  widget.onEditPhone?.call();
                                },
                              ),
                            ),
                            const Divider(height: 1),
                            _accountRow(
                              label: 'Email',
                              value: email,
                              icon: Icons.email_outlined,
                              onEdit: () => _editText(
                                label: 'Email',
                                value: email,
                                keyboardType: TextInputType.emailAddress,
                                validate: (value) =>
                                    RegExp(
                                      r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                                    ).hasMatch(value)
                                    ? null
                                    : 'Enter a valid email address.',
                                onSave: (value) {
                                  email = value;
                                  widget.onEditEmail?.call();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: isWide ? 24 : context.resHeight(0.03)),
                      _DonationHistorySection(isWide: isWide),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DonationHistorySection extends StatefulWidget {
  final bool isWide;

  const _DonationHistorySection({required this.isWide});

  @override
  State<_DonationHistorySection> createState() =>
      _DonationHistorySectionState();
}

class _DonationHistorySectionState extends State<_DonationHistorySection> {
  late final Future<List<Visit>> history;
  String _selectedFilter = 'All';
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    history = AuthService().dummyFetchVisits();
  }

  Future<void> _downloadPdf() async {
    setState(() => _isExporting = true);
    try {
      final visits = await history;
      final donations = visits.where((visit) {
        final type = visit.visitType.trim().toLowerCase();
        return type == 'blood donation' || type == 'donation';
      }).toList()..sort((a, b) => b.visitDate.compareTo(a.visitDate));

      final document = pw.Document();
      document.addPage(
        pw.MultiPage(
          maxPages: 1000,
          build: (context) => [
            pw.Text(
              'Donation History',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 12),
            pw.TableHelper.fromTextArray(
              headers: ['Date', 'Location', 'Status', 'Units'],
              data: [
                for (final donation in donations)
                  [
                    DateFormat('dd/MM/yyyy').format(donation.visitDate),
                    donation.visitLocation ?? '-',
                    donation.visitStatus ?? '-',
                    donation.units?.toString() ?? '-',
                  ],
              ],
            ),
            if (donations.isEmpty) pw.Text('No donation history yet.'),
          ],
        ),
      );
      await Printing.sharePdf(
        bytes: await document.save(),
        filename: 'donation_history.pdf',
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to export donation history.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = widget.isWide;
    return DefaultCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Donation History',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final filter in ['All', 'Verified', 'Pending', 'Rejected'])
                  ChoiceChip(
                    label: Text(
                      filter,
                      style: GoogleFonts.inter(
                        color: _selectedFilter == filter
                            ? Colors.white
                            : mainColor,
                      ),
                    ),
                    selected: _selectedFilter == filter,
                    selectedColor: mainColor,
                    checkmarkColor: Colors.white,
                    onSelected: (_) {
                      setState(() => _selectedFilter = filter);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<Visit>>(
              future: history,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: mainColor),
                  );
                }
                if (snapshot.hasError) {
                  return Text(
                    'Unable to load donation history.',
                    style: GoogleFonts.inter(),
                  );
                }

                final donations = (snapshot.data ?? <Visit>[]).where((visit) {
                  final type = visit.visitType.trim().toLowerCase();
                  final status = visit.visitStatus?.trim().toLowerCase();
                  return (type == 'blood donation' || type == 'donation') &&
                      (_selectedFilter == 'All' ||
                          status == _selectedFilter.toLowerCase());
                }).toList()..sort((a, b) => b.visitDate.compareTo(a.visitDate));

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final textScale =
                            MediaQuery.textScalerOf(context).scale(14) / 14;
                        final tableWidth = constraints.maxWidth.clamp(
                          520 * textScale,
                          double.infinity,
                        );
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: isWide ? tableWidth : null,
                            child: DataTable(
                              horizontalMargin: isWide ? 12 : null,
                              columnSpacing: isWide ? 16 : null,
                              headingRowHeight: isWide ? 48 : null,
                              dataRowMinHeight: isWide ? 56 : null,
                              dataRowMaxHeight: isWide ? double.infinity : null,
                              headingTextStyle: GoogleFonts.inter(
                                fontSize: isWide ? 14 : null,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              dataTextStyle: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: isWide ? 14 : null,
                              ),
                              columns: [
                                DataColumn(
                                  label: const Text('Date'),
                                  columnWidth: isWide
                                      ? FixedColumnWidth(128 * textScale)
                                      : null,
                                ),
                                DataColumn(
                                  label: const Text('Location'),
                                  columnWidth: isWide
                                      ? const FlexColumnWidth()
                                      : null,
                                ),
                                DataColumn(
                                  label: const Text('Status'),
                                  columnWidth: isWide
                                      ? FixedColumnWidth(128 * textScale)
                                      : null,
                                ),
                                DataColumn(
                                  label: const Text('Units'),
                                  numeric: true,
                                  columnWidth: isWide
                                      ? FixedColumnWidth(80 * textScale)
                                      : null,
                                ),
                              ],
                              rows: [
                                for (final donation in donations)
                                  DataRow(
                                    cells: [
                                      DataCell(
                                        Text(
                                          DateFormat(
                                            'dd/MM/yyyy',
                                          ).format(donation.visitDate),
                                          softWrap: isWide ? false : null,
                                        ),
                                      ),
                                      DataCell(
                                        Padding(
                                          padding: isWide
                                              ? const EdgeInsets.symmetric(
                                                  vertical: 12,
                                                )
                                              : EdgeInsets.zero,
                                          child: Text(
                                            donation.visitLocation ?? '—',
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Padding(
                                          padding: isWide
                                              ? const EdgeInsets.symmetric(
                                                  vertical: 12,
                                                )
                                              : EdgeInsets.zero,
                                          child: Text(
                                            donation.visitStatus ?? '—',
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          donation.units?.toString() ?? '—',
                                          softWrap: isWide ? false : null,
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
                    if (donations.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          _selectedFilter == 'All'
                              ? 'No donation history yet.'
                              : 'No ${_selectedFilter.toLowerCase()} donations.',
                          style: GoogleFonts.inter(),
                        ),
                      ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: _isExporting ? null : _downloadPdf,
                      style: TextButton.styleFrom(foregroundColor: mainColor),
                      icon: const Icon(Icons.download),
                      label: Text('Download PDF', style: GoogleFonts.inter()),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
