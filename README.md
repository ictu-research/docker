<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/Hadoop_logo.svg/1024px-Hadoop_logo.svg.png" width="25%" align="right">

# ICTU Hadoop Docker
Hadoop + Solr trên Docker...

## Build Image

```bash
git clone https://github.com/ictu-research/docker.git .
docker compose build
```

## Running

```bash
docker compose up --scale datanode=2
```

## Information

Namenode: `http://localhost:9870` 

![](https://imgur.com/vTYfMl1.png)

Solr Admin: `http://localhost:8983`

## Author

Name: Tran Xuan Thanh

Email: dtc1954801010007@ictu.edu.vn

Facebook: gingdev

Co-worker: Vu Dinh Dung, Pham Quang Huy
