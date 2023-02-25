# devops-final-project

## project description

![Alt text](./photos/DevOps-Final-Project.jpg?raw=true "Title")

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

    - during building the image current date is captured and used in versioning process <https://hub.docker.com/repository/docker/ahmednasrhassan/python-app/general>

    - finally jenkins CD part will use kubectl to deploy the updated version of the app

3. project can be extend to include

    1. logging and monitoring solutions using Prometheus and Grafana using the following helm chart

        ``` bash
            helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
            helm install prometheus-release prometheus-community/prometheus
        ```

    2. use ingress and route to different services based on pathes

        - ingress-loadbalancer-ip/pyton-app -> App website
        - ingress-loadbalancer-ip/grafana -> grafana dashboard
        - ingress-loadbalancer-ip/jenkins -> jenkins dashboard


### CI/CD configuration screenshots

1. generate token (secret text) to use it in jenkins to configure GitHub

    ![Alt text](./photos/generate-token-secret-text-to-use-it-in-jenkins.png?raw=true "Title")

    ---

2. config GitHub plugin in jenkins

    ![Alt text](./photos/config_github_plugin_in_jenkins.png?raw=true "Title")

    ---

3. create webhook in GitHub to trigger jenkins

    ![Alt text](./photos/create-webhook-in-github-to-notigy-jenkins.png?raw=true "Title")

    ---

4. adding dockerhub credintials to be used by Jenkinsfile

    ![Alt text](./photos/adding-dockerhub-credintials-to-be-used-in-jenkinsfile.png?raw=true "Title")

    ---

5. jenkins pipeline config (1)

    ![Alt text](./photos/jenkins-pipeline-config-1.png?raw=true "Title")

    ---

6. jenkins pipeline config (2)

    ![Alt text](./photos/jenkins-pipeline-config-2.png?raw=true "Title")
