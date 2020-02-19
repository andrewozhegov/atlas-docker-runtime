# [aarch64] Huawei MindStudio DDK runtime

### Requires

- Packages

```
docker, docker-compose
```

- Preinstalled `npu-smi` on the HOST side

```
# mkdir /lib64
# ln -s /lib/aarch64-linux-gnu/ld-2.27.so /lib64/ld-linux-aarch64.so.1
# unzip npu_ubuntu.arm_1.2.1.zip
# ./npu_ubuntu.arm_1.2.1.run --full
```

- Put install packages into `build` directory

```
MSpore_DDK-1.3.5.B896-aarch64.ubuntu18.04-aarch64.ubuntu18.04-aarch64.miniOS.tar.gz
mini_mind_studio_ubuntu_arm_server.rar
npu_ubuntu.arm_1.2.1.zip
```

### Build

```
$ docker-compose build
```

### Run

```
$ docker-compose run --rm mind_studio
$ docker-compose run --rm mind_studio bash
```
