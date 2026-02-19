import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
	const PrivacyPolicyPage({Key? key}) : super(key: key);

	TextSpan _sectionTitle(String text) => TextSpan(
				text: '\n$text\n',
				style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
			);

	TextSpan _sectionBody(String text) => TextSpan(
				text: '$text\n\n',
				style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black),
			);

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: PreferredSize(
				preferredSize: const Size.fromHeight(kToolbarHeight),
				child: AppBar(
					elevation: 1,
					centerTitle: true,
					flexibleSpace: Container(
						decoration: const BoxDecoration(
							gradient: LinearGradient(
								colors: [Color(0xFFFFB6D5), Color(0xFFFFD700)], // Brighter pink
								begin: Alignment.topLeft,
								end: Alignment.bottomRight,
							),
						),
					),
					title: const Text(
						'Privacy Policy',
						style: TextStyle(
							fontWeight: FontWeight.bold,
							fontSize: 20,
						),
					),
					foregroundColor: Colors.black,
					backgroundColor: Colors.transparent,
				),
			),
			backgroundColor: Colors.white,
			body: SingleChildScrollView(
				padding: const EdgeInsets.all(20),
				child: Center(
					child: Container(
						constraints: const BoxConstraints(maxWidth: 700),
						child: RichText(
							text: TextSpan(
								style: const TextStyle(fontFamily: 'Roboto', color: Colors.black),
								children: [
									_sectionTitle('Storazaar – Privacy Policy'),
									_sectionBody('Last Updated: February 2, 2026\n'),
									_sectionBody('Storazaar (“Storazaar,” “we,” “us,” or “our”) respects your privacy and is committed to protecting your personal information. This Privacy Policy explains how we collect, use, store, disclose, and protect information when you access or use Storazaar, including our website, applications, tools, and services (collectively, the “Service”).\n'),
									_sectionBody('By using Storazaar, you consent to the data practices described in this Privacy Policy. This policy is designed to comply with Canada’s PIPEDA (Personal Information Protection and Electronic Documents Act) and applicable privacy laws.\n'),
									_sectionTitle('1. Information We Collect'),
									_sectionBody('We collect information in the following ways:\n'),
									_sectionTitle('a. Information You Provide Directly'),
									_sectionBody('When you create an account, open a store, or interact with the Service, we may collect:\n- Name, username, or business name\n- Email address\n- Account login credentials\n- Store details, product listings, descriptions, images, and pricing\n- Messages or communications sent through the platform\n- Payment-related information (processed by third-party payment providers)\n'),
									_sectionTitle('b. Automatically Collected Information'),
									_sectionBody('When you use Storazaar, we may automatically collect:\n- IP address\n- Device type, browser type, and operating system\n- Usage data, pages viewed, actions taken, and timestamps\n- Cookies or similar tracking technologies\n'),
									_sectionTitle('c. Information from Third Parties'),
									_sectionBody('We may receive information from third-party services such as:\n- Payment processors\n- Analytics providers\n- Authentication or security services\nStorazaar does not control the data practices of third parties.\n'),
									_sectionTitle('2. How We Use Your Information'),
									_sectionBody('We use collected information to:\n- Provide, operate, and maintain the Service\n- Create and manage user accounts and stores\n- Process payments and transactions\n- Communicate with users regarding accounts, updates, or support\n- Improve functionality, performance, and user experience\n- Detect, prevent, and address fraud, abuse, or security issues\n- Comply with legal obligations\n'),
									_sectionTitle('Important Privacy Commitment'),
									_sectionBody('Storazaar will never sell, rent, trade, or give away your personal information.\nWe may use aggregated, anonymized, and non-identifiable data to analyze platform usage and improve Storazaar. Only this type of data may be shared with trusted third parties, solely for user experience, analytics, or platform improvement purposes.\nThis use and disclosure of personal information aligns with PIPEDA principles, including limiting collection, use, and disclosure to necessary purposes.\n'),
									_sectionTitle('3. Cookies and Tracking Technologies'),
									_sectionBody('Storazaar uses cookies and similar technologies to:\n- Enable essential platform functionality\n- Remember user preferences\n- Analyze usage patterns and improve the Service\nYou may disable cookies through your browser settings, but some features may not function properly.\n'),
									_sectionTitle('4. How We Share Information'),
									_sectionBody('We may share information only in the following limited circumstances:\n- With service providers who help operate Storazaar (e.g., hosting, payment processing, security, analytics)\n- With other users, when necessary for transactions (e.g., store and customer interactions)\n- For legal reasons, if required by law, court order, or governmental request\n- To protect rights and safety, including enforcement of our Terms and Conditions\nPersonal information is never sold or shared for advertising resale purposes.\nAny data shared for analytics or improvement purposes is aggregated and anonymized, and cannot be used to identify individual users.\n'),
									_sectionTitle('5. Store Owners & Customer Data'),
									_sectionBody('Store Owners are responsible for handling customer data lawfully and ethically.\nStorazaar:\n- Does not own customer–store relationships\n- Is not responsible for Store Owner misuse of customer data\n- Requires Store Owners to comply with applicable privacy and data protection laws, including PIPEDA\n'),
									_sectionTitle('6. Data Security'),
									_sectionBody('We take reasonable administrative, technical, and organizational measures to protect your information. However, no system is 100% secure, and we cannot guarantee absolute security.\nYou are responsible for keeping your login credentials confidential.\n'),
									_sectionTitle('7. Data Retention'),
									_sectionBody('We retain personal information only as long as necessary to:\n- Provide the Service\n- Comply with legal obligations\n- Resolve disputes\n- Enforce agreements\nYou may request deletion of your account, subject to legal or operational requirements.\n'),
									_sectionTitle('8. Your Rights and Choices'),
									_sectionBody('Depending on your jurisdiction, you may have the right to:\n- Access your personal information\n- Correct inaccurate data\n- Request deletion of your data\n- Withdraw consent where applicable\nThese rights reflect PIPEDA’s principles of openness, access, and accountability. Requests can be made by contacting us at the email below.\n'),
									_sectionTitle('9. Third-Party Services and Links'),
									_sectionBody('Storazaar may contain links to or integrations with third-party services. We are not responsible for their privacy practices, content, or policies. Use of third-party services is at your own risk.\n'),
									_sectionTitle('10. Children’s Privacy'),
									_sectionBody('Storazaar is not intended for individuals under the age of 18. We do not knowingly collect personal information from minors.\n'),
									_sectionTitle('11. International Users'),
									_sectionBody('Storazaar is operated from Canada. If you access the Service from outside Canada, you acknowledge that your information may be transferred to and processed in Canada or other jurisdictions.\n'),
									_sectionTitle('12. Changes to This Privacy Policy'),
									_sectionBody('We may update this Privacy Policy from time to time. Material changes will be communicated through the Service or other reasonable means. Continued use of Storazaar after changes take effect constitutes acceptance of the updated policy.\n'),
									_sectionTitle('13. Contact Us'),
									_sectionBody('If you have questions or concerns about this Privacy Policy, please contact us:\nEmail: storazaar@gmail.com\n'),
								],
							),
						),
					),
				),
			),
		);
	}
}
