import 'package:hive/hive.dart';
import '../../domain/entities/team_member.dart';

part 'team_member_model.g.dart';

@HiveType(typeId: 3)
class TeamMemberModel extends TeamMember {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  const TeamMemberModel({
    required this.id,
    required this.name,
  }) : super(
          id: id,
          name: name,
        );

  factory TeamMemberModel.fromEntity(TeamMember teamMember) {
    return TeamMemberModel(
      id: teamMember.id,
      name: teamMember.name,
    );
  }

  TeamMember toEntity() {
    return TeamMember(
      id: id,
      name: name,
    );
  }
}

