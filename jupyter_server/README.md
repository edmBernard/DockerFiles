# Instruction

this dockefile depend on others docker images :

```bash
sudo docker build -t opencv_only -f opencv_only/Dockerfile opencv_only
```

```bash
sudo docker build -t opencv_numba -f opencv_numba/Dockerfile opencv_numba
```

Command to add in .bashrc

```bash
function jupserver () {
    docker run --name $1 -it --rm -p 0.0.0.0:5000:8888-v /home/user:/home/dev/host -e BOX_NAME=$1 -e force_color_prompt=yes jupyter_server:latest
}
```

