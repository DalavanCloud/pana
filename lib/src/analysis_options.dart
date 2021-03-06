// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:yaml/yaml.dart' as yaml;

const String _analysisOptions = '''
# Source of linter options:
# https://dart-lang.github.io/linter/lints/options/options.html

linter:
  rules:
    - camel_case_types
    - cancel_subscriptions
    - hash_and_equals
    - iterable_contains_unrelated_type
    - list_remove_unrelated_type
    - test_types_in_equals
    - unrelated_type_equality_checks
    - valid_regexps
''';

// Keep it updated with
// https://github.com/flutter/flutter/blob/master/packages/flutter/lib/analysis_options_user.yaml
const String _flutterAnalysisOptions = '''
analyzer:
  errors:
    # treat missing required parameters as a warning (not a hint)
    missing_required_param: warning

# Source of linter options:
# https://dart-lang.github.io/linter/lints/options/options.html

linter:
  rules:
    - avoid_empty_else
    - avoid_init_to_null
    - avoid_return_types_on_setters
    - await_only_futures
    - camel_case_types
    - cancel_subscriptions
    - close_sinks
    - control_flow_in_finally
    - empty_constructor_bodies
    - empty_statements
    - hash_and_equals
    - implementation_imports
    - library_names
    - non_constant_identifier_names
    - package_api_docs
    - package_names
    - package_prefixed_library_names
    - prefer_is_not_empty
    - slash_for_doc_comments
    - super_goes_last
    - test_types_in_equals
    - throw_in_finally
    - type_init_formals
    - unnecessary_brace_in_string_interps
    - unnecessary_getters_setters
    - unnecessary_statements
    - unrelated_type_equality_checks
    - valid_regexps
''';

const _analyzerErrorKeys = <String>['uri_has_not_been_generated'];

String customizeAnalysisOptions(String original, bool usesFlutter) {
  Map origMap;
  if (original != null) {
    try {
      origMap = yaml.loadYaml(original) as Map;
    } catch (_) {}
  }
  origMap ??= {};

  final customMap = json.decode(json.encode(
      yaml.loadYaml(usesFlutter ? _flutterAnalysisOptions : _analysisOptions)));

  final origAnalyzer = origMap['analyzer'];
  if (origAnalyzer is Map) {
    final origErrors = origAnalyzer['errors'];
    if (origErrors is Map) {
      final Map customAnalyzer = customMap.putIfAbsent('analyzer', () => {});
      final Map customErrors = customAnalyzer.putIfAbsent('errors', () => {});

      for (var key in _analyzerErrorKeys) {
        if (origErrors.containsKey(key)) {
          customErrors[key] = origErrors[key];
        }
      }
    }
  }

  return json.encode(customMap);
}
