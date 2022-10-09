1. Запуск пода из образа в деплойменте
- наличие deployment:
```commandline
vlad@home:~/Documents/Netology/DevOps/dz_№56$ kubectl get deployment
NAME    READY   UP-TO-DATE   AVAILABLE   AGE
hello   2/2     2            2           108s

```
- наличие подов:
```commandline
vlad@home:~/Documents/Netology/DevOps/dz_№56$ kubectl get pods
NAME                     READY   STATUS    RESTARTS   AGE
hello-7645474cc5-hh86v   1/1     Running   0          118s
hello-7645474cc5-xxrqc   1/1     Running   0          118s

```
3. Изменение количества реплик
```commandline
vlad@home:~/Documents/Netology/DevOps/dz_№56$ kubectl get pods
NAME                     READY   STATUS    RESTARTS   AGE
hello-7645474cc5-ct8bd   1/1     Running   0          4s
hello-7645474cc5-dqkbd   1/1     Running   0          4s
hello-7645474cc5-hh86v   1/1     Running   0          5m6s
hello-7645474cc5-n6578   1/1     Running   0          4s
hello-7645474cc5-xxrqc   1/1     Running   0          5m6s

```