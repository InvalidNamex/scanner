class FileModel {
  final int? fileId;
  final String? counterCode;
  final String? fileTitle;
  final String? fileImage;
  final String? fileDate;
  final String? fileSubject;
  final String? fileLink;
  const FileModel({
    this.fileId,
    this.fileTitle,
    this.fileImage,
    this.fileDate,
    this.fileSubject,
    this.fileLink,
    this.counterCode,
  });
  static FileModel fromJson(Map<String, dynamic> json) => FileModel(
        fileId: json['file_id'] as int?,
        counterCode: json['file_counter_code'] as String?,
        fileTitle: json['file_title'] as String?,
        fileImage: json['file_image'] as String?,
        fileDate: json['file_date'] as String?,
        fileSubject: json['file_subject'] as String?,
        fileLink: json['file_link'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'file_id': fileId,
        'file_counter_code': counterCode,
        'file_title': fileTitle,
        'file_image': fileImage,
        'file_date': fileDate,
        'file_subject': fileSubject,
        'file_link': fileLink
      };

  // to store the generated id
  FileModel copy({
    int? fileId,
    String? counterCode,
    String? fileTitle,
    String? fileImage,
    String? fileDate,
    String? fileSubject,
    String? fileLink,
  }) =>
      FileModel(
        fileId: fileId ?? this.fileId,
        counterCode: counterCode ?? this.counterCode,
        fileImage: fileImage ?? this.fileImage,
        fileDate: fileDate ?? this.fileDate,
        fileSubject: fileSubject ?? this.fileSubject,
        fileLink: fileSubject ?? this.fileLink,
        fileTitle: fileSubject ?? this.fileTitle,
      );
}
