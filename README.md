# devops-final-project

## project description

![Alt text](./photos/DevOps-Project.jpg?raw=true "Title")

---

### This project mainly consists of two main parts

1. Infrastructure as code (IaC) and Configuration

    - terraform builds the infrastructure at gcp that consists of (VPC, 2 Subnets, firewall rule, 2 service accounts, management vm, and private kubernetes cluster)

    - after building the infra terraform provisioner dynamically creates ansible invintory.ini file in ansible directory and run ansible-playbook

    - ansible then configure the management vm, and copy namespace, deployment, service account, volume, and service (LoadBalancer) yaml files from jenkins-config folder then apply them to the cluster

    - we need to configure jenkins to be able to run kubectl and build docker images

        - a customized jenkins image is created using ./jenkins-config/Dockerfile that contains kubectl and docker cli

        - configure the node where jenkins will run to has docker deamon and volume mapping /var/run/ to jenkins deployment, to install docker on kubernetes nodes there is many approaches such as

            1. create deamonset with docker installation commands in it and apply this deamonset before creating jenkins deployement (./jenkins-config/install-docker-alpine.yaml)

            2. add init container in jenkins deployment resposible for installing docker inside nodes

            3. create jenkins slave that contains docker deamon installed on it and use it to do the task

2. CI/CD and kubernetes

    - CI/CD is applied to this GitHub repo
    <https://github.com/Ahmed-Nasr-hassan/python-app-CI-CD>

    - firstly we need to configure jenkins to be triggered by GitHub as well as GitHub to trigger Jenkins when the developer push updates to code, helpful link
    <https://www.devopsschool.com/blog/how-to-build-when-a-change-is-pushed-to-github-in-jenkins/>

    - create in GitHub repo Jenkinsfile to be used by jenkins pipeline and a Dockerfile that will be also used by jenkins in CI (continous integration)

    - during building the image current date is captured and used in versioning process

    - finally jenkins CD part will use kubectl to deploy the updated version of the app








