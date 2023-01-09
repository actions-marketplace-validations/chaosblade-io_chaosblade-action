# GitHub Action for ChaosBlade Engineering in Kubernetes

`chaosblade-action` is a GitHub action that applies chaos engineering to your development workflow using CHAOSBLADE. This action privides a way to perform different chaos experiment on the Kubernetes environment.

For more details on CHAOSBLADE, refer to [https://chaosblade.io/](https://chaosblade.io/).

## Pre-requisites
* Kubernetes 1.16 or later.
* Helm 3.*

## Usage

### Step 1. Prepare chaos configuration file

Prepare the configuration file (YAML) of the failures which you expect to inject into the system, for example `container-cpu-fullload.yaml`:

```yaml
apiVersion: chaosblade.io/v1alpha1
kind: ChaosBlade
metadata:
  name: increase-container-cpu-load-by-id
spec:
  experiments:
    - scope: container
      target: cpu
      action: fullload
      desc: "increase container cpu load by id"
      matchers:
        - name: container-names
          value:
            - "nginx"
        - name: cpu-percent
          value: ["100"]
          # pod names
        - name: names
          value: ["nginx-0"]
        - name: cgroup-root
          value: ["/host-sys/fs/cgroup"]
```

### Step 2. Encode the chaos configuration file with base64 (optional)

Obtain the base64 value of the chaos configuration file using the following command:

```shell
CBCFY_BASE64=`base64 container-cpu-fullload.yaml`
```

### Step 3. Create the workflow

1. Deploy the Kubernetes cluster

A Kubernetes cluster is required for the workflow. You can use the following action to deploy :
* [Kind Cluster](https://github.com/marketplace/actions/kind-kubernetes-in-docker-action) 
* [Kind Action](https://github.com/marketplace/actions/kind-kubernetes-in-docker-action)

2. Deploy Application

The application needs to be deployed to perform the chaos injection. You can see the example：[nginx-statefulset](https://raw.githubusercontent.com/chaosblade-io/chaosblade-ci-lib/main/app/nginx-statefulset.yaml)

3. Use `chaosblade-action`.

To create the workflow in GitHub action, use `chaosblade-io/chaosblade-action` in the yaml configuration file and configure the base64 value of the chaos configuration file, and set the version of CHAOSBLADE. 

```yaml
    - name: Run chaosblade experiment
      uses: chaosblade-io/chaosblade-action@master
      env:
        CBCFY_BASE64: ${CBCFY_BASE64}
        CHAOSBLADE_VERSION: v1.7.1
```

If the chaos configuration file is committed to GitHub, you can set `CBCFY_FILE` as the path to the file:

```yaml
    - name: Run chaosblade experiment
      uses: chaosblade-io/chaosblade-action@master
      env:
        CBCFY_FILE: https://raw.githubusercontent.com/chaosblade-io/chaosblade-action/main/experiments/container-cpu-fullload/container-cpu-fullload.yaml
        CHAOSBLADE_VERSION: v1.7.1
```

<table>
  <tr>
    <th> Variables </th>
    <th> Description </th>
    <th> Default Value </th>
  </tr>
  <tr>
    <th> CBCFY_BASE64 </th>
    <th> Configure the base64 value of the chaos configuration file. Just set one of CBCFY_BASE64 and CBCFY_FILE </th>
    <th> NULL </th>
  </tr>
  <tr>
    <th> CBCFY_FILE </th>
    <th> The path of the chaos configuration file. Just set one of CBCFY_BASE64 and CBCFY_FILE </th>
    <th> NULL </th>
  </tr>
  <tr>
    <th> CHAOSBLADE_VERSION </th>
    <th> The version of CHAOSBLADE </th>
    <th> LATEST </th>
  </tr>
 
</table>


For the complete configuration file, see [sample](https://github.com/chaosblade-io/chaosblade-action/main/.github/workflows/chaos-test.yml).
