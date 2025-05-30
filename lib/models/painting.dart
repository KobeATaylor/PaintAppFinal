class Painting {
  final int? PaintId;
  final String Title;
  final String Description;
  final String PaintingUrl;

  Painting({
    required this.PaintId,
    required this.Title,
    required this.Description,
    required this.PaintingUrl,
  });

  factory Painting.fromJson(Map<String, dynamic> json) {
    return Painting(
      PaintId: json['paintId'],
      Title: json['title'] ?? 'unknown',
      Description: json['description'] ?? 'unknown',
      PaintingUrl: json['paintingUrl'] ?? 'unknown',
    );
  }
}