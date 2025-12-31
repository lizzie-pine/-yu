# 基于Ubuntu 20.04镜像
FROM ubuntu:20.04

# 安装必要的软件包
RUN apt-get update && apt-get install -y \
    openssh-server \
    openjdk-8-jdk \
    wget \
    curl \
    vim \
    && rm -rf /var/lib/apt/lists/*

# 创建Hadoop用户并设置密码
RUN useradd -m hadoop && echo "hadoop:hadoop" | chpasswd
RUN usermod -aG sudo hadoop

# 切换到hadoop用户
USER hadoop
WORKDIR /home/hadoop

# 下载并解压Hadoop 3.3.0
RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-3.3.0/hadoop-3.3.0.tar.gz && \
    tar -xzf hadoop-3.3.0.tar.gz && \
    rm hadoop-3.3.0.tar.gz

# 设置环境变量
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_HOME=/home/hadoop/hadoop-3.3.0
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

# 配置SSH免密登录
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

# 配置Hadoop环境变量
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh

# 复制启动脚本
COPY scripts/bootstrap.sh /home/hadoop/
RUN chmod +x /home/hadoop/bootstrap.sh

# 暴露端口
EXPOSE 9870 9000 8088 50070 50075 50030 50060

# 启动脚本
CMD ["/home/hadoop/bootstrap.sh"]