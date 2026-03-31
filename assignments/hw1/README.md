### Overview

This assignment builds fluency with the Unix command line through structured practice. You will navigate the filesystem, manage files and permissions, and use pipes and text processing tools to extract information from data files. Everything is done on Tux via SSH.

### Setup

Accept the HW1 assignment on GitHub Classroom (link on Blackboard) and clone the repository to Tux. Then run the setup script:

```bash
cd CS503-SysBasics/assignments/hw1
chmod +x setup.sh
./setup.sh
```

The script "setup.sh" generates the assignment workspace inside your repo: the messy directory structure for Part 1, files with intentionally incorrect permissions for Part 2, and the 50,000-line data file for Part 3. **You must run this on Tux** — the setup script sets Unix-specific file permissions that don't exist on Windows or macOS.

Do all of your work inside this directory. The setup script is idempotent — you can re-run it to reset the workspace to its original state if needed (this will overwrite any work in progress, so be careful).

### Part 1: Filesystem Navigation and File Management (25 points)

A directory tree has been created at `CS503-SysBasics/assignments/hw1/part1/project/`. It simulates a disorganized project directory. Your job is to reorganize it according to the specification below, using **only command-line tools** (no graphical file managers, no scripts).

**The current structure looks like this:**

```
project/
├── stuff/
│   ├── model_v2.pt
│   ├── notes.txt
│   ├── train.py
│   ├── dataset_README.md
│   └── config_final_FINAL_v3.yaml
├── old/
│   ├── train_old.py
│   ├── model_v1.pt
│   └── eval_old.py
├── data_train.csv
├── data_test.csv
├── data_val.csv
├── eval.py
├── preprocess.py
├── requirements.txt
└── random_junk.tmp
```

**Reorganize it into this structure:**

```
project/
├── src/
│   ├── train.py
│   ├── eval.py
│   └── preprocess.py
├── config/
│   └── config.yaml
├── data/
│   ├── train.csv
│   ├── test.csv
│   ├── val.csv
│   └── README.md
├── models/
│   ├── model_v1.pt
│   └── model_v2.pt
├── archive/
│   ├── train_old.py
│   └── eval_old.py
├── requirements.txt
└── notes.txt
```

**Requirements:**

1. Files must be **moved**, not copied (the originals should no longer exist in their old locations).
2. Files must be **renamed** as shown (e.g., `config_final_FINAL_v3.yaml` → `config.yaml`, `data_train.csv` → `train.csv`, `dataset_README.md` → `README.md`).
3. The `stuff/` and `old/` directories should be removed after their contents have been relocated.
4. `random_junk.tmp` should be deleted.
5. The empty directories (`stuff/`, `old/`) should not remain.

**Grading:**

- Correct final structure with all files in the right locations: 17 points
- Files properly renamed: 5 points
- Old directories and junk files removed: 3 points


### Part 2: File Permissions (20 points)

A set of files has been created at `CS503-SysBasics/assignments/hw1/part2/`. Each file has incorrect permissions. A specification file at `hw1/part2/PERMISSIONS.txt` describes what the permissions **should** be. An `answers.txt` template is provided for your responses.

**Tasks:**

1. Read `PERMISSIONS.txt` and fix the permissions on every file listed using `chmod`. The specification uses symbolic notation (e.g., `rwxr-x---`). In **Section A** of `answers.txt`, record the exact `chmod` command you used for each file. (10 points)

2. Answer the following conceptual questions in **Section B** of `answers.txt`:

   a. A file has permissions `rw-r-----` and is owned by user `alice` and group `mlteam`. Can user `bob`, who is a member of `mlteam`, execute the file? Can he read it? (2 points)

   b. You run `ls -l` and see `-rwxrwxrwx` on a file containing your API keys. Explain why this is a problem and what permissions you would set instead. Give the `chmod` command you would use. (3 points)

   c. A directory has permissions `rwxr-xr-x`. You are not the owner and not in the group. Can you list the directory's contents? Can you create a new file inside it? Explain why or why not. (3 points)

   d. What is the difference between `chmod 755` and `chmod u=rwx,go=rx`? (2 points)


### Part 3: Pipes and Text Processing (55 points)

A data file has been placed at `~/hw1/part3/server_log.csv`. This file contains 50,000 lines of simulated server access logs with the following columns (comma-separated):

```
timestamp,ip_address,method,endpoint,status_code,response_time_ms,user_agent
```

Example lines:
```
2024-01-15T08:23:41,192.168.1.105,GET,/api/predict,200,145,python-requests/2.28.1
2024-01-15T08:23:42,10.0.0.50,POST,/api/train,500,30250,curl/7.81.0
2024-01-15T08:23:44,192.168.1.105,GET,/health,200,12,Mozilla/5.0
```

**For each task below**, write the **single pipeline command** (one line, using pipes) that produces the answer. Write both the command and its output in `~/hw1/part3/answers.txt` in this format:

```
Q1:
COMMAND: <your pipeline here>
ANSWER: <the output>

Q2:
COMMAND: <your pipeline here>
ANSWER: <the output>
```

You will be graded on **both the correctness of the answer and the correctness/efficiency of the pipeline.** There is often more than one correct pipeline; any reasonable approach is fine.

**Questions:**

1. How many total requests are in the log? (Do not count the header line.) (3 points)

2. How many unique IP addresses made requests? (3 points)

3. What are the 5 most frequently accessed endpoints? Show each endpoint and its count, sorted by frequency (most frequent first). (5 points)

4. How many requests resulted in a server error (status codes 500–599)? (4 points)

5. What is the average response time (in milliseconds) for requests to the `/api/predict` endpoint? You may use `awk` for arithmetic. (5 points)

6. Which IP address made the most requests? Show the IP and the count. (4 points)

7. How many POST requests were made between 12:00:00 and 13:00:00 (any date)? (5 points)

8. List all unique user agents that made requests resulting in a 404 status code, sorted alphabetically. (5 points)

9. For each HTTP method (GET, POST, PUT, DELETE), show the method and the count of requests with that method, sorted by count descending. (5 points)

10. Find the 10 slowest requests (highest response time). For each, show the timestamp, endpoint, and response time. Sort by response time descending. (6 points)

11. Which endpoint has the highest rate of server errors (500–599)? Show the endpoint, the number of errors, the total requests to that endpoint, and the error rate as a percentage. This may require multiple commands composed together or a more complex `awk` script. (10 points)


### Submission

Push your completed work to your HW1 GitHub Classroom repository. The grading scripts expect this structure:

```
hw1/
├── setup.sh             (provided — do not modify)
├── part1/
│   └── project/         (reorganized directory)
├── part2/
│   ├── (permission-fixed files)
│   ├── PERMISSIONS.txt  (provided — do not modify)
│   └── answers.txt      (your chmod commands and question answers)
└── part3/
    └── answers.txt      (your pipeline commands and output)
```

**Note on permissions:** Git has limited support for Unix file permissions. The grading script will re-run `./setup.sh` to regenerate the permission exercise files and then replay the `chmod` commands you listed in `part2/answers.txt` to verify correctness. Make sure the commands you list are exact and complete.