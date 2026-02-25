import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../auth_module/presentation/feature/bloc/auth_bloc.dart';
import '../../../../base_module/domain/entities/translation.dart';
import '../../../../base_module/presentation/util/locale_digits.dart';
import '../../../domain/entities/employee_entity.dart';
import '../../../domain/repositories/employee_repository.dart';
import '../../../domain/entities/organization_entity.dart';
import '../../../domain/repositories/organization_repository.dart';
import '../../../domain/datasources/organization_api.dart';
import 'employee_profile_screen.dart';
import '../bloc/organization_tab_cubit/organization_tab_cubit.dart';
import '../bloc/organization_tab_cubit/organization_tab_state.dart';

class OrganizationTabScreen extends StatefulWidget {
  const OrganizationTabScreen({super.key});

  @override
  State<OrganizationTabScreen> createState() => _OrganizationTabScreenState();
}

class _OrganizationTabScreenState extends State<OrganizationTabScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    if (authState is! AuthStateAuthenticated) {
      return const Center(child: Text('Not authenticated'));
    }
    final orgId = authState.session.organizationId ?? 'demo-org-xyz';

   
    return BlocProvider(
      create: (context) => OrganizationTabCubit(
        orgId: orgId,
        api: context.read<OrganizationApi>(),
        orgRepo: context.read<OrganizationRepository>(),
        empRepo: context.read<EmployeeRepository>(),
      )..load(),
      child: BlocBuilder<OrganizationTabCubit, OrganizationTabState>(
        buildWhen: (prev, next) =>
            prev.isInitialLoading != next.isInitialLoading ||
            prev.organization != next.organization ||
            prev.selectedDepartmentId != next.selectedDepartmentId ||
            prev.searchQuery != next.searchQuery,
        builder: (context, state) {
          if (state.isInitialLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CupertinoActivityIndicator(
                     
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    translation.of('loading'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildOrgHeader(context, state.organization),
                const SizedBox(height: 20),
                _buildSearchAndFilterSection(context, state),
                const SizedBox(height: 16),
                Text(
                  translation.of('org.directory'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                BlocSelector<OrganizationTabCubit, OrganizationTabState, ({List<EmployeeEntity> employees, bool isEmployeesLoading})>(
                  selector: (s) => (employees: s.employees, isEmployeesLoading: s.isEmployeesLoading),
                  builder: (context, data) => _buildEmployeeList(context, data.employees, data.isEmployeesLoading),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmployeeList(BuildContext context, List<EmployeeEntity> employees, bool isEmployeesLoading) {
    if (isEmployeesLoading && employees.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SizedBox(
            width: 32,
            height: 32,
            child: CupertinoActivityIndicator(
             
            ),
          ),
        ),
      );
    }
    if (isEmployeesLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
          ...employees.map((e) => _buildEmployeeCard(context, e)),
        ],
      );
    }
    if (employees.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(child: Text(translation.of('no_item'))),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: employees.map((e) => _buildEmployeeCard(context, e)).toList(),
    );
  }

  Widget _buildOrgHeader(BuildContext context, OrganizationEntity? org) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final displayName = org?.name ?? 'Company';
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'A';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha:0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha:0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: org?.logoUrl != null && org!.logoUrl!.isNotEmpty
                    ? Image.network(
                        org.logoUrl!,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildOrgAvatarPlaceholder(context, initial, 64),
                      )
                    : _buildOrgAvatarPlaceholder(context, initial, 64),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                        children: [
                          Icon(
                            Icons.business_rounded,
                            size: 14,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            org?.name??'',
                            style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.3,
                      ),
                          ),
                        ],
                      
                                         ),
                    const SizedBox(height: 4),
                    if (org?.industry != null && org!.industry!.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.business_center_outlined,
                            size: 14,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            org.industry!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        translation.of('org.company'),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    if (org?.totalHeadcount != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withValues(alpha:0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.people_alt_outlined,
                              size: 16,
                              color: colorScheme.onPrimaryContainer,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              LocaleDigits.format('${translation.of('org.headcount')}: ${org!.totalHeadcount}'),
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrgAvatarPlaceholder(BuildContext context, String initial, double size) {
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
            colorScheme.primary.withValues(alpha:0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilterSection(BuildContext context, OrganizationTabState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cubit = context.read<OrganizationTabCubit>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha:0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tune_rounded,
                size: 18,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                translation.of('filter'),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildDepartmentChips(context, state.organization, state.selectedDepartmentId, cubit),
          const SizedBox(height: 14),
          _buildSearchBar(context, state.searchQuery, cubit),
        ],
      ),
    );
  }

  Widget _buildDepartmentChips(
    BuildContext context,
    OrganizationEntity? org,
    String? selectedDepartmentId,
    OrganizationTabCubit cubit,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final departments = org?.departments ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translation.of('department'),
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              _buildFilterChip(
                context: context,
                label: translation.of('all'),
                selected: selectedDepartmentId == null,
                onTap: () => cubit.setSelectedDepartmentId(null),
              ),
              const SizedBox(width: 8),
              ...departments.map((d) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildFilterChip(
                      context: context,
                      label: d.name,
                      selected: selectedDepartmentId == d.id,
                      onTap: () => cubit.setSelectedDepartmentId(d.id),
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? colorScheme.primaryContainer
                : colorScheme.surfaceContainerHighest.withValues(alpha:0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected
                  ? colorScheme.primary.withValues(alpha:0.5)
                  : colorScheme.outline.withValues(alpha:0.15),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: selected
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, String searchQuery, OrganizationTabCubit cubit) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextField(
      controller: _searchController,
      onChanged: (v) => cubit.setSearchQuery(v),
      decoration: InputDecoration(
        hintText: translation.of('search'),
        prefixIcon: Icon(
          Icons.search_rounded,
          size: 22,
          color: colorScheme.onSurfaceVariant,
        ),
        suffixIcon: searchQuery.isNotEmpty
            ? IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
                onPressed: () {
                  _searchController.clear();
                  cubit.setSearchQuery('');
                },
              )
            : null,
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha:0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildEmployeeCard(BuildContext context, EmployeeEntity e) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha:0.1),
        ),
      ),
      child: InkWell(
        onTap: () {
          final authState = context.read<AuthBloc>().state;
          final orgId = authState is AuthStateAuthenticated
              ? (authState.session.organizationId ?? 'demo-org-xyz')
              : 'demo-org-xyz';
          void pushManagerProfile(EmployeeEntity manager) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (ctx) => EmployeeProfileScreen(
                  employee: manager,
                  orgId: orgId,
                  onBack: () => Navigator.pop(ctx),
                  onTapManager: pushManagerProfile,
                ),
              ),
            );
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => EmployeeProfileScreen(
                employee: e,
                orgId: orgId,
                onBack: () => Navigator.pop(ctx),
                onTapManager: pushManagerProfile,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: e.profilePhotoUrl != null ? NetworkImage(e.profilePhotoUrl!) : null,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: e.profilePhotoUrl == null
                    ? Text(
                        e.fullName.isNotEmpty ? e.fullName[0].toUpperCase() : '?',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
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
                      e.fullName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (e.jobTitle != null && e.jobTitle!.isNotEmpty)
                      Text(
                        e.jobTitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: e.isOnline
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline.withValues(alpha:0.6),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 22,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
