# 基于 Docker 的 Hadoop 分布式集群

## 项目简介

本项目使用 Docker 和 Docker Compose 在 Windows 环境下模拟一个 3 节点的 Hadoop 分布式集群（1 个 Master 节点，2 个 Slave 节点），并提供了现代化的自定义 Web 监控界面。

## 项目结构

```
Hadoop-Docker-Project/
├── docker-compose.yml         # 集群定义文件
├── config/                    # Hadoop配置文件
│   ├── core-site.xml          # 核心配置
│   ├── hdfs-site.xml          # HDFS配置
│   ├── mapred-site.xml        # MapReduce配置
│   ├── yarn-site.xml          # YARN配置
│   └── workers                # 集群节点定义
├── Dockerfile                 # Hadoop镜像构建文件
├── scripts/                   # 自动化脚本
│   └── bootstrap.sh           # 容器启动脚本
├── data/                      # HDFS数据持久化目录
├── web/                       # 自定义Web监控界面
│   └── index.html             # 主页面
└── README.md                  # 项目说明
```

## 环境要求

- Windows 10/11 (WSL2)
- Docker Desktop
- Docker Compose

## 快速开始

### 1. 构建镜像并启动集群

```bash
cd Hadoop-Docker-Project
docker-compose up -d
```

### 2. 验证集群状态

集群启动后，可以通过以下方式验证状态：

#### 2.1 访问 Web 界面

- HDFS 管理界面：http://localhost:9870
- YARN 资源管理器：http://localhost:8088
- 自定义监控界面：直接打开 `web/index.html` 文件（无需额外服务器）

#### 2.2 查看容器状态

```bash
docker-compose ps
```

#### 2.3 进入 Master 节点

```bash
docker exec -it hadoop-master bash
```

### 3. 运行 WordCount 示例

#### 3.1 在 HDFS 中创建输入目录

```bash
hdfs dfs -mkdir -p /input
```

#### 3.2 上传测试文件

```bash
# 创建一个测试文件
echo "Hello Hadoop Hello Docker" > test.txt
# 上传到HDFS
hdfs dfs -put test.txt /input/
```

#### 3.3 运行 WordCount

```bash
yarn jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.0.jar wordcount /input /output
```

#### 3.4 查看结果

```bash
hdfs dfs -cat /output/part-r-00000
```

## 常用命令

### 停止集群

```bash
docker-compose down
```

### 查看集群日志

```bash
docker-compose logs hadoop-master
docker-compose logs hadoop-slave1
docker-compose logs hadoop-slave2
```

### 重启集群

```bash
docker-compose restart
```

## 注意事项

1. 确保 Docker Desktop 已启用 WSL2 集成
2. 第一次启动时，NameNode 会自动格式化
3. HDFS 数据会持久化到宿主机的`./data`目录
4. 如果需要修改 Hadoop 配置，只需编辑`./config`目录下的配置文件，然后重启集群即可

## 故障排除

### 容器无法启动

查看容器日志：

```bash
docker-compose logs
```

### 节点无法通信

检查网络配置和防火墙设置，确保容器间可以通过主机名通信。

### HDFS 或 YARN 服务未启动

进入容器查看服务状态：

```bash
docker exec -it hadoop-master bash
jps  # 查看Java进程
```

## 参考资料

- [Hadoop 官方文档](https://hadoop.apache.org/docs/stable/)
- [Docker 官方文档](https://docs.docker.com/)
- [Docker Compose 官方文档](https://docs.docker.com/compose/)
