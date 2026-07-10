// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kiosk_input.dart';

// **************************************************************************
// SchemaGenerator
// **************************************************************************

base class KioskInput {
  /// Creates a [KioskInput] from a JSON map.
  factory KioskInput.fromJson(Map<String, dynamic> json) => $schema.parse(json);

  KioskInput._(this._json);

  KioskInput({required String imageUrl, required String templateId}) {
    _json = {'imageUrl': imageUrl, 'templateId': templateId};
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [KioskInput].
  static const SchemanticType<KioskInput> $schema = _KioskInputTypeFactory();

  String get imageUrl {
    return _json['imageUrl'] as String;
  }

  set imageUrl(String value) {
    _json['imageUrl'] = value;
  }

  String get templateId {
    return _json['templateId'] as String;
  }

  set templateId(String value) {
    _json['templateId'] = value;
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [KioskInput] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _KioskInputTypeFactory extends SchemanticType<KioskInput> {
  const _KioskInputTypeFactory();

  @override
  KioskInput parse(Object? json) {
    return KioskInput._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'KioskInput',
    definition: $Schema
        .object(
          properties: {
            'imageUrl': $Schema.string(),
            'templateId': $Schema.string(),
          },
          required: ['imageUrl', 'templateId'],
        )
        .value,
    dependencies: [],
  );
}
