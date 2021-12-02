# Introduction 
TODO: creacion de un agente vsts con packages personalizados que se puede ejecutar desde un docker-compose para ejecucion de pipelines de azure devops. 

# Getting Started
TODO: Guide users through getting your code up and running on their own system. In this section you can talk about:
1.	Installation process
2.	Software dependencies
3.	Latest releases
4.	API references

# Build and Test
cd .
docker build -t pedominguezbr/vstsagent:2.195.1 .
docker push pedominguezbr/vstsagent:2.195.1

docker-compose ps
docker-compose up -d

# Contribute

#Para agente windows
docker build -t agentevstwin .
docker tag agentewin pedominguezbr/vstsagentewin:2.195.1
docker push pedominguezbr/vstsagentewin:2.195.1

