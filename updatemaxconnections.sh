#!/bin/bash

# Define the new value for the parameter
NEW_VALUE=500

# Loop through all .conf files in /etc/myapp/
for file in /etc/myapp/*.conf; do
  # Check if the file contains the MaxConnections directive
  if awk '$1 == "MaxConnections"' "$file" > /dev/null; then
    # Use sed to replace the existing value
    sed -i 's/^MaxConnections.*/MaxConnections '"$NEW_VALUE"'/' "$file"
    echo "Updated MaxConnections in $file"
  else
    # If the directive doesn't exist, append it to the end
    echo "MaxConnections $NEW_VALUE" >> "$file"
    echo "Added MaxConnections to $file"
  fi
done