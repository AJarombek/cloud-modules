"""
Helper functions for AWS API Gateway tests.
Author: Andrew Jarombek
Date: 11/22/2020
"""

import unittest
from typing import List, Optional

import boto3
from boto3_type_annotations.apigateway import Client as APIGatewayClient

apigateway: APIGatewayClient = boto3.client('apigateway', region_name='us-east-1')


class APIGateway:

    @staticmethod
    def rest_api_exists(test_case: unittest.TestCase, api_name: str) -> str:
        """
        Test that an AWS API Gateway REST API exists.
        :param test_case: Instance of a unittest test case.  This object is used to make assertions.
        :param api_name: The name of the REST API.
        :return: The REST API's id.
        """
        apis: dict = apigateway.get_rest_apis()
        api_list: List[dict] = apis.get('items')
        matching_apis = [api for api in api_list if api.get('name') == api_name]
        test_case.assertEqual(1, len(matching_apis))

        return matching_apis[0].get('id')

    @staticmethod
    def deployment_exists(test_case: unittest.TestCase, api_name: str, api_id: str = None) -> str:
        """
        Test that a deployment of an AWS API Gateway REST API exists.
        :param test_case: Instance of a unittest test case.  This object is used to make assertions.
        :param api_name: The name of the REST API.
        :param api_id: An optional API id for the REST API.
        :return: The REST API deployment's id.
        """
        if not api_id:
            api_id = APIGateway.rest_api_exists(test_case, api_name)

        deployments = apigateway.get_deployments(restApiId=api_id)
        deployment_list: List[dict] = deployments.get('items')
        test_case.assertGreaterEqual(len(deployment_list), 1)

        deployment_list.sort(reverse=True, key=lambda deployment: deployment.get('createdDate'))

        return deployment_list[0].get('id')

    @staticmethod
    def stage_exists(test_case: unittest.TestCase, api_name: str, stage_name: str) -> None:
        """
        Test that a deployment of an AWS API Gateway REST API exists.
        :param test_case: Instance of a unittest test case.  This object is used to make assertions.
        :param api_name: The name of the REST API.
        :param stage_name: Name of the stage (which is a reference to a deployment) for a REST API.
        """
        api_id = APIGateway.rest_api_exists(test_case, api_name)
        deployment_id = APIGateway.deployment_exists(test_case, api_name, api_id)

        stages = apigateway.get_stages(restApiId=api_id, deploymentId=deployment_id)
        stage_list: List[dict] = stages.get('item')
        matching_stages = [stage for stage in stage_list if stage.get('stageName') == stage_name]
        test_case.assertEqual(1, len(matching_stages))

    @staticmethod
    def api_has_expected_paths(test_case: unittest.TestCase, api_name: str, expected_paths: List[str]) -> List[str]:
        """
        Test that an AWS API Gateway REST API has certain paths.
        :param test_case: Instance of a unittest test case.  This object is used to make assertions.
        :param api_name: The name of the REST API.
        :param expected_paths: List of paths which should exist in the API.
        :return: The paths found in the API Gateway REST API.
        """
        api_id = APIGateway.rest_api_exists(test_case, api_name)
        resources = apigateway.get_resources(restApiId=api_id)
        paths = [path.get('path') for path in resources.get('items')]
        paths.sort()
        test_case.assertListEqual(expected_paths, paths)
        return paths

    @staticmethod
    def get_api_resource(test_case: unittest.TestCase, api_name: str, resource_path: str) -> Optional[str]:
        """
        Get the ID for a resource in an API Gateway REST API.
        :param test_case: Instance of a unittest test case.  This object is used to make assertions.
        :param api_name: The name of the REST API.
        :param resource_path: The path of the resource (endpoint).
        :return: The ID of the resource if it exists, None otherwise.
        """
        api_id = APIGateway.rest_api_exists(test_case, api_name)
        resources = apigateway.get_resources(restApiId=api_id)
        paths: List[dict] = [path for path in resources.get('items') if path.get('path') == resource_path]

        if len(paths) > 0:
            return paths[0].get('id')
        else:
            return None

    @staticmethod
    def api_endpoint_as_expected(test_case: unittest.TestCase, api_name: str, path: str, validator_name: str,
                                 lambda_function_name: str, http_method: str = 'POST', authorization_type: str = 'NONE',
                                 validate_request_body: bool = False, validate_request_parameters: bool = False,
                                 method_status_code: str = '200', integration_status_code: str = '200',
                                 integration_type: str = 'AWS') -> None:
        """
        Test an endpoint in an API Gateway REST API.
        :param test_case: Instance of a unittest test case.  This object is used to make assertions.
        :param api_name: The name of the REST API.
        :param path: REST API endpoint path.
        :param validator_name: Name of the validator for the endpoint.
        :param lambda_function_name: Name of the AWS Lambda function that the endpoint invokes.
        :param http_method: HTTP method of the endpoint.
        :param authorization_type: Authorization type of the endpoint.
        :param validate_request_body: Whether the HTTP request body is validated.
        :param validate_request_parameters: Whether the HTTP request parameters are validated.
        :param method_status_code: HTTP status code of the method.
        :param integration_status_code: HTTP status code of the integration.
        :param integration_type: Integration type for the endpoint.
        """
        api_id = APIGateway.rest_api_exists(test_case, api_name)
        resource_id = APIGateway.get_api_resource(test_case, api_name, path)
        test_case.assertIsNotNone(resource_id)

        method = apigateway.get_method(restApiId=api_id, resourceId=resource_id, httpMethod=http_method)
        test_case.assertEqual(http_method, method.get('httpMethod'))
        test_case.assertEqual(authorization_type, method.get('authorizationType'))

        request_validators = apigateway.get_request_validators(restApiId=api_id)
        validator = [validator for validator in request_validators.get('items') if
                     validator.get('name') == validator_name][0]
        test_case.assertIsNotNone(validator)
        test_case.assertEqual(validate_request_body, validator.get('validateRequestBody'))
        test_case.assertEqual(validate_request_parameters, validator.get('validateRequestParameters'))

        method_response = apigateway.get_method_response(
            restApiId=api_id,
            resourceId=resource_id,
            httpMethod=http_method,
            statusCode=method_status_code
        )
        test_case.assertEqual(method_status_code, method_response.get('statusCode'))

        integration = apigateway.get_integration(restApiId=api_id, resourceId=resource_id, httpMethod='POST')
        test_case.assertEqual('POST', integration.get('httpMethod'))
        test_case.assertEqual(integration_type, integration.get('type'))

        integration_response = apigateway.get_integration_response(
            restApiId=api_id,
            resourceId=resource_id,
            httpMethod='POST',
            statusCode=integration_status_code
        )
        test_case.assertEqual(integration_status_code, integration_response.get('statusCode'))
