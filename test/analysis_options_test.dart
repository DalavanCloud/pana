// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:test/test.dart';

import 'package:pana/src/analysis_options.dart';

void main() {
  test('default options', () {
    expect(json.decode(customizeAnalysisOptions(null, false)), {
      'linter': {
        'rules': [
          'camel_case_types',
          'cancel_subscriptions',
          'hash_and_equals',
          'iterable_contains_unrelated_type',
          'list_remove_unrelated_type',
          'test_types_in_equals',
          'unrelated_type_equality_checks',
          'valid_regexps',
        ]
      },
    });
  });

  test('flutter without original', () {
    expect(json.decode(customizeAnalysisOptions(null, true)), {
      'analyzer': {
        'errors': {'missing_required_param': 'warning'},
      },
      'linter': {
        'rules': [
          'avoid_empty_else',
          'avoid_init_to_null',
          'avoid_return_types_on_setters',
          'await_only_futures',
          'camel_case_types',
          'cancel_subscriptions',
          'close_sinks',
          'control_flow_in_finally',
          'empty_constructor_bodies',
          'empty_statements',
          'hash_and_equals',
          'implementation_imports',
          'library_names',
          'non_constant_identifier_names',
          'package_api_docs',
          'package_names',
          'package_prefixed_library_names',
          'prefer_is_not_empty',
          'slash_for_doc_comments',
          'super_goes_last',
          'test_types_in_equals',
          'throw_in_finally',
          'type_init_formals',
          'unnecessary_brace_in_string_interps',
          'unnecessary_getters_setters',
          'unnecessary_statements',
          'unrelated_type_equality_checks',
          'valid_regexps'
        ]
      },
    });
  });

  test('not whitelisted analyzer error', () {
    final original = '''
analyzer:
  errors:
    todo: ignore
''';
    expect(json.decode(customizeAnalysisOptions(original, false)), {
      'analyzer': {
        'errors': {},
      },
      'linter': {
        'rules': [
          'camel_case_types',
          'cancel_subscriptions',
          'hash_and_equals',
          'iterable_contains_unrelated_type',
          'list_remove_unrelated_type',
          'test_types_in_equals',
          'unrelated_type_equality_checks',
          'valid_regexps',
        ],
      },
    });
  });

  test('whitelisted analyzer error', () {
    final original = '''
analyzer:
  errors:
    uri_has_not_been_generated: ignore
''';
    expect(json.decode(customizeAnalysisOptions(original, false)), {
      'analyzer': {
        'errors': {
          'uri_has_not_been_generated': 'ignore',
        },
      },
      'linter': {
        'rules': [
          'camel_case_types',
          'cancel_subscriptions',
          'hash_and_equals',
          'iterable_contains_unrelated_type',
          'list_remove_unrelated_type',
          'test_types_in_equals',
          'unrelated_type_equality_checks',
          'valid_regexps',
        ],
      },
    });
  });
}
