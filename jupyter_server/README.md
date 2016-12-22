This dockerfile is use to create a temporary devbox

# Command to create isolated devbox

Command to add in .bashrc
```
function jupserver () {
    docker run --name $1 -it --rm -p 0.0.0.0:5000:8888-v /home/user:/home/dev/host -e BOX_NAME=$1 -e force_color_prompt=yes jupyter_server:latest
}
```

