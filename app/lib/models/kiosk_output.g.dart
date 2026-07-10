// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kiosk_output.dart';

// **************************************************************************
// SchemaGenerator
// **************************************************************************

base class KioskOutput {
  /// Creates a [KioskOutput] from a JSON map.
  factory KioskOutput.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  KioskOutput._(this._json);

  KioskOutput({
    required bool success,
    required String imageUrl,
    required String caption,
  }) {
    _json = {'success': success, 'imageUrl': imageUrl, 'caption': caption};
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [KioskOutput].
  static const SchemanticType<KioskOutput> $schema = _KioskOutputTypeFactory();

  bool get success {
    return _json['success'] as bool;
  }

  set success(bool value) {
    _json['success'] = value;
  }

  String get imageUrl {
    return _json['imageUrl'] as String;
  }

  set imageUrl(String value) {
    _json['imageUrl'] = value;
  }

  String get caption {
    return _json['caption'] as String;
  }

  set caption(String value) {
    _json['caption'] = value;
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [KioskOutput] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _KioskOutputTypeFactory extends SchemanticType<KioskOutput> {
  const _KioskOutputTypeFactory();

  @override
  KioskOutput parse(Object? json) {
    return KioskOutput._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'KioskOutput',
    definition: $Schema
        .object(
          properties: {
            'success': $Schema.boolean(),
            'imageUrl': $Schema.string(),
            'caption': $Schema.string(),
          },
          required: ['success', 'imageUrl', 'caption'],
        )
        .value,
    dependencies: [],
  );
}
