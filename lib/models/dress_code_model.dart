class DressCode {
  final String name;
  final String videoAsset;
  final String description;

  const DressCode({
    required this.name,
    required this.videoAsset,
    required this.description,
  });

  static const List<DressCode> dressCodeOptions = [
    DressCode(
      name: 'Business Casual',
      videoAsset: 'assets/videos/business_casual.mp4',
      description: 'Professional but relaxed attire suitable for business settings',
    ),
    DressCode(
      name: 'Business Formal',
      videoAsset: 'assets/videos/business_formal.mp4',
      description: 'Traditional business attire with suits and formal wear',
    ),
    DressCode(
      name: 'Operator',
      videoAsset: 'assets/videos/operator.mp4',
      description: 'Tactical attire with visible security equipment',
    ),
    DressCode(
      name: 'Tactical Casual',
      videoAsset: 'assets/videos/tactical_casual.mp4',
      description: 'Casual attire with concealed security equipment',
    ),
  ];

  static DressCode fromName(String name) {
    return dressCodeOptions.firstWhere(
      (dressCode) => dressCode.name == name,
      orElse: () => dressCodeOptions.first,
    );
  }
}