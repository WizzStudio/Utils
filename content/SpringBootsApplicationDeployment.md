### 检查当前端口占用
```
# netstat -anp | grep 8080
tcp        0      0 0.0.0.0:8080            0.0.0.0:*               LISTEN      6709/java
```

### 关闭监听该端口的进程
```
# kill -TERM 6709
```
信号名称`-TERM`不加也可以，`kill`命令默认发送`SIGTERM`。

### 切换至项目工作树并更新本地代码
```
# cd RedFlower
# git pull
Username for 'https://git.coding.net': hwding
Password for 'https://hwding@git.coding.net': 
remote: Counting objects: 99, done.
remote: Compressing objects: 100% (79/79), done.
remote: Total 99 (delta 46), reused 0 (delta 0)
Unpacking objects: 100% (99/99), done.
From https://git.coding.net/wxjackie/RedFlower
   c9d7699..cf23059  master     -> origin/master
Updating c9d7699..cf23059
```
省略了部分结果。

### 重新编译
```
# mvn package
[INFO] Scanning for projects...
[INFO] ------------------------------------------------------------------------
[INFO] Building RedFlower 0.0.1-SNAPSHOT
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 10.280 s
[INFO] Finished at: 2018-03-30T18:06:42+08:00
[INFO] Final Memory: 29M/122M
[INFO] ------------------------------------------------------------------------
```
省略了部分结果。

### 启动应用至后台并重定向标准输出、标准错误到文件
```
# cd target/
# java -jar redflower-0.0.1-SNAPSHOT.jar 1>log 2>&1 &
[1] 22081
```
你得到的是新启动进程的PID。

### 查看文件记录的输出
```
# tail -n 100 log
```
省略了所有结果。

一般指定最后100行就可以看到最后一个异常打印出的所有堆栈信息。