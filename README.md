# ICTU Hadoop Docker
Hadoop trên Docker...

## Running

```bash
docker-compose up --scale datanode=4
```

## Run MapReduceJob

```bash
cd mrjob
python3 WordCount.py -r hadoop demo.txt
```

## Author

Name: Tran Xuan Thanh

Email: dtc1954801010007@ictu.edu.vn

Facebook: gingdev

Co-worker: Vu Dinh Dung, Pham Quang Huy
