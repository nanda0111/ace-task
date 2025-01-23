name: Build and Deploy BAR File

on:
  push:
    branches:
      - main    # Trigger on pushes to the 'main' branch
  workflow_dispatch: # Allow manual triggering

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
      # Step 1: Check out the source code
      - name: Checkout Source Code
        uses: actions/checkout@v3

      # Step 2: Set up IBM ACE Toolkit
      - name: Install IBM ACE Toolkit
        run: |
          sudo apt-get update
          sudo apt-get install -y ibm-ace

      # Step 3: Ensure bar-files Directory Exists
      - name: Create bar-files Directory (If Missing)
        run: |
          if [ ! -d "bar-files" ]; then
            echo "Directory 'bar-files' does not exist. Creating it now..."
            mkdir bar-files
          else
            echo "Directory 'bar-files' already exists."
          fi

      # Step 4: Build the BAR File
      - name: Build BAR File
        run: |
          echo "Building BAR file..."
          mqsipackagebar -w . -a bar-files/STAT_LIBproject.generated.bar -k STAT_LIB
        working-directory: ./bar-files

      # Step 5: Commit and Push BAR File to Repository
      - name: Commit and Push BAR File
        run: |
          git config user.name "GitHub Actions"
          git config user.email "nandakishoretherdelly@gmail.com"
          git add bar-files/STAT_LIBproject.generated.bar
          git commit -m "Generated BAR file: STAT_LIBproject.generated.bar"
          git push origin main
        working-directory: ./bar-files

