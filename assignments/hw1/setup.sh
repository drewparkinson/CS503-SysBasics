#!/bin/bash
# ============================================================================
# CS 503 — HW1: Unix Fundamentals
# Setup Script
#
# This script generates the assignment workspace. Run it on Tux after cloning
# your GitHub Classroom repository:
#
#   cd ~/hw1
#   ./setup.sh
#
# The script is idempotent — you can re-run it to reset the workspace to its
# original state. WARNING: Re-running will overwrite any work in progress.
# ============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "============================================"
echo "  CS 503 — HW1 Setup"
echo "============================================"
echo ""

# ============================================================================
# Part 1: Filesystem Navigation and File Management
# ============================================================================
echo "[Part 1] Setting up the messy project directory..."

# Clean up any previous run
rm -rf part1/project

mkdir -p part1/project/stuff
mkdir -p part1/project/old

# --- Files in stuff/ ---
cat > part1/project/stuff/model_v2.pt << 'MODELEOF'
# PyTorch Model Checkpoint (simulated binary)
# model: ResNet-50 fine-tuned
# epoch: 47
# val_accuracy: 0.9234
# optimizer: AdamW lr=0.0003
# This is a placeholder — real .pt files are binary.
MODELEOF

cat > part1/project/stuff/notes.txt << 'NOTESEOF'
Project Notes
=============

2024-01-10: Started fine-tuning ResNet-50 on the sensor classification task.
            Using AdamW with lr=3e-4, batch size 64.

2024-01-12: First results look promising. Val accuracy 87% after 10 epochs.
            Need to try data augmentation.

2024-01-15: Added random rotation and horizontal flip. Val accuracy up to 91%.

2024-01-18: Switched to cosine annealing LR schedule. Slight improvement.

2024-01-20: Best run so far: 92.3% val accuracy at epoch 47.
            Saved as model_v2.pt.

TODO:
- Try learning rate warmup
- Experiment with larger batch sizes
- Clean up this project directory (it's a mess)
NOTESEOF

cat > part1/project/stuff/train.py << 'TRAINEOF'
#!/usr/bin/env python3
"""Training script for sensor classification model."""

import argparse
import sys

def parse_args():
    parser = argparse.ArgumentParser(description="Train the model")
    parser.add_argument("--epochs", type=int, default=50)
    parser.add_argument("--lr", type=float, default=3e-4)
    parser.add_argument("--batch-size", type=int, default=64)
    parser.add_argument("--data-dir", type=str, default="./data")
    parser.add_argument("--output-dir", type=str, default="./models")
    return parser.parse_args()

def main():
    args = parse_args()
    print(f"Training for {args.epochs} epochs with lr={args.lr}")
    print(f"Data directory: {args.data_dir}")
    print(f"Output directory: {args.output_dir}")
    # ... training logic would go here ...
    print("Training complete.")

if __name__ == "__main__":
    main()
TRAINEOF

cat > part1/project/stuff/dataset_README.md << 'READMEEOF'
# Sensor Classification Dataset

## Overview
This dataset contains labeled sensor readings for a classification task.
Three CSV files are provided: training, validation, and test splits.

## Format
Each CSV file has the following columns:
- `id` — Unique identifier for the reading
- `timestamp` — ISO 8601 timestamp
- `sensor_id` — Identifier for the sensor
- `reading` — Numeric sensor value
- `unit` — Unit of measurement
- `status` — One of: ok, warn, error, missing

## Splits
- `train.csv` — 35,000 samples (70%)
- `val.csv` — 7,500 samples (15%)
- `test.csv` — 7,500 samples (15%)

## Citation
If you use this dataset, please cite: [internal project, no citation needed]
READMEEOF

cat > part1/project/stuff/config_final_FINAL_v3.yaml << 'CONFIGEOF'
# Experiment Configuration — v3 (final)
model:
  architecture: resnet50
  pretrained: true
  num_classes: 6

training:
  epochs: 50
  batch_size: 64
  learning_rate: 0.0003
  optimizer: adamw
  weight_decay: 0.01
  scheduler: cosine_annealing

data:
  train_path: ./data/train.csv
  val_path: ./data/val.csv
  test_path: ./data/test.csv
  augmentation:
    random_rotation: 15
    horizontal_flip: true

output:
  model_dir: ./models
  log_dir: ./logs
CONFIGEOF

# --- Files in old/ ---
cat > part1/project/old/train_old.py << 'OLDTRAINEOF'
#!/usr/bin/env python3
"""Old training script — replaced by the version in stuff/."""

import sys
print("This is the old training script. It has been superseded.")
print("Use train.py (in stuff/) instead.")
sys.exit(1)
OLDTRAINEOF

cat > part1/project/old/model_v1.pt << 'OLDMODELEOF'
# PyTorch Model Checkpoint (simulated binary)
# model: ResNet-50 baseline
# epoch: 30
# val_accuracy: 0.8701
# optimizer: SGD lr=0.01
# Note: Superseded by model_v2.pt
OLDMODELEOF

cat > part1/project/old/eval_old.py << 'OLDEVALEOF'
#!/usr/bin/env python3
"""Old evaluation script — replaced by eval.py in the project root."""

import sys
print("This is the old evaluation script.")
print("Use eval.py in the project root instead.")
sys.exit(1)
OLDEVALEOF

# --- Files in project root ---
cat > part1/project/eval.py << 'EVALEOF'
#!/usr/bin/env python3
"""Evaluation script for sensor classification model."""

import argparse

def parse_args():
    parser = argparse.ArgumentParser(description="Evaluate the model")
    parser.add_argument("--model", type=str, required=True)
    parser.add_argument("--data", type=str, required=True)
    parser.add_argument("--output", type=str, default="results.json")
    return parser.parse_args()

def main():
    args = parse_args()
    print(f"Evaluating model: {args.model}")
    print(f"Test data: {args.data}")
    # ... evaluation logic would go here ...
    print(f"Results written to {args.output}")

if __name__ == "__main__":
    main()
EVALEOF

cat > part1/project/preprocess.py << 'PREPROCEOF'
#!/usr/bin/env python3
"""Preprocessing script for sensor data."""

import argparse
import csv
import sys

def parse_args():
    parser = argparse.ArgumentParser(description="Preprocess sensor data")
    parser.add_argument("input_file", help="Input CSV file")
    parser.add_argument("-o", "--output", help="Output file", default="processed.csv")
    parser.add_argument("--normalize", action="store_true", help="Normalize readings")
    parser.add_argument("--drop-missing", action="store_true", help="Remove missing values")
    return parser.parse_args()

def main():
    args = parse_args()
    print(f"Preprocessing: {args.input_file}")
    if args.normalize:
        print("  Normalizing readings...")
    if args.drop_missing:
        print("  Dropping rows with missing values...")
    print(f"  Output: {args.output}")
    print("Preprocessing complete.")

if __name__ == "__main__":
    main()
PREPROCEOF

cat > part1/project/requirements.txt << 'REQEOF'
torch>=2.0.0
torchvision>=0.15.0
numpy>=1.24.0
pandas>=2.0.0
scikit-learn>=1.2.0
matplotlib>=3.7.0
pyyaml>=6.0
tqdm>=4.65.0
REQEOF

# Data files with small amounts of realistic CSV content
cat > part1/project/data_train.csv << 'DTRAINEOF'
id,timestamp,sensor_id,reading,unit,status
1,2024-01-15T08:00:01,temp_01,22.5,celsius,ok
2,2024-01-15T08:00:02,humidity_01,45.2,percent,ok
3,2024-01-15T08:00:03,pressure_01,1013.25,hPa,ok
4,2024-01-15T08:00:04,temp_02,23.1,celsius,ok
5,2024-01-15T08:00:05,humidity_02,44.8,percent,warn
DTRAINEOF

cat > part1/project/data_test.csv << 'DTESTEOF'
id,timestamp,sensor_id,reading,unit,status
1,2024-01-20T12:00:01,temp_01,21.8,celsius,ok
2,2024-01-20T12:00:02,humidity_01,50.1,percent,ok
3,2024-01-20T12:00:03,pressure_01,1015.00,hPa,ok
DTESTEOF

cat > part1/project/data_val.csv << 'DVALEOF'
id,timestamp,sensor_id,reading,unit,status
1,2024-01-18T10:00:01,temp_01,22.0,celsius,ok
2,2024-01-18T10:00:02,humidity_01,47.5,percent,ok
3,2024-01-18T10:00:03,pressure_01,1012.80,hPa,warn
DVALEOF

cat > part1/project/random_junk.tmp << 'JUNKEOF'
asdkjhqwekjh1298371982
tmp file from some crashed process
DELETE ME
qwpoeiurpoqiuw
JUNKEOF

echo "  Created messy project directory at part1/project/"

# ============================================================================
# Part 2: File Permissions
# ============================================================================
echo "[Part 2] Setting up permission exercise files..."

# Preserve student's answers.txt if it exists before resetting
if [ -f part2/answers.txt ]; then
    cp part2/answers.txt /tmp/hw1_part2_answers_backup_$$ 2>/dev/null
fi

rm -rf part2
mkdir -p part2

# Restore answers.txt if we saved it
if [ -f /tmp/hw1_part2_answers_backup_$$ ]; then
    mv /tmp/hw1_part2_answers_backup_$$ part2/answers.txt
fi

# Create files with intentionally WRONG permissions.
# Students must read PERMISSIONS.txt and fix them.

# --- deploy.sh: a deployment script ---
cat > part2/deploy.sh << 'DEPLOYEOF'
#!/bin/bash
# Deployment script — should be executable by owner and group
echo "Deploying application..."
echo "Copying files to production server..."
echo "Restarting services..."
echo "Deployment complete."
DEPLOYEOF
# WRONG: world-writable and world-executable (security risk)
chmod 777 part2/deploy.sh

# --- database_backup.sh: a backup script ---
cat > part2/database_backup.sh << 'BACKUPEOF'
#!/bin/bash
# Database backup script — contains connection credentials
DB_HOST="db.internal.example.com"
DB_USER="backup_admin"
DB_PASS="s3cur3_p4ssw0rd_d0_n0t_sh4r3"
echo "Backing up database at $DB_HOST..."
echo "Backup complete."
BACKUPEOF
# WRONG: readable by everyone (exposes credentials)
chmod 644 part2/database_backup.sh

# --- api_keys.conf: configuration with secrets ---
cat > part2/api_keys.conf << 'APIEOF'
# API Configuration — CONFIDENTIAL
AWS_ACCESS_KEY=AKIAIOSFODNN7EXAMPLE
AWS_SECRET_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
OPENAI_API_KEY=sk-example1234567890abcdefghijklmnop
STRIPE_SECRET=sk_test_example1234567890
APIEOF
# WRONG: world-readable (anyone can see the keys)
chmod 666 part2/api_keys.conf

# --- shared_data.csv: data file for a team ---
cat > part2/shared_data.csv << 'SHAREDEOF'
id,name,value,status
1,sensor_alpha,42.5,active
2,sensor_beta,38.1,active
3,sensor_gamma,0.0,inactive
4,sensor_delta,55.9,active
SHAREDEOF
# WRONG: not readable by group (team can't access shared data)
chmod 600 part2/shared_data.csv

# --- report_generator.py: a script that produces reports ---
cat > part2/report_generator.py << 'REPORTEOF'
#!/usr/bin/env python3
"""Generates weekly status reports from sensor data."""

def generate_report(data_file, output_file):
    print(f"Reading data from {data_file}")
    print(f"Generating report...")
    print(f"Report written to {output_file}")

if __name__ == "__main__":
    generate_report("shared_data.csv", "weekly_report.txt")
REPORTEOF
# WRONG: not executable (can't run it), and world-writable
chmod 646 part2/report_generator.py

# --- experiment_log.txt: a read-only lab notebook ---
cat > part2/experiment_log.txt << 'LOGEOF'
Experiment Log — DO NOT MODIFY
================================
2024-01-10 14:30  Started experiment run #47
2024-01-10 14:35  Parameters: lr=0.001, epochs=100, batch=32
2024-01-10 16:22  Run complete. Val accuracy: 91.2%
2024-01-10 16:25  Notes: Best result so far. Do not overwrite.
2024-01-11 09:00  Started experiment run #48
2024-01-11 09:05  Parameters: lr=0.0003, epochs=100, batch=64
2024-01-11 11:15  Run complete. Val accuracy: 92.3%
2024-01-11 11:20  Notes: New best. Saved as model_v2.pt.
LOGEOF
# WRONG: writable by everyone (lab notebook should be read-only)
chmod 666 part2/experiment_log.txt

# --- project_dir/: a directory with wrong permissions ---
mkdir -p part2/project_dir
echo "This directory contains project files." > part2/project_dir/info.txt
# WRONG: not executable by group/others (can't cd into it)
chmod 744 part2/project_dir

# --- run_tests.sh: a test runner ---
cat > part2/run_tests.sh << 'TESTEOF'
#!/bin/bash
# Test runner — should be executable by everyone
echo "Running test suite..."
echo "  test_data_loading... PASSED"
echo "  test_preprocessing... PASSED"
echo "  test_model_forward... PASSED"
echo "  test_evaluation... PASSED"
echo "All tests passed."
TESTEOF
# WRONG: not executable by anyone
chmod 644 part2/run_tests.sh

# --- Create the PERMISSIONS.txt specification ---
cat > part2/PERMISSIONS.txt << 'PERMEOF'
# CS 503 — HW1 Part 2: File Permissions Specification
#
# Each file below has INCORRECT permissions. Fix them using chmod
# so they match the specification listed here.
#
# The permissions are given in symbolic notation: rwxrwxrwx
# (owner, group, others). A dash (-) means that permission is not set.
#
# Think about WHY each permission setting makes sense for the
# type of file described.
# ====================================================================

deploy.sh
  Description: Deployment script. Owner and group need to run it.
               Others should not have any access.
  Correct:     rwxr-x---

database_backup.sh
  Description: Backup script containing database credentials.
               Only the owner should be able to read or execute it.
               Nobody else should have any access at all.
  Correct:     rwx------

api_keys.conf
  Description: Configuration file with API secrets.
               Only the owner should be able to read and write it.
               No access for group or others.
  Correct:     rw-------

shared_data.csv
  Description: Data file shared with a project team.
               Owner can read and write. Group can read.
               Others have no access.
  Correct:     rw-r-----

report_generator.py
  Description: Python script that team members run to generate reports.
               Owner can read, write, and execute.
               Group can read and execute.
               Others have no access.
  Correct:     rwxr-x---

experiment_log.txt
  Description: Read-only experiment log. Nobody should modify it.
               Owner, group, and others can read.
               Nobody can write or execute.
  Correct:     r--r--r--

project_dir/
  Description: Project directory. Owner has full access.
               Group can enter and list contents, but not create files.
               Others have no access.
  Correct:     rwxr-x---

run_tests.sh
  Description: Test runner script. Everyone on the system should be
               able to read and execute it. Only the owner can modify it.
  Correct:     rwxr-xr-x
PERMEOF

# --- Create answers.txt template for students ---
if [ ! -f part2/answers.txt ]; then
    cat > part2/answers.txt << 'ANSWERSEOF'
# CS 503 — HW1 Part 2: File Permissions
#
# SECTION A: chmod Commands
# For each file, write the exact chmod command you used to fix its
# permissions. One command per file.
#
# Example:
#   some_file.txt: chmod 644 some_file.txt
# ====================================================================

deploy.sh:

database_backup.sh:

api_keys.conf:

shared_data.csv:

report_generator.py:

experiment_log.txt:

project_dir/:

run_tests.sh:


# ====================================================================
# SECTION B: Conceptual Questions
# Answer each question in a few sentences.
# ====================================================================

# Q2a. A file has permissions rw-r----- and is owned by user alice and
# group mlteam. Can user bob, who is a member of mlteam, execute the
# file? Can he read it?

Q2a:


# Q2b. You run ls -l and see -rwxrwxrwx on a file containing your API
# keys. Explain why this is a problem and what permissions you would
# set instead. Give the chmod command you would use.

Q2b:


# Q2c. A directory has permissions rwxr-xr-x. You are not the owner
# and not in the group. Can you list the directory's contents? Can you
# create a new file inside it? Explain why or why not.

Q2c:


# Q2d. What is the difference between chmod 755 and chmod u=rwx,go=rx?

Q2d:

ANSWERSEOF
    echo "  Created part2/answers.txt template"
else
    echo "  part2/answers.txt already exists — not overwriting"
fi

echo "  Created permission exercise files at part2/"

# ============================================================================
# Part 3: Pipes and Text Processing — Generate server_log.csv
# ============================================================================
echo "[Part 3] Generating server_log.csv (50,000 lines)..."

mkdir -p part3

# Generate a deterministic 50,000-line server log using awk.
# We use a seeded PRNG so every student gets the same data and answers
# are consistent for grading.

awk 'BEGIN {
    srand(503)

    # --- Data pools ---
    split("192.168.1.105,192.168.1.110,192.168.1.115,10.0.0.50,10.0.0.51,10.0.0.52,172.16.0.10,172.16.0.11,172.16.0.12,172.16.0.13,203.0.113.5,203.0.113.12,198.51.100.7,198.51.100.22,192.0.2.100", ips, ",")
    num_ips = 15

    split("GET,GET,GET,GET,GET,POST,POST,POST,PUT,DELETE", methods, ",")
    num_methods = 10

    split("/api/predict,/api/predict,/api/predict,/api/train,/api/evaluate,/api/data/upload,/api/data/download,/api/models/list,/api/models/deploy,/health,/health,/status,/docs,/api/users/me,/api/config", endpoints, ",")
    num_endpoints = 15

    split("python-requests/2.28.1,python-requests/2.31.0,curl/7.81.0,curl/7.88.1,Mozilla/5.0,Mozilla/5.0,PostmanRuntime/7.32.3,HTTPie/3.2.1,Go-http-client/2.0,Java/11.0.19", agents, ",")
    num_agents = 10

    # Weighted status codes: mostly 200, some errors
    split("200,200,200,200,200,200,200,200,201,201,204,301,304,400,400,401,403,404,404,404,500,500,502,503", statuses, ",")
    num_statuses = 24

    # Date range: 2024-01-01 through 2024-01-31
    # We will cycle through days
    num_days = 31

    # Print header
    print "timestamp,ip_address,method,endpoint,status_code,response_time_ms,user_agent"

    for (i = 1; i <= 50000; i++) {
        # Date: distribute across January 2024
        day = int(rand() * num_days) + 1
        hour = int(rand() * 24)
        minute = int(rand() * 60)
        second = int(rand() * 60)

        timestamp = sprintf("2024-01-%02dT%02d:%02d:%02d", day, hour, minute, second)

        # Pick from pools
        ip = ips[int(rand() * num_ips) + 1]
        method = methods[int(rand() * num_methods) + 1]
        endpoint = endpoints[int(rand() * num_endpoints) + 1]
        status = statuses[int(rand() * num_statuses) + 1]
        agent = agents[int(rand() * num_agents) + 1]

        # Response time depends on endpoint and status
        if (endpoint == "/health" || endpoint == "/status") {
            base_rt = 5 + int(rand() * 30)
        } else if (endpoint == "/api/train") {
            base_rt = 5000 + int(rand() * 55000)
        } else if (endpoint == "/api/data/upload" || endpoint == "/api/data/download") {
            base_rt = 200 + int(rand() * 4800)
        } else {
            base_rt = 20 + int(rand() * 480)
        }

        # Errors tend to have different response times
        if (status + 0 >= 500) {
            base_rt = base_rt + int(rand() * 10000)
        } else if (status + 0 == 404) {
            base_rt = 2 + int(rand() * 15)
        }

        printf "%s,%s,%s,%s,%s,%d,%s\n", timestamp, ip, method, endpoint, status, base_rt, agent
    }
}' > part3/server_log.csv

# Verify line count
lines=$(wc -l < part3/server_log.csv)
data_lines=$((lines - 1))
echo "  Generated part3/server_log.csv ($data_lines data lines + 1 header)"

# Create empty answers file for students
if [ ! -f part3/answers.txt ]; then
    cat > part3/answers.txt << 'ANSWERSEOF'
# CS 503 — HW1 Part 3: Pipes and Text Processing
# Write your answers below in the specified format.
# For each question, provide your pipeline command and the output.
#
# Format:
#   Q1:
#   COMMAND: <your pipeline here>
#   ANSWER: <the output>

Q1:
COMMAND:
ANSWER:

Q2:
COMMAND:
ANSWER:

Q3:
COMMAND:
ANSWER:

Q4:
COMMAND:
ANSWER:

Q5:
COMMAND:
ANSWER:

Q6:
COMMAND:
ANSWER:

Q7:
COMMAND:
ANSWER:

Q8:
COMMAND:
ANSWER:

Q9:
COMMAND:
ANSWER:

Q10:
COMMAND:
ANSWER:

Q11:
COMMAND:
ANSWER:
ANSWERSEOF
    echo "  Created part3/answers.txt template"
else
    echo "  part3/answers.txt already exists — not overwriting"
fi

# ============================================================================
# Done
# ============================================================================
echo ""
echo "============================================"
echo "  Setup complete!"
echo "============================================"
echo ""
echo "Your workspace is ready. Here is what was created:"
echo ""
echo "  part1/project/   — Messy directory to reorganize"
echo "  part2/           — Files with wrong permissions (read PERMISSIONS.txt)"
echo "  part3/           — server_log.csv and answers.txt template"
echo ""
echo "Remember:"
echo "  - Read part2/PERMISSIONS.txt before fixing permissions"
echo "  - Write your chmod commands in part2/answers.txt"
echo "  - Write your pipeline commands in part3/answers.txt"
echo "  - You can re-run this script to reset, but it WILL overwrite your work"
echo "    (answers.txt files are preserved across re-runs)"
echo ""
