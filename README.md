# RNCore configuration-swap reproducer

This repository uses the official React Native reproducer template. It tests
React Native 0.87.0-rc.3.

The app adds one local CocoaPod with one Objective-C file. This pod does not
import React. It does not depend on `React-Core-prebuilt`.

React Native adds this flag to the pod:

```text
-fmodule-map-file=$(PODS_ROOT)/React-Core-prebuilt/Headers/module.modulemap
```

## Install

Use Node.js 24.

```sh
cd ReproducerApp
yarn install --frozen-lockfile
bundle install
cd ios
bundle exec pod install
cd ../..
```

## Reproduce the failure

Run:

```sh
bash repro-rncore-swap.sh
```

The script sets the last RNCore configuration to Debug. It then starts a Release
build with new DerivedData.

On Xcode 26.3, the build fails when Clang builds the `React` explicit module.
Clang reports seven non-modular header errors.

The script writes the full log to:

```text
/tmp/rncore-swap-repro-<date-and-time>.log
```

## Control test

Keep RNCore at Release:

```sh
RNCORE_PREVIOUS_CONFIGURATION=Release bash repro-rncore-swap.sh
```

The build passes.

## Workaround test

Disable only Clang explicit modules:

```sh
bash repro-rncore-swap.sh CLANG_ENABLE_EXPLICIT_MODULES=NO
```

The build passes. This test does not set
`SWIFT_ENABLE_EXPLICIT_MODULES=NO`.
