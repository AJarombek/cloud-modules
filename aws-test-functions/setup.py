"""
Create a Python package for the AWS test functions.
Author: Andrew Jarombek
Date: 11/23/2020
"""

import setuptools

with open("README.md", "r") as fh:
    long_description = fh.read()

setuptools.setup(
    name='aws_test_functions',
    version='0.2.2',
    author='Andrew Jarombek',
    author_email='andrew@jarombek.com',
    description='A Python package containing reusable functions for testing AWS infrastructure',
    long_description=long_description,
    long_description_content_type='text/markdown',
    url='https://github.com/AJarombek/cloud-modules/aws-test-functions',
    packages=setuptools.find_packages(include=['aws_test_functions', 'aws_test_functions.*']),
    classifiers=[],
    python_requires='>=3.8'
)
