# Container Cpu Fullload Experiment

The experiment increase container cpu load.

## Sample workflow

A Sample workflow to run the container cpu fullload experiment: `.github/workflows/chaos-test.yml`


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

base64 encode: 
```shell
YXBpVmVyc2lvbjogY2hhb3NibGFkZS5pby92MWFscGhhMQ0Ka2luZDogQ2hhb3NCbGFkZQ0KbWV0YWRhdGE6DQogIG5hbWU6IGluY3JlYXNlLWNvbnRhaW5lci1jcHUtbG9hZC1ieS1pZA0Kc3BlYzoNCiAgZXhwZXJpbWVudHM6DQogIC0gc2NvcGU6IGNvbnRhaW5lcg0KICAgIHRhcmdldDogY3B1DQogICAgYWN0aW9uOiBmdWxsbG9hZA0KICAgIGRlc2M6ICJpbmNyZWFzZSBjb250YWluZXIgY3B1IGxvYWQgYnkgaWQiDQogICAgbWF0Y2hlcnM6DQogICAgLSBuYW1lOiBjb250YWluZXItbmFtZXMNCiAgICAgIHZhbHVlOg0KICAgICAgLSAibmdpbngiDQogICAgLSBuYW1lOiBjcHUtcGVyY2VudA0KICAgICAgdmFsdWU6IFsiMTAwIl0NCiAgICAgICMgcG9kIG5hbWVzDQogICAgLSBuYW1lOiBuYW1lcw0KICAgICAgdmFsdWU6IFsibmdpbngtMCJdDQogICAgLSBuYW1lOiBjZ3JvdXAtcm9vdA0KICAgICAgdmFsdWU6IFsiL2hvc3Qtc3lzL2ZzL2Nncm91cCJd
```