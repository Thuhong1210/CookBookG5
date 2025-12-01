#!/bin/bash
# Script to setup Python 3.10 environment and run MyCookBook app

# Check if python3.10 is installed
if ! command -v python3.10 &>/dev/null; then
    echo "Python 3.10 not found, please install Python 3.10 before running this script."
    exit 1
fi

# Create virtual environment
python3.10 -m venv venv

# Activate virtual environment
source venv/bin/activate

# Upgrade pip
pip install --upgrade pip

# Install requirements
pip install -r backend/requirements.txt

# Run the Flask app
python backend/run_app.py
