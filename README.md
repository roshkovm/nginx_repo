### Deploy Jenkins Docker Image

##### 1. Run Jenkins Docker Instance:

    # docker run -d -it -p 8080:8080 -p 50000:50000 -u 0 -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock 4oh4/jenkins-docker

	
##### 2. Check automatically created Docker Volume
    # docker volume ls
       DRIVER              VOLUME NAME
       local               jenkins_home
    # cd /var/lib/docker/volumes
    # ls -l
      jenkins_home

##### 3. Connect to Jenkins:
http://35.153.91.220:8080

    # cat /var/lib/docker/volumes/jenkins_home/_data/secrets/initialAdminPassword
   xxxxxxxxxxxxxxxxxxx

#####NOTE:
Put hash in Jenkins login page
Go over Jenkins Menu and Install suggested modules and create new user

##### 4. Stop Jenkins Docker instance
    # docker ps
    # docker stop instance-id
    # docker rm instance-id

##### 5. Run Jenkins Docker instance
    # docker run -d -it -p 8080:8080 -p 50000:50000 -u 0 -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock 4oh4/jenkins-docker

##### 6. Create Jenkins FreeStyle Job
##### 6.1. Upload data adn configs to github project
##### 6.2. Configure Github Webhook
##### 6.3. Configure PreBuild Actions
Run shell script:

    #!/bin/bash
	echo
	echo "Create new mynginx Docker image..."
	echo
	docker build --rm=true --no-cache=true -t mynginx . --file=Dockerfile
	echo
	echo "List docker images..."
	echo
	docker images


	DOCKER_INSTANCE_NAME=nginx_web


	docker_running_check() {
	  echo "Check if NEW Docker Instance was running..."
	  RUNNING_STATUS=$(docker inspect -f '{{.State.Running}}' $DOCKER_INSTANCE_NAME)
	  if [ "$RUNNING_STATUS" == "true" ]; then
		 echo "OK! NEW Docker instance was running!"
		 exit 0
	  else
		 echo "ERROR! NEW Docker instance was NOT running!"
		 exit 1
	  fi
	}

	echo
	echo "Check status Nginx Docker instance..."
	echo
	RUNNING_STATUS=$(docker inspect -f '{{.State.Running}}' $DOCKER_INSTANCE_NAME)
	echo "Running status: $RUNNING_STATUS"

	if  [ "$RUNNING_STATUS" == "true" ]
	then
	   echo "Docker Instance is running. Try to stop it..."
	   DOCKER_ID=$(docker ps -aqf "name=$DOCKER_INSTANCE_NAME")
	   echo "Docker ID: $DOCKER_ID"
	   docker stop $DOCKER_ID
	   docker rm $DOCKER_ID
	   
	   echo
	   echo "Check if OLD Docker Instance was removed..."
	   DOCKER_ID=$(docker ps -aqf "name=$DOCKER_INSTANCE_NAME")
	   if [[ -z $DOCKER_ID ]]; then
		  echo
		  echo "OK! OLD Docker instance was removed. Try to start NEW Docker instance..."
		  docker run --name nginx_web -d -p 80:80 -it mynginx:latest
		  
		  docker_running_check
		  
		  
	   else
		  echo "ERROR! OLD Docker instance was NOT removed!"
		  exit 1
	   fi
	   
	else
	   
	   echo "OLD Docker Instance is not running..."  
	   echo "Check Docker instance ID..."
	   DOCKER_ID=$(docker ps -aqf "name=$DOCKER_INSTANCE_NAME")
	   echo
	   
	   if [[ -z $DOCKER_ID ]]; then
		  echo
		  echo "OK! OLD Docker instance was stopped and removed. Try to start it..."
		  docker run --name nginx_web -d -p 80:80 -it mynginx:latest
		  
		  docker_running_check
		  
		  
	   else
		  echo "WARNING! OLD Docker instance was stopped, but not removed! Trying to remove it..."
		  docker rm $DOCKER_ID
		  echo 
		  echo "Check if OLD Docker Instance was removed..."
		  DOCKER_ID=$(docker ps -aqf "name=$DOCKER_INSTANCE_NAME")
		  
		  if [[ -z $DOCKER_ID ]]; then
			echo "OK! OLD Docker instance was removed. Try to start it..."
			docker run --name nginx_web -d -p 80:80 -it mynginx:latest
			echo
		  
		  docker_running_check
			
		  else
			echo "ERROR! OLD Docker instance was NOT removed!"
			exit 1
		  fi
		  
		  

	   fi
	   
	   
	fi
