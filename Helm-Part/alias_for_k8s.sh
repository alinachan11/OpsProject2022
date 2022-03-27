#!/bin/bash

aws eks --region=us-east-1 update-kubeconfig --name opsschool-eks-alina--final-project
alias k=kubectl
alias hd='helm delete'
alias hl='helm list'
alias kgp='k get pods'
alias kgs='k get service'
alias kgpm='kgp -n monitoring'
alias kgpc='kgp -n consul'
alias kgsm='kgs -n monitoring'
alias kgsc='kgs -n consul'
alias kgpa='k get pods --all-namespaces'
alias kgsa='k get service --all-namespaces'
