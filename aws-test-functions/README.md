### Overview

A Python package containing reusable functions for testing AWS infrastructure.  These functions utilize `boto3` 
(an AWS SDK) and `unittest`.

### Commands

To update the lockfile with Pipfile dependencies, execute the following command:

```bash
pipenv install
```

To format the code, execute the following commands:

```bash
pipenv shell
black .

# To check the formatting without modifying the code
black --check .
```

### Files

| Filename             | Description                                                                                  |
|----------------------|----------------------------------------------------------------------------------------------|
| `src`                | Source code for the `aws_test_functions` Python package.                                     |
| `Pipfile`            | Used to install dependencies and create a virtual environment with `pip`.                    |
| `requirements.txt`   | Used to install dependencies and create a virtual environment with `pipenv`.                 |
| `setup.py`           | Build script to create a Python package.                                                     |

### Resources

1. [Packaging Python Projects](https://packaging.python.org/tutorials/packaging-projects/)