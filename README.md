# Github Pre-receive Hook: Base Image

This is the base image from the Dockerfile https://help.github.com/enterprise/2.6/admin/guides/developer-workflow/creating-a-pre-receive-hook-script/#testing-pre-receive-scripts-locally. This is the first base with Git + SSHD server running without any language-specific implementation.

[![resolution](http://dockeri.co/image/marcellodesales/github-enterprise-prereceive-hook-base "Github Enterprise Pre-Receive Hook Base Image")](https://hub.docker.com/r/intuit/spring-cloud-config-validator/)

* You can reuse this image to create pre-receive hook in Python, Golang, Java, etc.

# Requirements

* `docker`: latest version
* `docker-compose`: latest version

# Setup a server

* Using `setup-server.sh`

```console
$ ./setup-server.sh

##### GIT + SSHD SERVER 1.0.0 #####

Wed May  1 16:50:26 PDT 2019

* Setting up a Git Server

==========--------- Building the new docker image -----------==========

* docker-compose build

Building marcellodesales-git-sshd-server
Step 1/6 : FROM alpine:3.9
 ---> cdf98d1859c1
Step 2/6 : LABEL maintainer="marcello.desales@gmail.com"
 ---> Using cache
 ---> 7e604fd6d428
Step 3/6 : RUN echo 'PS1="$(echo -e "\xF0\x9F\x90\xB3") [\\u@\\h]:\\W \\$ "' >> ~/.bashrc &&   apk add --no-cache git openssh bash &&   ssh-keygen -A &&   sed -i "s/#AuthorizedKeysFile/AuthorizedKeysFile/g" /etc/ssh/sshd_config &&   adduser git -D -G root -h /home/git -s /bin/bash &&   passwd -d git &&   su git -c "mkdir /home/git/.ssh &&      ssh-keygen -t rsa -b 4096 -f /home/git/.ssh/id_rsa -P '' &&      mv /home/git/.ssh/id_rsa.pub /home/git/.ssh/authorized_keys &&      mkdir /home/git/test.git &&      git --bare init /home/git/test.git"
 ---> Using cache
 ---> f98e34b17a7f
Step 4/6 : VOLUME ["/home/git/.ssh", "/home/git/test.git/hooks"]
 ---> Using cache
 ---> 5a2b77fe24e0
Step 5/6 : WORKDIR /home/git
 ---> Using cache
 ---> 127e54a26ee4
Step 6/6 : CMD ["/usr/sbin/sshd", "-D"]
 ---> Using cache
 ---> 5ca61c1ab080

Successfully built 5ca61c1ab080
Successfully tagged marcellodesales/git-sshd-server:1.0.0

==========--------- Start a new Git Server -----------==========

* docker-compose up -d

Stopping git-sshd-server-docker_marcellodesales-git-sshd-server_1 ... done
Starting git-sshd-server-docker_marcellodesales-git-sshd-server_1 ... done

==========--------- Copying credentials from Git server Container -----------==========

* Copying the key file id_rsa private from the Git Server
* docker cp git-sshd-server-docker_marcellodesales-git-sshd-server_1:/home/git/.ssh/id_rsa /Users/mdesales/dev/github/public/marcellodesales/git-sshd-server-docker/.id_rsa_from_git_server


Wed May  1 16:50:31 PDT 2019

* Finished setting up the server...
* Now you can run tests with test.sh copying the command below:

GIT_PEM_PATH=/Users/mdesales/dev/github/public/marcellodesales/git-sshd-server-docker/.id_rsa_from_git_server ./test.sh
```

# Using the server locally

* Linux: try eth0 or eth1

```
$ git remote add test git@$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'):test.git
```

* Mac: try en0 or en1 depending on wifi or ethernet.

```
$ git remote add test git@$(ipconfig getifaddr en0):test.git
```

> Note that you need to `id_rsa_from_container` you copied from the data container described in previous section.

```
$ GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p 52311 -i PATH_TO_ID/id_rsa_from_container" git remote show test
Warning: Permanently added '[172.16.188.135]:52311' (ECDSA) to the list of known hosts.
* remote test
  Fetch URL: git@172.16.188.135:test.git
  Push  URL: git@172.16.188.135:test.git
  HEAD branch: (unknown)
```

At this point, you are ready to proceed and use the git server. You can use the `test.sh` command to setup and push the initial files to the server:

```console
$ GIT_PEM_PATH=/Users/mdesales/dev/github/public/marcellodesales/git-sshd-server-docker/.id_rsa_from_github_simulator_server ./test.sh

##### GIT SERVER ######

Wed May  1 16:41:36 PDT 2019

==========--------- Git Repo Local Files -----------==========

* Current Dir: /Users/mdesales/dev/github/public/intuit/intuit-spring-cloud-config-validator/repo-test-msaas-2

total 72
drwxr-xr-x  14 mdesales  CORP\Domain Users   448 Apr 26 09:24 .
drwxr-xr-x  19 mdesales  CORP\Domain Users   608 May  1 16:20 ..
drwxr-xr-x  13 mdesales  CORP\Domain Users   416 May  1 16:40 .git
-rw-r--r--   1 mdesales  CORP\Domain Users    33 Apr 26 02:50 README.md
drwxr-xr-x   3 mdesales  CORP\Domain Users    96 Apr 26 09:24 another
-rw-r--r--   1 mdesales  CORP\Domain Users   243 Apr 26 02:50 application.yml
-rw-r--r--   1 mdesales  CORP\Domain Users   494 Apr 26 02:50 config_msaas_test_01-dev.yml
-rw-r--r--   1 mdesales  CORP\Domain Users   494 Apr 26 02:50 config_msaas_test_01-e2e.yml
-rw-r--r--   1 mdesales  CORP\Domain Users   494 Apr 26 02:50 config_msaas_test_01-prd.yml
-rw-r--r--   1 mdesales  CORP\Domain Users   494 Apr 26 02:50 config_msaas_test_01-prf.yml
-rw-r--r--   1 mdesales  CORP\Domain Users   494 Apr 26 02:50 config_msaas_test_01-qal.yml
-rw-r--r--   1 mdesales  CORP\Domain Users   358 Apr 26 02:50 config_msaas_test_01.yml
drwxr-xr-x   6 mdesales  CORP\Domain Users   192 Apr 26 09:24 idps
-rwxr-xr-x   1 mdesales  CORP\Domain Users  2320 Apr 26 09:15 test.sh

==========--------- Setting Test Remote Origin -----------==========

* Adding the git origin to current directory with server at 172.28.109.247

==========--------- Testing Remote Origin -----------==========

* Conectivity with the repo...
GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p 52311 -i /Users/mdesales/dev/github/public/marcellodesales/git-sshd-server-docker/.id_rsa_from_github_simulator_server" git remote show test

Warning: Permanently added '[172.28.109.247]:52311' (ECDSA) to the list of known hosts.
* remote test
  Fetch URL: git@172.28.109.247:test.git
  Push  URL: git@172.28.109.247:test.git
  HEAD branch: (unknown)

==========--------- Testing Remote Origin -----------==========

* Executing 'git push' to test github simulator
GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p 52311 -i /Users/mdesales/dev/github/public/marcellodesales/git-sshd-server-docker/.id_rsa_from_github_simulator_server" git push -u test master
Warning: Permanently added '[172.28.109.247]:52311' (ECDSA) to the list of known hosts.
Enumerating objects: 18, done.
Counting objects: 100% (18/18), done.
Delta compression using up to 8 threads
Compressing objects: 100% (16/16), done.
Writing objects: 100% (18/18), 11.19 KiB | 1.86 MiB/s, done.
Total 18 (delta 0), reused 18 (delta 0)
To 172.28.109.247:test.git
 * [new branch]      master -> master
Branch 'master' set up to track remote branch 'master' from 'test'.
```

* As you can see, you have pushed the current dir to the test repo.
* You can interact with the git server by using the commands above.
* You may choose to add this config into your git config to simplify

# Hooks Implementation

* You can implement pre-receive hooks using specific languages
* You may create a new `Dockerfile` that starts `FROM` this image to build custom validations

