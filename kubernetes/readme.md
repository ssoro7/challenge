# KUBERNETES DEPLOYMENT

## Requirements
- linux virtual machine for execute the bash scripts
- Minikube v1.25.1 or higher installed for deploying the container
- Docker version 20.10.5 or higher installed
- metric server https://docs.aws.amazon.com/eks/latest/userguide/metrics-server.html
- Ingress module https://kubernetes.github.io/ingress-nginx/deploy/#minikube
&nbsp;

## Solution

This is a basic implementation of a strategy for deploying the appli-cation containers in a high availability environment without downtime.
Three deployment strategies have been taken into account and in this repository are implemented two.
BLUE/GREN
RollingUpdate (Ramped - slow rollout)

Here are also some configurations that improve the resiliency of the product-service application.
- deployment.yaml – livenessProbe for failure tolerant, resource limitation.
- hpa.yaml - It scale according to demand in high-load moments
- ingress.yaml - for access to the product-service by domain from out-side.


Additionally, the application product-service had been modified for continuing when the product-review service is down or Inaccessible.

&nbsp;

## Getting started
### SCRIPTS
### RollingUpdate 
Deploy or Update new version of product-service with RollingUpdate
```bash
cd kubernetes/product-service/RollingUpdate/
chmod 755 update-deploy.sh
./update-deploy.sh -v 1.0.0
```
### BLUE/GREN 
Deploy new version of product-service with blue or green role
```bash
cd kubernetes/product-service/blue-green/
chmod 755 initial-deploy.sh
./initial-deploy.sh -t blue
```
Update new version of product-service wether from blue to green or green to blue
```bash
cd kubernetes/product-service/blue-green/
chmod 755 blue-green-switch.sh
./blue-green-switch.sh
```
Delete the old version of product-service wether from blue or green
```bash
cd kubernetes/product-service/blue-green/
chmod 755 delete-previous-version.sh
./delete-previous-version.sh
```

&nbsp;

## Interaction
### Product Service
```bash
# Get product by ID
curl http://$(minikube ip):30037/product/GW1390

# Healthcheck
curl http://$(minikube ip):30037/actuator/health
```
&nbsp;
### Product Review
```bash
# Get product review by ID
curl http://$(minikube ip):30036/review/GW1390

# Healthcheck
curl http://$(minikube ip):30036/actuator/health
```
&nbsp;
### Products available:
Here is a list of IDs that can be used on either app to obtain data:
 - GW1390
 - GZ5922
 - Q46222
 - GZ2228
 - EG4958

&nbsp;
