<img src="https://hadoop.apache.org/elephant.png" width="15%" align="right">

# ICTU Hadoop Docker
Hadoop + Solr trên Docker...

## Build Image

```bash
git clone https://github.com/ictu-research/docker.git .
docker build . -t hadoop
```

## Running

```bash
docker-compose up --scale datanode=4
```

## Author

Name: Tran Xuan Thanh

Email: dtc1954801010007@ictu.edu.vn

Facebook: gingdev

Co-worker: Vu Dinh Dung, Pham Quang Huy
