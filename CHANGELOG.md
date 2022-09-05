# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## Unreleased

<!-- Add your changelog entry to the relevant subsection -->

<!-- ### Added | Changed | Deprecated | Removed | Fixed | Security -->

### Fixed

- Wrap map keys in doouble quotes when required ([#94](https://github.com/ufirstgroup/ymlr/issues/94), [#95](https://github.com/ufirstgroup/ymlr/pull/95))
- Encode structs by turning them to lists before mapping over them

<!--------------------- Don't add new entries after this line --------------------->

## [3.0.0] - 2022-08-07

**In this release we changed the way `DateTime` is encoded (see below). This can be a breaking change if you rely on the old date format with spaces. Because of this change, version 3.0.0 is now again compatible with Elixir 1.10**

### Changed

- use `Enum.map_join/3` indead of `Enum.map/2` and `Enum.join/2` as it's more efficient according to credo recommendations
- Change the serialization of timestamps to use the canonical (iso8601) format, i.e. before: `2022-07-31 14:48:48.000000000 Z` and now: `"2022-07-31T14:48:48Z"` ([#87](https://github.com/ufirstgroup/ymlr/issues/87), [#90](https://github.com/ufirstgroup/ymlr/pull/90))

## [2.0.0] - 2021-04-02

### Removed

- 2.0 and upwards don't support Elixir 1.10 anymore. Use version 1.x for Elixir 1.10 support.

### Added

- Date and DateTime support (#17)

### Chores

- yaml_elixir upgraded to 2.6.0
- excoveralls upgraded to 0.14.0
- ex_doc upgraded to 0.24.1
- credo upgraded to 1.5.5
- dialyxir upgraded to 1.1.0

## [1.1.0] - 2021-04-02

### Added

- Date and DateTime support (#17)

### Chores

- yaml_elixir upgraded to 2.6.0
- excoveralls upgraded to 0.14.0
- ex_doc upgraded to 0.24.1
- credo upgraded to 1.5.5
- dialyxir upgraded to 1.1.0

## [1.0.1] - 2020-09-22

### Changed

- Rescue ArgumentError exception for oversize floats according to Float.parse/1 doc

## [1.0.0] - 2020-08-21

No changes in this release. We have tested the library on a big bunch of CRDs and feel confident to publish a sable relese.

## [0.0.1] - 2020-07-31

First ymlr beta release
