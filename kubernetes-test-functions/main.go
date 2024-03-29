/**
 * Reusable utility functions used for testing Kubernetes infrastructure.
 * Author: Andrew Jarombek
 * Date: 7/5/2020
 */

package kubernetes_test_functions

import (
	"context"
	v1 "k8s.io/api/apps/v1"
	v1core "k8s.io/api/core/v1"
	v1meta "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"regexp"
	"testing"
)

// ExpectedDeploymentCount determines if the number of 'Deployment' objects in a namespace is as expected.
func ExpectedDeploymentCount(t *testing.T, clientset *kubernetes.Clientset, namespace string, expectedCount int) {
	deployments, err := clientset.AppsV1().Deployments(namespace).List(context.TODO(), v1meta.ListOptions{})

	if err != nil {
		panic(err.Error())
	}

	var actualCount = len(deployments.Items)
	if actualCount == expectedCount {
		t.Logf(
			"The expected number of Deployments exist in the '%v' namespace.  Expected %v, got %v.",
			namespace,
			expectedCount,
			actualCount,
		)
	} else {
		t.Errorf(
			"An unexpected number of Deployments exist in the '%v' namespace.  Expected %v, got %v.",
			namespace,
			expectedCount,
			actualCount,
		)
	}
}

// DeploymentExists checks if a Deployment object exists in a certain namespace.
func DeploymentExists(t *testing.T, clientset *kubernetes.Clientset, name string, namespace string) {
	deployment, err := clientset.AppsV1().Deployments(namespace).Get(context.TODO(), name, v1meta.GetOptions{})

	if err != nil {
		panic(err.Error())
	}

	actualName := deployment.Name
	if actualName == name {
		t.Logf("Jenkins Deployment exists with the expected name.  Expected %v, got %v.", name, actualName)
	} else {
		t.Errorf("Jenkins Deployment does not exist with the expected name.  Expected %v, got %v.", name, actualName)
	}
}

// AnnotationsEqual logs a failure to a test suite if an annotation in the annotations map does not have its expected
// value.  Otherwise, it logs a success message and the test suite will proceed with a success code.
func AnnotationsEqual(t *testing.T, annotations map[string]string, name string, expectedValue string) {
	value := annotations[name]

	if expectedValue == value {
		t.Logf(
			"Annotation %v exists with its expected value.  Expected %v, got %v.",
			name,
			expectedValue,
			value,
		)
	} else {
		t.Errorf(
			"Annotation %v does not exist with its expected value.  Expected %v, got %v.",
			name,
			expectedValue,
			value,
		)
	}
}

// AnnotationsMatchPattern logs a failure to a test suite if an annotation in the annotations map does not match its
// expected pattern.  Otherwise, it logs a success message and the test suite will proceed with a success code.
func AnnotationsMatchPattern(t *testing.T, annotations map[string]string, name string, expectedPattern string) {
	value := annotations[name]
	pattern, err := regexp.Compile(expectedPattern)

	if err != nil {
		panic(err.Error())
	}

	if pattern.MatchString(value) {
		t.Logf(
			"Annotation %v exists and matches its expected pattern.  Expected %v, got %v.",
			name,
			expectedPattern,
			value,
		)
	} else {
		t.Errorf(
			"Annotation %v does not exist and match its expected pattern.  Expected %v, got %v.",
			name,
			expectedPattern,
			value,
		)
	}
}

// ConditionStatusMet checks a condition on a Deployment and sees if its status is as expected.
func ConditionStatusMet(t *testing.T, conditions []v1.DeploymentCondition,
	conditionType v1.DeploymentConditionType, expectedStatus v1core.ConditionStatus) {

	matches := make([]v1.DeploymentCondition, 0, 1)
	for _, condition := range conditions {
		if condition.Type == conditionType {
			matches = append(matches, condition)
		}
	}

	status := matches[0].Status

	if status == expectedStatus {
		t.Logf(
			"Deployment condition type %v has its expected status.  Expected %v, got %v.",
			conditionType,
			expectedStatus,
			status,
		)
	} else {
		t.Errorf(
			"Deployment condition type %v does not have its expected status.  Expected %v, got %v.",
			conditionType,
			expectedStatus,
			status,
		)
	}
}

// ReplicaCountAsExpected performs appropriate logging when comparing the number of replicas for a deployment and its
// expected value.
func ReplicaCountAsExpected(t *testing.T, expectedReplicas int32, actualReplicas int32, description string) {
	if expectedReplicas == actualReplicas {
		t.Logf(
			"Jenkins Deployment has expected %v.  Expected %v, got %v.",
			description,
			expectedReplicas,
			actualReplicas,
		)
	} else {
		t.Errorf(
			"Jenkins Deployment has unexpected %v.  Expected %v, got %v.",
			description,
			expectedReplicas,
			actualReplicas,
		)
	}
}

// DeploymentStatusCheck determines if a Deployment object is running as expected.  Commonly used to make sure there
// aren't any errors in the Deployment.
func DeploymentStatusCheck(
	t *testing.T,
	clientset *kubernetes.Clientset,
	name string,
	namespace string,
	isAvailable bool,
	isProgressing bool,
	expectedTotalReplicas int32,
	expectedAvailableReplicas int32,
	expectedReadyReplicas int32,
	expectedUnavailableReplicas int32,
) {
	deployment, err := clientset.AppsV1().Deployments(namespace).Get(context.TODO(), name, v1meta.GetOptions{})

	if err != nil {
		panic(err.Error())
	}

	deploymentConditions := deployment.Status.Conditions

	var availableStatus v1core.ConditionStatus
	if isAvailable {
		availableStatus = "True"
	} else {
		availableStatus = "False"
	}

	var progressingStatus v1core.ConditionStatus
	if isProgressing {
		progressingStatus = "True"
	} else {
		progressingStatus = "False"
	}

	ConditionStatusMet(t, deploymentConditions, "Available", availableStatus)
	ConditionStatusMet(t, deploymentConditions, "Progressing", progressingStatus)

	totalReplicas := deployment.Status.Replicas
	ReplicaCountAsExpected(t, expectedTotalReplicas, totalReplicas, "total number of replicas")

	availableReplicas := deployment.Status.AvailableReplicas
	ReplicaCountAsExpected(t, expectedAvailableReplicas, availableReplicas, "number of available replicas")

	readyReplicas := deployment.Status.ReadyReplicas
	ReplicaCountAsExpected(t, expectedReadyReplicas, readyReplicas, "number of ready replicas")

	unavailableReplicas := deployment.Status.UnavailableReplicas
	ReplicaCountAsExpected(t, expectedUnavailableReplicas, unavailableReplicas, "number of unavailable replicas")
}

// NamespaceExists determines if a Namespace exists and is active in a cluster.
func NamespaceExists(t *testing.T, clientset *kubernetes.Clientset, name string) {
	namespace, err := clientset.CoreV1().Namespaces().Get(context.TODO(), name, v1meta.GetOptions{})

	if err != nil {
		panic(err.Error())
	}

	var status v1core.NamespacePhase = "Active"
	if namespace.Status.Phase == status {
		t.Logf("Cluster has a namespace named %v.", name)
	} else {
		t.Errorf("Cluster does not have a namespace named %v.", name)
	}
}

// ServiceAccountExists determines if a ServiceAccount exists in a cluster.
func ServiceAccountExists(t *testing.T, clientset *kubernetes.Clientset, name string, namespace string) {
	serviceAccount, err := clientset.CoreV1().ServiceAccounts(namespace).Get(context.TODO(), name, v1meta.GetOptions{})

	if err != nil {
		panic(err.Error())
	}

	var now = v1meta.Now()
	if serviceAccount.CreationTimestamp.Before(&now) {
		t.Logf("A ServiceAccount named '%v' exists in the '%v' namespace.", name, namespace)
	} else {
		t.Errorf("A ServiceAccount named '%v' does not exist in the '%v' namespace.", name, namespace)
	}
}

// RoleExists determines if a Role exists in a cluster in a specific namespace.
func RoleExists(t *testing.T, clientset *kubernetes.Clientset, name string, namespace string) {
	role, err := clientset.RbacV1().Roles(namespace).Get(context.TODO(), name, v1meta.GetOptions{})

	if err != nil {
		panic(err.Error())
	}

	var now = v1meta.Now()
	if role.CreationTimestamp.Before(&now) {
		t.Logf("A Role named '%v' exists in the '%v' namespace.", name, namespace)
	} else {
		t.Errorf("A Role named '%v' does not exist in the '%v' namespace.", name, namespace)
	}
}

// RoleBindingExists tests that a RoleBinding object with a given name exists in a specific namespace.
func RoleBindingExists(t *testing.T, clientset *kubernetes.Clientset, name string, namespace string) {
	role, err := clientset.RbacV1().RoleBindings(namespace).Get(context.TODO(), name, v1meta.GetOptions{})

	if err != nil {
		panic(err.Error())
	}

	var now = v1meta.Now()
	if role.CreationTimestamp.Before(&now) {
		t.Logf("A RoleBinding object named '%v' exists in the '%v' namespace.", name, namespace)
	} else {
		t.Errorf("A RoleBinding object named '%v' does not exist in the '%v' namespace.", name, namespace)
	}
}

// ClusterRoleExists tests that a ClusterRole object with a given name exists.
func ClusterRoleExists(t *testing.T, clientset *kubernetes.Clientset, name string) {
	role, err := clientset.RbacV1().ClusterRoles().Get(context.TODO(), name, v1meta.GetOptions{})

	if err != nil {
		panic(err.Error())
	}

	var now = v1meta.Now()
	if role.CreationTimestamp.Before(&now) {
		t.Logf("A ClusterRole named '%v' exists.", name)
	} else {
		t.Errorf("A ClusterRole named '%v' does not exist.", name)
	}
}

// ClusterRoleBindingExists tests that a ClusterRoleBinding object with a given name exists.
func ClusterRoleBindingExists(t *testing.T, clientset *kubernetes.Clientset, name string) {
	role, err := clientset.RbacV1().ClusterRoleBindings().Get(context.TODO(), name, v1meta.GetOptions{})

	if err != nil {
		panic(err.Error())
	}

	var now = v1meta.Now()
	if role.CreationTimestamp.Before(&now) {
		t.Logf("A ClusterRoleBinding object named '%v' exists.", name)
	} else {
		t.Errorf("A ClusterRoleBinding object named '%v' does not exist.", name)
	}
}

// NamespaceServiceCount determines if the expected number of Service objects exist in the a namespace.
func NamespaceServiceCount(t *testing.T, clientset *kubernetes.Clientset, namespace string, expectedServiceCount int) {
	services, err := clientset.CoreV1().Services(namespace).List(context.TODO(), v1meta.ListOptions{})

	if err != nil {
		panic(err.Error())
	}

	var serviceCount = len(services.Items)
	if serviceCount == expectedServiceCount {
		t.Logf(
			"A single Service object exists in the '%s' namespace.  Expected %v, got %v.",
			namespace,
			expectedServiceCount,
			serviceCount,
		)
	} else {
		t.Errorf(
			"An unexpected number of Service objects exist in the '%s' namespace.  Expected %v, got %v.",
			namespace,
			expectedServiceCount,
			serviceCount,
		)
	}
}

// ServiceExists determines if a Service exists in the a specific namespace.
func ServiceExists(
	t *testing.T,
	clientset *kubernetes.Clientset,
	name string,
	namespace string,
	serviceType v1core.ServiceType,
) {
	service, err := clientset.CoreV1().Services(namespace).Get(context.TODO(), name, v1meta.GetOptions{})

	if err != nil {
		panic(err.Error())
	}

	if service.Spec.Type == serviceType {
		t.Logf(
			"A '%s' Service object exists of the expected type.  Expected %v, got %v.",
			name,
			serviceType,
			service.Spec.Type,
		)
	} else {
		t.Errorf(
			"A '%s' Service object does not exist of the expected type.  Expected %v, got %v.",
			name,
			serviceType,
			service.Spec.Type,
		)
	}
}

// NamespaceIngressCount determines if the number of 'Ingress' objects in a namespace is as expected.
func NamespaceIngressCount(t *testing.T, clientset *kubernetes.Clientset, namespace string, expectedIngressCount int) {
	ingresses, err := clientset.NetworkingV1().Ingresses(namespace).List(context.TODO(), v1meta.ListOptions{})

	if err != nil {
		panic(err.Error())
	}

	var ingressCount = len(ingresses.Items)
	if ingressCount == expectedIngressCount {
		t.Logf(
			"A single Ingress object exists in the '%s' namespace.  Expected %v, got %v.",
			namespace,
			expectedIngressCount,
			ingressCount,
		)
	} else {
		t.Errorf(
			"An unexpected number of Ingress objects exist in the '%s' namespace.  Expected %v, got %v.",
			namespace,
			expectedIngressCount,
			ingressCount,
		)
	}
}

// IngressExists determines if an ingress object exists in a specific namespace.
func IngressExists(t *testing.T, clientset *kubernetes.Clientset, namespace string, name string) {
	ingress, err := clientset.NetworkingV1().Ingresses(namespace).Get(context.TODO(), name, v1meta.GetOptions{})

	if err != nil {
		panic(err.Error())
	}

	if ingress.Name == name {
		t.Logf(
			"Ingress exists with the expected name.  Expected %v, got %v.",
			name,
			ingress.Name,
		)
	} else {
		t.Errorf(
			"Ingress does not exist with the expected name.  Expected %v, got %v.",
			name,
			ingress.Name,
		)
	}
}
