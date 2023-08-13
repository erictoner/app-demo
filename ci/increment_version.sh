#!/bin/bash
#
# Version Incrementing Script
# This script updates version-related values in Helm charts,
# commits changes, and tags the latest git commit.
#
# Usage:
#   1. Ensure you have execute permission: chmod +x version_bump.sh
#   2. Run the script: ./version_bump.sh
#

# Get the current version from git
current_version=$(git describe --tags --abbrev=0)

echo "Current version: $current_version"

# Calculate the new version
new_version=$(echo $current_version | awk -F. -v OFS=. '{++$3; print}')

echo "Old version: $current_version"
echo "New version: $new_version"

# Prompt user for bumping version
read -p "Do you want to bump to version $new_version? (y/n): " choice

if [[ $choice =~ ^[Yy]$ ]]; then
    # Store a flag to check if any file was modified
    files_changed=false

    # Update Chart.yaml and values.yaml
    if sed -i '' -e "s/version: $current_version/version: $new_version/" helm/Chart.yaml &&
       sed -i '' -e "s/appVersion: $current_version/appVersion: $new_version/" helm/Chart.yaml &&
       sed -i '' -e "s/imageTag: $current_version/imageTag: $new_version/" helm/values.yaml; then
        echo "Updated helm/Chart.yaml and helm/values.yaml"

        # Commit changes
        git add helm/Chart.yaml helm/values.yaml
        git commit -m "Bump version to $new_version"

        # Tag in Git
        git tag $new_version

        echo "Version bumped to $new_version, files updated, and tagged."
    else
        echo "Error updating files."
    fi
else
    echo "Manual version bumping is required."
fi
