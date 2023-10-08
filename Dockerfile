FROM ubuntu:jammy-20230816

RUN apt-get update && apt-get install -y gcc python3 python3-pip

RUN useradd -m user
USER user
WORKDIR /home/user

COPY --chown=user ./gen_libc.py /home/user/gen_libc.py
COPY --chown=user ./exp.c /home/user/exp.c

RUN pip3 install pwn

RUN python3 gen_libc.py
RUN gcc exp.c -o exp

FROM ubuntu:jammy-20230816

RUN useradd -m user
USER user
WORKDIR /home/user

COPY --chown=user --from=0 /home/user/exp /home/user/exp
COPY --chown=user --from=0 /home/user/libc.so.6 /home/user/libc.so.6

CMD ["/bin/bash"]
