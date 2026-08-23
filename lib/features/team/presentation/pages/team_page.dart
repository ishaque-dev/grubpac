import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grubpac/core/constants/app_strings.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/core/theme/app_theme.dart';
import 'package:grubpac/features/team/presentation/bloc/team_bloc.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key, required this.session});

  final UserSessionEntity session;

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  @override
  void initState() {
    super.initState();
    context.read<TeamBloc>().add(TeamMembersLoadRequested(widget.session));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppUiStrings.organizationTeam, style: AppText.display(size: 24.sp)),
        centerTitle: false,
      ),
      body: BlocBuilder<TeamBloc, TeamState>(
        builder: (context, state) {
          if (state is TeamLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.lime));
          }

          if (state is TeamFailure) {
            return Center(child: Text(state.message, style: AppText.body(color: AppColors.danger)));
          }

          if (state is TeamLoaded) {
            final members = state.members;
            return ListView.separated(
              padding: EdgeInsets.all(24.w),
              itemCount: members.length,
              separatorBuilder: (_, _) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final member = members[index];
                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24.r,
                          backgroundColor: AppColors.line,
                          backgroundImage: member.avatarUrl != null ? NetworkImage(member.avatarUrl!) : null,
                          child: member.avatarUrl == null ? const Icon(Icons.person, color: AppColors.textMuted) : null,
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(member.name.toUpperCase(), style: AppText.display(size: 18.sp)),
                              Text(member.email, style: AppText.body(size: 12.sp, color: AppColors.textMuted)),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.lime.withValues(alpha: 0.5)),
                          ),
                          child: Text(
                            member.role.toUpperCase(),
                            style: AppText.mono(size: 9.sp, color: AppColors.lime, weight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
