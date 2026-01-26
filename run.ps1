#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"

dart run build_runner build --delete-conflicting-outputs
flutter run @args
