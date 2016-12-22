This dockerfile is use to create a temporary devbox

# Command to create isolated devbox

Command to add in .bashrc

```bash
function newbox () {
    docker run --name $1 -it --rm -v /home/user:/home/dev/host -e BOX_NAME=$1 -e force_color_prompt=yes opencv_numba:latest
}
```

