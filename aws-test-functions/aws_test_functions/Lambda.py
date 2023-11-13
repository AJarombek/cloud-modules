"""
Helper functions for AWS Lambda functions.
Author: Andrew Jarombek
Date: 9/19/2020
"""

import unittest

import boto3
from boto3_type_annotations.lambda_ import Client as LambdaClient

from .VPC import VPC
from .SecurityGroup import SecurityGroup

aws_lambda: LambdaClient = boto3.client("lambda", region_name="us-east-1")


class Lambda:
    @staticmethod
    def lambda_function_as_expected(
        test_case: unittest.TestCase,
        function_name: str,
        handler: str,
        state: str = "Active",
        runtime: str = "python3.8",
        memory_size: int = 128,
        timeout: int = 10,
        env_vars: dict = None,
    ) -> None:
        """
        Test that an AWS Lambda function is configured as expected.
        :param test_case: Instance of a unittest test case.  This object is used to make assertions.
        :param function_name: Name of the AWS Lambda function.
        :param handler: Handler method name (entrypoint to the AWS Lambda function).
        :param state: State of the lambda function.
        :param runtime: Runtime (programming language + version) used by the AWS Lambda function.
        :param memory_size: Amount of memory (in MBs) allocated for the AWS Lambda function.
        :param timeout: Maximum execution time for the AWS Lambda function.
        :param env_vars: A dictionary of environment variables created for the AWS Lambda function.
        """
        lambda_function_response = aws_lambda.get_function(FunctionName=function_name)
        lambda_function: dict = lambda_function_response.get("Configuration")

        test_case.assertEqual(function_name, lambda_function.get("FunctionName"))
        test_case.assertEqual(state, lambda_function.get("State"))
        test_case.assertEqual(runtime, lambda_function.get("Runtime"))
        test_case.assertEqual(handler, lambda_function.get("Handler"))
        test_case.assertEqual(memory_size, lambda_function.get("MemorySize"))
        test_case.assertEqual(timeout, lambda_function.get("Timeout"))

        if env_vars is not None:
            test_case.assertDictEqual(
                env_vars, lambda_function.get("Environment").get("Variables")
            )

    @staticmethod
    def lambda_function_in_subnets(function_name: str, subnets: list) -> bool:
        """
        Test that an AWS Lambda function exists in the proper subnets.
        :param function_name: AWS Lambda function name.
        :param subnets: List of subnet names.
        """
        lambda_function = aws_lambda.get_function(FunctionName=function_name)
        lambda_function_subnets: list = (
            lambda_function.get("Configuration").get("VpcConfig").get("SubnetIds")
        )

        proper_subnets = True
        for subnet in subnets:
            subnet_dict = VPC.get_subnet(subnet)
            subnet_id = subnet_dict.get("SubnetId")

            if subnet_id not in lambda_function_subnets:
                proper_subnets = False

        return all([len(lambda_function_subnets) == len(subnets), proper_subnets])

    @staticmethod
    def lambda_function_has_iam_role(function_name: str, role_name: str) -> bool:
        """
        Test that an AWS Lambda function has an IAM role.
        :param function_name: AWS Lambda function name.
        :param role_name: Name of the IAM Role.
        """
        lambda_function = aws_lambda.get_function(FunctionName=function_name)
        lambda_function_iam_role: list = lambda_function.get("Configuration").get(
            "Role"
        )
        return role_name in lambda_function_iam_role

    @staticmethod
    def lambda_function_has_security_group(function_name: str, sg_name: str) -> bool:
        """
        Test that the Lambda function has the expected security group.
        :param function_name: AWS Lambda function name.
        :param sg_name: Name of the security group.
        """
        lambda_function = aws_lambda.get_function(FunctionName=function_name)
        lambda_function_sgs: list = (
            lambda_function.get("Configuration")
            .get("VpcConfig")
            .get("SecurityGroupIds")
        )
        security_group_id = lambda_function_sgs[0]

        sg = SecurityGroup.get_security_group(sg_name)

        return all(
            [len(lambda_function_sgs) == 1, security_group_id == sg.get("GroupId")]
        )
