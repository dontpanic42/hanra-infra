# How to use

Tools that expected to be in the $PATH of the server (e.g. /usr/bin)

Required for package.sh to work...

## Server setup

Server consist of:

- nginx: running as "nginx" user. html files in /usr/share/nginx/html
- node-api: installed using nvm.
    To get stuff to run, do the following:
    ``` 
        sudo su nodeuser
        cd /home/nodeuser
        source .nvm/nvm.sh
        pm2 status
    ```