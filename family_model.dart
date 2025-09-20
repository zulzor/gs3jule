class Family {
  final String id;
  final String familyName;
  final List<String> parentIds;
  final List<String> childIds;

  Family({
    required this.id,
    required this.familyName,
    required this.parentIds,
    required this.childIds,
  });
}
