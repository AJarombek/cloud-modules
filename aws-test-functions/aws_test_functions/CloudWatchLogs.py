"""
Helper functions for testing the existance of AWS Cloudwatch logs.
Author: Andrew Jarombek
Date: 11/27/2020
"""

import unittest

import boto3
from boto3_type_annotations.logs import Client as CloudWatchLogsClient

cloudwatch_logs: CloudWatchLogsClient = boto3.client('logs', region_name='us-east-1')


class CloudWatchLogs:

    @staticmethod
    def cloudwatch_log_group_exists(test_case: unittest.TestCase, log_group_name: str, retention_days: int) -> None:
        """
        Test that an AWS Cloudwatch log group exists.
        :param test_case: Instance of a unittest test case.  This object is used to make assertions.
        :param log_group_name: The name of the Cloudwatch log group.
        :param retention_days: How long the logs are retained.
        """
        log_group_response = cloudwatch_logs.describe_log_groups(logGroupNamePrefix=log_group_name)
        log_groups = log_group_response.get('logGroups')
        test_case.assertEqual(1, len(log_groups))

        log_group = log_groups[0]
        test_case.assertEqual(log_group_name, log_group.get('logGroupName'))
        test_case.assertEqual(retention_days, log_group.get('retentionInDays'))
