class Branch {
  final String id;
  final String name;
  final String address;
  final List<String> coachIds;
  final List<String> studentIds;

  Branch({
    required this.id,
    required this.name,
    required this.address,
    required this.coachIds,
    required this.studentIds,
  });
}
