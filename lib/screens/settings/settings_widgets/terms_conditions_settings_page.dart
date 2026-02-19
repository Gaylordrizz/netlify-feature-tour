import 'package:flutter/material.dart';

class TermsConditionsSettingsPage extends StatelessWidget {
  const TermsConditionsSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: null, // No tooltip
        ),
        title: const Text('Terms & Conditions'),
        centerTitle: true,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFB6D5), // Lighter Pink
                Color(0xFFFFD700), // Gold
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Storazaar – Terms and Conditions',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Last Updated: February 2, 2026',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 32),

                  _buildSection(
                    title: '1. Acceptance of Terms',
                    content:
                        'By accessing or using Storazaar, you confirm that you have read, understood, and agreed to these Terms, as well as our Privacy Policy and any additional policies or guidelines referenced herein. These Terms apply to all users, including visitors, registered users, and store owners.',
                  ),
                  _buildSection(
                    title: '2. Eligibility',
                    content:
                        'You must be at least 18 years old (or the age of majority in your jurisdiction) to use Storazaar. By using the Service, you represent and warrant that you meet this requirement and have the legal capacity to enter into this agreement.',
                  ),
                  _buildSection(
                    title: '3. Use License and Restrictions',
                    content:
                        'Storazaar grants you a limited, non-exclusive, non-transferable, revocable license to access and use the Service for personal or internal business purposes, subject to these Terms.\n\nYou agree not to:\n\nCopy, modify, distribute, or create derivative works of any part of the Service\nUse the Service for unlawful, fraudulent, or unauthorized commercial purposes\nReverse engineer, decompile, or attempt to extract source code\nInterfere with or disrupt the security or performance of the Service\nRemove or alter copyright, trademark, or proprietary notices\n\nAll rights not expressly granted are reserved by Storazaar.',
                  ),
                  _buildSection(
                    title: '4. Account Registration and Security',
                    content:
                        'To access certain features, you may be required to create an account. You agree to:\n\nProvide accurate, current, and complete information\nKeep your login credentials secure and confidential\nPromptly update your information if it changes\nAccept responsibility for all activity conducted under your account\n\nStorazaar is not responsible for losses resulting from unauthorized account access due to your failure to safeguard credentials.',
                  ),
                  _buildSection(
                    title: '5. Store Creation and Management',
                    content:
                        'Users who create stores on Storazaar (“Store Owners”) agree to:\n\nOperate their store in compliance with all applicable laws and regulations\nProvide truthful product, pricing, and business information\nFulfill customer orders accurately and in good faith\nAvoid deceptive, misleading, or fraudulent practices\nHandle customer data responsibly and lawfully\n\nStorazaar does not guarantee sales, traffic, or business success and is not responsible for disputes between Store Owners and customers.\n\nStat box and line chart data in the store dashboard only represent stats within Storazaar, please see your online store\'s analytics for a more comprehensive analysis.',
                  ),
                  _buildSection(
                    title: '6. Content and User Submissions',
                    content:
                        'You are solely responsible for any content you upload, post, or display on Storazaar, including product listings, messages, images, and store descriptions.\n\nStore Owner Consent & Public Information Notice\nBy submitting an application to Storazaar, you confirm that you are the owner or authorized representative of the store and that you consent to Storazaar using, displaying, hosting, and publishing the information you provide for the purpose of operating, promoting, and managing your store on the Storazaar platform.\nYou grant Storazaar permission to use the following information associated with your store and products:\n\nStore domain\nStore name\nStore heading and subheading\nStore category and description\nStore address and postal code\nProduct titles\nProduct prices\nProduct descriptions\nProduct condition\nShipping information and shipping time\nPhotos and other media\nSocial media links\nContact details, including name, email address, and phone number\n\nYou acknowledge and agree that any information submitted through the Storazaar application form may be publicly visible on the Storazaar platform or related marketing channels.\nOptional Information\nProviding the following details is optional. If submitted, you agree that they may also be made public:\nSocial media links\nEmail address\nPhysical address\nPostal code\nPhone number\nYou confirm that all information provided is accurate, that you have the rights to share it, and that Storazaar may use it as described above for as long as your store or products are listed on the platform.\nAll content must:\nBe accurate and not misleading\nRespect intellectual property rights\nAvoid offensive, abusive, or inappropriate material\nComply with applicable local and international laws\n\nStorazaar reserves the right to remove or restrict content that violates these Terms or our policies.',
                  ),
                  _buildSection(
                    title: '7. Payments, Fees, and Billing',
                    content:
                        'Storazaar may charge fees for certain features or services. By using paid services, you agree to:\n\nPay all applicable fees and taxes\nProvide valid and accurate payment information\nAuthorize Storazaar or its payment processors to charge your payment method\n\nUnless otherwise stated or required by law, fees are non-refundable. Storazaar may modify pricing with reasonable notice.',
                  ),
                  _buildSection(
                    title: '8. Privacy and Data Protection',
                    content:
                        'Your privacy matters to us. Our Privacy Policy explains how we collect, use, store, and protect your personal information. By using Storazaar, you consent to our data practices as described in the Privacy Policy.',
                  ),
                  _buildSection(
                    title: '9. Third-Party Services',
                    content:
                        'Storazaar may integrate or link to third-party services (e.g., payment processors, analytics tools). We do not control and are not responsible for third-party content, services, or policies. Your use of third-party services is at your own risk and subject to their terms.',
                  ),
                  _buildSection(
                    title: '10. Termination and Suspension',
                    content:
                        'Storazaar reserves the right to suspend or terminate your account or access to the Service at any time, with or without notice, if:\n\nYou violate these Terms or related policies\nYour conduct is harmful to other users, third parties, or Storazaar\nRequired by law or regulatory authorities\n\nUpon termination, your right to use the Service will immediately cease.',
                  ),
                  _buildSection(
                    title: '11. Disclaimer of Warranties',
                    content:
                        'Storazaar is provided “as is” and “as available.” We make no warranties, express or implied, including but not limited to warranties of merchantability, fitness for a particular purpose, or uninterrupted availability.',
                  ),
                  _buildSection(
                    title: '12. Limitation of Liability',
                    content:
                        'To the fullest extent permitted by law, Storazaar shall not be liable for any indirect, incidental, special, consequential, or punitive damages, including loss of profits, data, or business opportunities, arising from your use of or inability to use the Service.',
                  ),
                  _buildSection(
                    title: '13. Indemnification',
                    content:
                        'You agree to indemnify and hold harmless Storazaar, its affiliates, officers, employees, and partners from any claims, damages, liabilities, or expenses arising out of your use of the Service or violation of these Terms.',
                  ),
                  _buildSection(
                    title: '14. Changes to These Terms',
                    content:
                        'We may update these Terms from time to time. Material changes will be communicated through the Service or other reasonable means. Continued use of Storazaar after changes take effect constitutes acceptance of the updated Terms.',
                  ),
                  _buildSection(
                    title: '15. Governing Law',
                    content:
                        'These Terms shall be governed by and construed in accordance with the laws of Province of British Columbia and the federal laws of Canada applicable therein, without regard to conflict of law principles.',
                  ),
                  _buildSection(
                    title: '16. Community Guidelines (Chat Rooms & Community Features)',
                    content:
                        'By creating or participating in Storazaar community spaces, you agree to:\n\nBe respectful and professional\nKeep discussions business-focused\nAvoid harassment, hate, or discrimination\nRefrain from prohibited content (weapons, drugs, pornography, sexual content, violence, racism)\nNot scam or spam any other user of Storazaar\nRespect privacy and confidentiality\nReport inappropriate behavior\n\nViolations may result in content removal, suspension, or termination.',
                  ),
                  _buildSection(
                    title: '17. Contact Information',
                    content:
                        'For questions about these Terms, please contact us:\n\nEmail: storazaar@gmail.com',
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    }
  }
  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }