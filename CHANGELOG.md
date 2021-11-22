# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## Unreleased

### Changed

- use `Enum.map_join/3` indead of `Enum.map/2` and `Enum.join/2` as it's more efficient according to credo recommendations

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
