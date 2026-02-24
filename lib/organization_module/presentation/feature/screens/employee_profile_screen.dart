import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../base_module/domain/entities/translation.dart';
import '../../../../base_module/presentation/util/date_time_format.dart';
import '../../../domain/entities/employee_entity.dart';
import '../../../domain/repositories/employee_repository.dart';

class EmployeeProfileScreen extends StatelessWidget {
  const EmployeeProfileScreen({
    super.key,
    required this.employee,
    required this.orgId,
    required this.onBack,
    required this.onTapManager,
  });

  final EmployeeEntity employee;
  final String orgId;
  final VoidCallback onBack;
  final void Function(EmployeeEntity) onTapManager;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: onBack,
          style: IconButton.styleFrom(
            backgroundColor: colorScheme.surfaceContainerHighest,
          ),
        ),
        title: Text(
          translation.of('org.employee_profile'),
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
        backgroundColor: colorScheme.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            _buildProfileHeader(context),
            const SizedBox(height: 24),
            if (_hasContactInfo) _buildContactCard(context),
            if (employee.reportingManagerId != null) ...[
              const SizedBox(height: 20),
              _buildReportingManagerSection(context),
            ],
          ],
        ),
      ),
    );
  }

  bool get _hasContactInfo =>
      employee.email != null ||
      employee.phone != null ||
      employee.joinDate != null;

  Widget _buildProfileHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final initial = employee.fullName.isNotEmpty ? employee.fullName[0].toUpperCase() : '?';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              ClipOval(
                child: employee.profilePhotoUrl != null && employee.profilePhotoUrl!.isNotEmpty
                    ? Image.network(
                        employee.profilePhotoUrl!,
                        width: 96,
                        height: 96,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _avatarPlaceholder(context, initial, 96),
                      )
                    : _avatarPlaceholder(context, initial, 96),
              ),
              if (employee.isOnline)
                Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(right: 4, bottom: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primary,
                    border: Border.all(color: colorScheme.surface, width: 2),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            employee.fullName,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
            textAlign: TextAlign.center,
          ),
          if (employee.jobTitle != null && employee.jobTitle!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              employee.jobTitle!,
              style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
          if (employee.departmentName != null && employee.departmentName!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.business_center_outlined, size: 16, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(
                  employee.departmentName!,
                  style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _avatarPlaceholder(BuildContext context, String initial, double size) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.contact_phone_rounded, size: 20, color: colorScheme.primary),
              const SizedBox(width: 10),
              Text(
                translation.of('contact'),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (employee.email != null)
            _profileRow(context, Icons.email_outlined, employee.email!),
          if (employee.phone != null)
            _profileRow(context, Icons.phone_outlined, employee.phone!),
          if (employee.joinDate != null)
            _profileRow(
              context,
              Icons.calendar_today_rounded,
              '${translation.of('org.join_date')}: ${AppDateTimeFormat.formatDate(employee.joinDate!)}',
            ),
        ],
      ),
    );
  }

  Widget _profileRow(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: colorScheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                text,
                style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportingManagerSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.supervisor_account_rounded, size: 20, color: colorScheme.primary),
            const SizedBox(width: 10),
            Text(
              translation.of('org.reporting_manager'),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        FutureBuilder<EmployeeEntity?>(
          future: context.read<EmployeeRepository>().getEmployeeById(employee.reportingManagerId!),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CupertinoActivityIndicator(),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      translation.of('loading'),
                      style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              );
            }
            final manager = snap.data;
            if (manager == null) return const SizedBox.shrink();
            return _buildManagerCard(context, manager);
          },
        ),
      ],
    );
  }

  Widget _buildManagerCard(BuildContext context, EmployeeEntity manager) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTapManager(manager),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: manager.profilePhotoUrl != null ? NetworkImage(manager.profilePhotoUrl!) : null,
                backgroundColor: colorScheme.primaryContainer,
                child: manager.profilePhotoUrl == null
                    ? Text(
                        manager.fullName.isNotEmpty ? manager.fullName[0].toUpperCase() : '?',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      manager.fullName,
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    if (manager.jobTitle != null && manager.jobTitle!.isNotEmpty)
                      Text(
                        manager.jobTitle!,
                        style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: colorScheme.onSurfaceVariant, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
