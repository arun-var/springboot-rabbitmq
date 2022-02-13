# RabbitMQ Producer/Consumer Behaviour

The purpose of the exercise is to find out application behaviour which uses rabbitmq and how they react to rabbitmq cluster failures.

# Prerequistive

- Docker
- kind 
- helm version 3

## Create kind cluster
```
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraMounts:
    - hostPath: /home/arun/warzone/kind-storage
      containerPath: /host-storage
- role: worker
- role: worker
- role: worker
```
## Install rabbitmq operator
helm3 repo add bitnami https://charts.bitnami.com/bitnami
helm3 repo update
helm3 install my-release bitnami/rabbitmq-cluster-operator
## Install rabbitmq cluster using operator CRD
```
apiVersion: rabbitmq.com/v1beta1
kind: RabbitmqCluster
metadata:
  name: rabbitmq-custom-configuration
spec:
  replicas: 3
  rabbitmq:
    additionalConfig: |
      log.console.level = debug
```

## Producer/Consumer app using Springboot 



#### Executing

you can simply run the projects *rabbitmq-consumer* and *rabbitmq-producer* on the IDE.

Or on command line with:
* `mvn clean install` on the root folder
* `mvn spring-boot:start` on each project folder

Once they are running you can use:
* `http://localhost:8081/producer` to create a new message
* `http://localhost:8080/consumer` to see the list of consumed messages.

Each produced message will be sent to a exchange that routes them towards two queues:  
* topic.queue: a topic queue where the messages will be available for the consumer
* ttl.queue: a TTL queue, where the message are suppose to go to a Dead letter queue after
30s.

The message with ID 5 will fail and will also be sent to the Dead letter queue.
