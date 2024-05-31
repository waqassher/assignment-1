#!/bin/bash

# Set variables
EKS_CLUSTER_NAME="your-cluster-name"
AWS_REGION="your-aws-region"
AWS_ACCOUNT_ID="your-aws-account-id"
IMAGE_NAME="helloworld"
NAMESPACE="default"
DEPLOYMENT_NAME="your-deployment-name"

# Generate a version tag using the current timestamp
VERSION_TAG=$(date +%Y%m%d%H%M%S)

# Authenticate with EKS cluster
aws eks --region $AWS_REGION update-kubeconfig --name $EKS_CLUSTER_NAME

# Build Docker image
docker build -t $IMAGE_NAME:$VERSION_TAG .

# Tag Docker image
docker tag $IMAGE_NAME:$VERSION_TAG $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME:$VERSION_TAG

# Push Docker image to ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME:$VERSION_TAG


# Update deployment with the latest image
kubectl set image deployment/$DEPLOYMENT_NAME $IMAGE_NAME=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME:$VERSION_TAG -n $NAMESPACE
# Deploy application to EKS
kubectl apply -f deployment.yaml -n $NAMESPACE
kubectl apply -f service.yaml -n $NAMESPACE


