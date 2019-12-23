# 使用快照

本快照需要eosforce node v1.8以上版本


## 1、下载最新版docker image
```
docker pull eosforce/node:v1.8.3
```

## 2、下载最近的快照文件到服务器

如：00ec05ba1d16aafae795ce3bbfff4313a5130e8aafcb976bdacd54764d3b1198.tar.gz

## 3、解压下载的文件，并移动复制到节点数据目录(以node_data为例)
```
tar -zxvf 00ec05ba1d16aafae795ce3bbfff4313a5130e8aafcb976bdacd54764d3b1198.tar.gz
mv snapshot-00ec05ba1d16aafae795ce3bbfff4313a5130e8aafcb976bdacd54764d3b1198.bin  /node_data/snapshot.bin 
mv nodeosd.sh /node_data/
```

## 4、修改config.ini文件，加载producer_api_plugin
```config.ini
plugin = eosio::producer_plugin
plugin = eosio::producer_api_plugin
```

## 5、准备好节点的数据目录
目录格式如下  
├── node_data   
│       ├── nodeosd.sh   
│       ├── snapshot.bin   
│       ├── config   
│       │      ├── activeacc.json      
│       │      ├── config.ini   
│       │      ├── eosio.lock.abi   
│       │      ├── ...   
│       │      └── genesis.json   
│       ├── data   
│       │   (此目录一定要为空)

## 6、先启动一个预备容器来处理快照数据

```
docker run -d --name eosforce-snapshot -v /node_data:/eosforce -p 9876:9876 -p 8888:8888 eosforce/node:v1.8.3 /eosforce/nodeosd.sh
```

## 7、查看容器日志，等到同步完成时。停止预备容器
```
docker logs -f --tail 100 eosforce-snapshot

(ctrl+c 退出日志状态)

docker stop eosforce-snapshot

```

## 8、先启动一个正式容器来运行节点

```
docker run -d --name eosforce-node -v /node_data:/eosforce -p 9876:9876 -p 8888:8888 eosforce/node:v1.8.3 nodeosd.sh
```

## 9、查看容器日志，确认已块出后。删除预备容器
```
docker logs -f --tail 100 eosforce-node

(ctrl+c 退出日志状态)

docker rm eosforce-snapshot

```
