import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/flow_iq_sync_service.dart';
import '../services/enhanced_auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FlowIQSyncService _syncService = FlowIQSyncService();
  bool _isFlowIQConnected = false;
  bool _notificationsEnabled = true;
  bool _dataSharingEnabled = true;
  bool _analyticsEnabled = true;
  String _selectedLanguage = 'English';
  String _selectedTheme = 'System';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final isConnected = await _syncService.isConnectedToFlowIQ();
    setState(() {
      _isFlowIQConnected = isConnected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        children: [
          // Flow Ai Integration Section
          _buildSectionHeader('Flow Ai Integration'),
          _buildFlowIQConnectionCard(),
          
          // App Preferences
          _buildSectionHeader('Preferences'),
          _buildPreferencesSection(),
          
          // Privacy & Security
          _buildSectionHeader('Privacy & Security'),
          _buildPrivacySection(),
          
          // About
          _buildSectionHeader('About'),
          _buildAboutSection(),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildFlowIQConnectionCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _isFlowIQConnected ? Colors.green[100] : Colors.orange[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _isFlowIQConnected ? Icons.sync : Icons.sync_disabled,
                    color: _isFlowIQConnected ? Colors.green[600] : Colors.orange[600],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isFlowIQConnected ? 'Connected to Flow Ai' : 'Not Connected',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        _isFlowIQConnected
                            ? 'Your data is syncing with the consumer app'
                            : 'Connect to share data with the Flow Ai consumer app',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            if (_isFlowIQConnected) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              
              // Sync status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Last Sync',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        _syncService.lastSyncTime != null
                            ? _formatSyncTime(_syncService.lastSyncTime!)
                            : 'Never',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Data Shared',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${_syncService.cycles.length} cycles',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _requestSync(),
                      child: const Text('Sync Now'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextButton(
                      onPressed: () => _showDisconnectDialog(),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Disconnect'),
                    ),
                  ),
                ],
              ),
            ] else ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showConnectionDialog(),
                  child: const Text('Connect to Flow Ai'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.notifications_outlined),
          title: const Text('Notifications'),
          subtitle: const Text('Reminders and insights'),
          trailing: Switch(
            value: _notificationsEnabled,
            onChanged: (value) => setState(() => _notificationsEnabled = value),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.language_outlined),
          title: const Text('Language'),
          subtitle: Text(_selectedLanguage),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _showLanguageDialog(),
        ),
        ListTile(
          leading: const Icon(Icons.palette_outlined),
          title: const Text('Theme'),
          subtitle: Text(_selectedTheme),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _showThemeDialog(),
        ),
      ],
    );
  }

  Widget _buildPrivacySection() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.share_outlined),
          title: const Text('Data Sharing'),
          subtitle: const Text('Share anonymized data to improve AI insights'),
          trailing: Switch(
            value: _dataSharingEnabled,
            onChanged: (value) => setState(() => _dataSharingEnabled = value),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.analytics_outlined),
          title: const Text('Analytics'),
          subtitle: const Text('Help improve the app with usage analytics'),
          trailing: Switch(
            value: _analyticsEnabled,
            onChanged: (value) => setState(() => _analyticsEnabled = value),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.security_outlined),
          title: const Text('Privacy Policy'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _showPrivacyPolicy(),
        ),
        ListTile(
          leading: const Icon(Icons.delete_outline),
          title: const Text('Delete My Data'),
          subtitle: const Text('Permanently delete all your data'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _showDeleteDataDialog(),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Version'),
          subtitle: const Text('2.0.3'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _showVersionInfo(),
        ),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: const Text('Help & Support'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _showSupport(),
        ),
        ListTile(
          leading: const Icon(Icons.rate_review_outlined),
          title: const Text('Rate the App'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _rateApp(),
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text(
            'Sign Out',
            style: TextStyle(color: Colors.red),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.red),
          onTap: () => _showSignOutDialog(),
        ),
        ListTile(
          leading: const Icon(Icons.delete_forever, color: Colors.red),
          title: const Text(
            'Delete Account',
            style: TextStyle(color: Colors.red),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.red),
          onTap: () => _showDeleteAccountDialog(),
        ),
      ],
    );
  }

  void _showConnectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Connect to Flow Ai'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Flow Ai is the consumer app for personal period tracking. '
              'Connecting allows you to:',
            ),
            SizedBox(height: 12),
            Text('• Sync your cycle data between apps'),
            Text('• Share insights with the consumer app'),
            Text('• Access cross-platform features'),
            Text('• Enable unified tracking'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _connectToFlowIQ();
            },
            child: const Text('Connect'),
          ),
        ],
      ),
    );
  }

  void _showDisconnectDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disconnect from Flow Ai'),
        content: const Text(
          'Are you sure you want to disconnect? This will stop syncing your data '
          'with the consumer app, but your local data will remain safe.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _disconnectFromFlowIQ();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Disconnect'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    final languages = ['English', 'Spanish', 'French', 'German', 'Italian'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((language) => RadioListTile<String>(
            title: Text(language),
            value: language,
            groupValue: _selectedLanguage,
            onChanged: (value) {
              setState(() => _selectedLanguage = value!);
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showThemeDialog() {
    final themes = ['System', 'Light', 'Dark'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: themes.map((theme) => RadioListTile<String>(
            title: Text(theme),
            value: theme,
            groupValue: _selectedTheme,
            onChanged: (value) {
              setState(() => _selectedTheme = value!);
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showDeleteDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete My Data'),
        content: const Text(
          'This action cannot be undone. All your cycle data, symptoms, '
          'and insights will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAllData();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.privacy_tip, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            const Text('Privacy Policy'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Privacy is Our Priority',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'At Flow-AI, we understand that your menstrual health data is deeply '
                  'personal and sensitive. Your privacy and data security are our highest priorities.',
                  style: TextStyle(height: 1.4),
                ),
                const SizedBox(height: 16),
                
                _buildPolicySection('🔒 Key Principles', [
                  'Your data belongs to you - You maintain full control',
                  'Transparency first - Clear information about all data practices',
                  'Security by design - End-to-end encryption and protection',
                  'Minimal data collection - We only collect what\'s necessary',
                  'Your choice - Opt-in/opt-out controls for all features',
                ]),
                
                _buildPolicySection('📊 Data We Collect', [
                  'Menstrual cycle data (periods, symptoms, moods)',
                  'Health assessment responses',
                  'App usage patterns (anonymized)',
                  'Account information (email, preferences)',
                ]),
                
                _buildPolicySection('🔄 How We Use Your Data', [
                  'Personalized cycle tracking and predictions',
                  'AI-powered health insights and recommendations',
                  'App improvement and feature development',
                  'Customer support and communication',
                ]),
                
                _buildPolicySection('🚫 What We DON\'T Do', [
                  'Never sell your personal health data',
                  'Never share without your explicit consent',
                  'Never use data for advertising purposes',
                  'Never access data without proper encryption',
                ]),
                
                _buildPolicySection('🏥 Flow-iQ Integration', [
                  'Optional - You choose to connect',
                  'Explicit consent required for data sharing',
                  'Only designated healthcare providers can access',
                  'Revoke access anytime in settings',
                ]),
                
                _buildPolicySection('🤖 AI and Health Diagnosis', [
                  'AI insights are screening tools, not medical diagnosis',
                  'Always consult healthcare providers for medical decisions',
                  'Local processing when possible, encrypted cloud analysis',
                  'Anonymous data used to improve algorithms (opt-in only)',
                ]),
                
                _buildPolicySection('🔐 Security Measures', [
                  'AES-256 end-to-end encryption',
                  'HIPAA-compliant cloud infrastructure',
                  'Multi-factor authentication',
                  'Regular security audits and monitoring',
                ]),
                
                _buildPolicySection('✅ Your Rights', [
                  'Access all your data anytime',
                  'Download your data in portable format',
                  'Correct or update your information',
                  'Delete your account and all data',
                  'Control what data is shared and with whom',
                ]),
                
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info, color: Colors.blue[600], size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'GDPR & CCPA Compliant',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'We comply with GDPR, CCPA, HIPAA, and other privacy regulations worldwide. '
                        'EU users have additional rights including data portability and the right to be forgotten.',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                Text(
                  'Contact Us',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Privacy questions: privacy@flow-ai.com\n'
                  'Data Protection Officer: dpo@flow-ai.com\n'
                  'General inquiries: support@flow-ai.com',
                  style: TextStyle(fontSize: 13, height: 1.4),
                ),
                
                const SizedBox(height: 16),
                Text(
                  'Last Updated: September 2, 2024 • Version 2.0.3',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Open full privacy policy document
              _showFullPrivacyPolicy();
            },
            child: const Text('View Full Policy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showVersionInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Flow iQ v2.0.3'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('What\'s New:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('• Enhanced Flow Ai integration'),
            Text('• Improved AI insights'),
            Text('• Better sync performance'),
            Text('• Bug fixes and improvements'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSupport() {
    // TODO: Implement support page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Support page coming soon')),
    );
  }

  void _rateApp() {
    // TODO: Implement app rating
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thank you for your feedback!')),
    );
  }
  
  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              
              try {
                final authService = Provider.of<EnhancedAuthService>(context, listen: false);
                await authService.signOut();
                
                if (mounted) {
                  // Navigate to auth screen
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/auth',
                    (route) => false,
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error signing out: $e')),
                  );
                }
              }
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
  
  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This will permanently delete your account and all associated data. This action cannot be undone.\n\nAre you absolutely sure?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              
              try {
                final authService = Provider.of<EnhancedAuthService>(context, listen: false);
                await authService.deleteAccount();
                
                if (mounted) {
                  // Navigate to auth screen
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/auth',
                    (route) => false,
                  );
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Account deleted successfully')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting account: $e')),
                  );
                }
              }
            },
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  void _connectToFlowIQ() {
    setState(() => _isFlowIQConnected = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Connected to Flow Ai successfully!')),
    );
  }

  void _disconnectFromFlowIQ() {
    setState(() => _isFlowIQConnected = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Disconnected from Flow Ai')),
    );
  }

  void _requestSync() async {
    await _syncService.requestSync();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sync requested')),
    );
  }

  void _deleteAllData() {
    // TODO: Implement data deletion
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All data deleted')),
    );
  }

  String _formatSyncTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  Widget _buildPolicySection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ', style: TextStyle(fontSize: 12)),
              Expanded(
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 12, height: 1.3),
                ),
              ),
            ],
          ),
        )).toList(),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showFullPrivacyPolicy() {
    Navigator.pop(context); // Close current dialog
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Full Privacy Policy'),
        content: SizedBox(
          width: double.maxFinite,
          height: 500,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'FLOW-AI PRIVACY POLICY',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Effective Date: September 2, 2024\n'
                  'Last Updated: September 2, 2024',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 20),
                
                _buildFullPolicySection('1. INTRODUCTION', [
                  'Flow-AI ("we," "our," or "us") is committed to protecting your privacy and the security of your personal health information.',
                  'This Privacy Policy describes how we collect, use, disclose, and safeguard your information when you use our mobile application.',
                  'By using Flow-AI, you consent to the data practices described in this policy.',
                ]),
                
                _buildFullPolicySection('2. INFORMATION WE COLLECT', [
                  'Personal Information: Account details (email, name), profile information',
                  'Health Data: Menstrual cycle information, symptoms, moods, health assessments',
                  'Usage Data: App interaction patterns, feature usage (anonymized)',
                  'Device Information: Device type, operating system, app version',
                  'Location Data: Only if explicitly consented for cycle prediction accuracy',
                ]),
                
                _buildFullPolicySection('3. HOW WE USE YOUR INFORMATION', [
                  'Provide personalized cycle tracking and predictions',
                  'Generate AI-powered health insights and recommendations',
                  'Facilitate data sharing with healthcare providers (Flow-iQ integration)',
                  'Improve app functionality and user experience',
                  'Provide customer support and respond to inquiries',
                  'Ensure app security and prevent fraud',
                ]),
                
                _buildFullPolicySection('4. DATA SHARING AND DISCLOSURE', [
                  'Healthcare Providers: Only with explicit consent through Flow-iQ',
                  'Service Providers: Encrypted data with trusted partners for app functionality',
                  'Legal Requirements: Only when required by law or to protect rights',
                  'Business Transfers: In case of merger or acquisition (with notice)',
                  'We NEVER sell personal health data to third parties',
                ]),
                
                _buildFullPolicySection('5. FLOW-IQ INTEGRATION', [
                  'Optional feature requiring explicit user consent',
                  'Allows secure data sharing with designated healthcare providers',
                  'Users maintain full control over what data is shared',
                  'Access can be revoked at any time through app settings',
                  'Healthcare providers must comply with HIPAA and professional standards',
                ]),
                
                _buildFullPolicySection('6. AI AND HEALTH INSIGHTS', [
                  'AI recommendations are screening tools, not medical diagnoses',
                  'Always consult qualified healthcare professionals for medical decisions',
                  'Machine learning models use anonymized, aggregated data',
                  'Local processing prioritized when possible',
                  'Cloud analysis uses end-to-end encryption',
                ]),
                
                _buildFullPolicySection('7. DATA SECURITY', [
                  'AES-256 encryption for data transmission and storage',
                  'HIPAA-compliant cloud infrastructure',
                  'Multi-factor authentication for account access',
                  'Regular security audits and vulnerability assessments',
                  'Staff training on privacy and security protocols',
                ]),
                
                _buildFullPolicySection('8. YOUR PRIVACY RIGHTS', [
                  'Access: Request copies of your personal information',
                  'Rectification: Correct inaccurate or incomplete data',
                  'Erasure: Request deletion of your personal data',
                  'Portability: Receive your data in a machine-readable format',
                  'Restriction: Limit how we process your data',
                  'Objection: Object to data processing for specific purposes',
                ]),
                
                _buildFullPolicySection('9. INTERNATIONAL TRANSFERS', [
                  'Data may be processed in countries other than your residence',
                  'We ensure adequate protection through appropriate safeguards',
                  'EU users: Data transfers comply with GDPR requirements',
                  'Standard Contractual Clauses used for international transfers',
                ]),
                
                _buildFullPolicySection('10. CHILDREN\'S PRIVACY', [
                  'Flow-AI is not intended for children under 13',
                  'We do not knowingly collect data from children under 13',
                  'Parents may request deletion of child\'s information',
                  'Teen users (13-17) require parental guidance for health decisions',
                ]),
                
                _buildFullPolicySection('11. DATA RETENTION', [
                  'Health data retained as long as account is active',
                  'Usage data anonymized and aggregated for improvements',
                  'Account deletion removes all personal identifiable data',
                  'Backup data permanently deleted within 90 days',
                ]),
                
                _buildFullPolicySection('12. CHANGES TO THIS POLICY', [
                  'We may update this policy to reflect changes in practices',
                  'Users notified of material changes via app or email',
                  'Continued use constitutes acceptance of updated policy',
                  'Previous versions available upon request',
                ]),
                
                _buildFullPolicySection('13. CONTACT INFORMATION', [
                  'Privacy Officer: privacy@flow-ai.com',
                  'Data Protection Officer: dpo@flow-ai.com',
                  'General Support: support@flow-ai.com',
                  'Mailing Address: [Company Address]',
                ]),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showPrivacyPolicy(); // Go back to summary
            },
            child: const Text('Back to Summary'),
          ),
        ],
      ),
    );
  }

  Widget _buildFullPolicySection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 6),
          child: Text(
            '• $item',
            style: const TextStyle(fontSize: 12, height: 1.4),
          ),
        )).toList(),
        const SizedBox(height: 16),
      ],
    );
  }
}
