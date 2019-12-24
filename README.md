### Deploy Jenkins Docker Image

##### 1. Pull Jenkins Docker image:
    # docker pull 4oh4/jenkins-docker

##### 2. Run Jenkins Docker Instance:

    docker run -d -it -p 8080:8080 -p 50000:50000 -u 0 -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock 4oh4/jenkins-docker

	
#####  3. Check automatically created Docker Volume
    docker volume ls
       DRIVER              VOLUME NAME
       local               jenkins_home
    cd /var/lib/docker/volumes
    ls -l
      jenkins_home

##### 4. Connect to Jenkins:
http://54.198.254.89:8080

    cat /var/lib/docker/volumes/jenkins_home/_data/secrets/initialAdminPassword
   xxxxxxxxxxxxxxxxxxx

#####NOTE:
Put hash in Jenkins login page
Go over Jenkins Menu and Install suggested modules and create new user

##### 5. Stop Jenkins Docker instance
    docker ps
    docker stop instance-id
    docker rm instance-id

##### 6. Run Jenkins Docker instance
    docker run -d -it -p 8080:8080 -p 50000:50000 -u 0 -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock 4oh4/jenkins-docker

##### 7. Create Jenkins FreeStyle Job
##### 7.1. Upload data adn configs to github project
##### 7.2. Configure Github Webhook
##### 7.3. Configure PreBuild Actions