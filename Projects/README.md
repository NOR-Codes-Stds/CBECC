# Projects Directory
This directory is a collection of various CBECC models used for testing, development, and reference.

## `release-package.json`
This file is used to track the files that are typically packaged within a release. Please reference the `Projects/release-package.json` for detail. **TODO:** Create and note the workflow noted in #772

## `pr-checks.json`
This file is used to track the files that are typically checked for PRs. Please reference the `Projects/pr-checks.json` for detail. **TODO:** Create and note a workflow

## Year Directory Components
### All Directories (`non-residential`, `multi-family`, `mixed-use`, `single-family`)
- `schema-related`
- `prototypes`
- `user-support`

### Specific to `non-residential`, `multi-family`, `mixed-use`
- `cuac` (MF only)
- `other`
- `ruleset-implementation`
- `sensitivity`
- `standard`
- `standard-add-alt`


### Specific to `single-family`
- `cuac`
- `samples`
- `samples-add-alt`
- `TDS`

## `~not-for-release` Directories
This sub-directory should exist in directories that are typically packaged within a release. Please reference the `Projects/release-package.json` for detail. **TODO:** Create and note the workflow noted in #772

**NOTE:** the `.gitkeep` files in these directories are used to ensure the directories are tracked by Git even if they are empty. Do not remove these `.gitkeep` files.

## `~intentional-failures` Directories
This sub-directory should exist in directories that are used to test the system's ability to handle failures. Currently it only exists as needed. Files in these directories are also not-for-release.

**Important:** Assure to include a README.md file in each of these directories to explain how/why these files are intended to fail.

## `user-support` Directories
These directories in each of the core directories are used to store and track models submitted from user-support issues which contain valuable reach-cases that the current testing suite otherwise does not test. 

**TODO: A workflow/wiki page should be created to track and manage these files.**

## Typical `mixed-use` models
All project files whose names contain any of the following strings are mixed‑use projects:
- "MF8wRetail"
- "MF88Unit_3Story"
- "MF88wHotel"
- "MF117Unit_10Story"

## `README.md` Files
Add README files as needed to any directory if there is specific information to know about models in that directory.
