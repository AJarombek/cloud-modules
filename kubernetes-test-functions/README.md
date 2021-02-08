### Overview

Reusable functions for testing Kubernetes infrastructure.  Functions are written in Go with the help of the Kubernetes 
Go client module.

### Usage

In an implementing modules `go.mod` file:

```go.mod
require(
    github.com/ajarombek/cloud-modules/k8s-test-functions v0.2.6
)
```

In an implementing modules Go source code:

```go
package main

import (
	k8sfuncs "github.com/ajarombek/cloud-modules/k8s-test-functions"
)
```

### Commands

**Initial Setup of the module**

```bash
go mod init github.com/ajarombek/cloud-modules/k8s-test-functions
go get k8s.io/client-go@kubernetes-1.17.0
go get k8s.io/apimachinery@kubernetes-1.17.0
```

### Files

| Filename                 | Description                                                                                  |
|--------------------------|----------------------------------------------------------------------------------------------|
| `main.go`                | Functions to assist Kubernetes tests.                                                        |
| `go.mod`                 | Go module definition and dependency specification.                                           |
| `go.sum`                 | Versions of modules installed as dependencies for this Go module.                            |

### Resources

1. [go.mod reference](https://golang.org/ref/mod)