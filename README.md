## Подготовка
- Для развертывания серверов использовался terraform
- - [main.tf](./main.tf)
- - [networks.tf](./networks.tf)
- - [resourse.tf](./resourse.tf)
- - [variables.tf](./variables.tf)

- Для развертывания подов использовался образ из предыдущей [домашней работы](https://github.com/Vladislav-Pugachev/netology-DevOps-dz_-55) 
- Для deployment использвался [манифест](./deploy.yaml)
### 1. Запуск пода из образа в деплойменте
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
### 2. Просмотр логов для разработки
- Подготовка
 - - Создание namespace
```commandline
vlad@home:~/Documents/Netology/DevOps/dz_№56$kubectl create namespace app-namespace
```
- - Создание serviceaccount в namespace
```commandline
vlad@home:~/Documents/Netology/DevOps/dz_№56$kubectl create serviceaccount viewuser --namespace app-namespace
```
- - Создание token для serviceaccount
```commandline
vlad@home:~/Documents/Netology/DevOps/dz_№56$kubectl create -n app-namespace token viewuser
```
- - Создание context 
```commandline
vlad@home:~/Documents/Netology/DevOps/dz_№56$kubectl config set-context viewuser  --cluster kubernetes --user viewuser --namespace app-namespace
```
- - Применение [Role](./Role.yml)  с необходимыми правами
```commandline
vlad@home:~/Documents/Netology/DevOps/dz_№56$kubectl apply -f Role.yml
```
- - Применение [Rolebinding](./Rolebinding.yml) для связки  Role и serviceaccount
```commandline
vlad@home:~/Documents/Netology/DevOps/dz_№56$kubectl apply -f Rolebinding.yml
```
- Проверка
- - Переключение в нужный контекст
```commandline
vlad@home:~/Documents/Netology/DevOps/dz_№56$kubectl config use-context viewuser
vlad@home:~/Documents/Netology/DevOps/dz_№56$kubectl config get-context
CURRENT   NAME                          CLUSTER      AUTHINFO           NAMESPACE
          kubernetes-admin@kubernetes   kubernetes   kubernetes-admin   
*         viewuser                      kubernetes   viewuser           app-namespace
```
- - Проверка разрешенных команд
```commandline
vlad@home:~/Documents/Netology/DevOps/dz_№56$kubectl describes/hello-7645474cc5-d2dmb 
Name:             hello-7645474cc5-d2dmb
Namespace:        app-namespace
Priority:         0
Service Account:  default
Node:             worker1/192.168.10.14
-----
vlad@home:~/Documents/Netology/DevOps/dz_№56$ kubectl logs pods/hello-7645474cc5-d2dmb 
vlad@home:~/Documents/Netology/DevOps/dz_№56$ 
```
- - Проверка ограничении
```commandline
vlad@home:~/Documents/Netology/DevOps/dz_№56$kubectl get nodes
Error from server (Forbidden): nodes is forbidden: User "system:serviceaccount:app-namespace:viewuser" cannot list resource "nodes" in API group "" at the cluster scope
```

kube/config
```commandline
- context:
    cluster: kubernetes
    user: kubernetes-admin
  name: kubernetes-admin@kubernetes
- context:
    cluster: kubernetes
    namespace: app-namespace
    user: viewuser
  name: viewuser
current-context: viewuser
kind: Config
preferences: {}
users:
- name: kubernetes-admin
  user:
    client-certificate-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURJVENDQWdtZ0F3SUJBZ0lJT2xHbk93ODI5MUV3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TWpFd01UQXhOelF4TURoYUZ3MHlNekV3TVRBeE56UXhNVEphTURReApGekFWQmdOVkJBb1REbk41YzNSbGJUcHRZWE4wWlhKek1Sa3dGd1lEVlFRREV4QnJkV0psY201bGRHVnpMV0ZrCmJXbHVNSUlCSWpBTkJna3Foa2lHOXcwQkFRRUZBQU9DQVE4QU1JSUJDZ0tDQVFFQXQ4MkF3RnNnL2F4SXZSWU4KY1N1YkdOOXFuSkJrVG94L2pQZmNsVmF1SG80QjNaOW45RUNycFZwSW45YjE4QVpPb2d0V080MVovSFRZa0ZFTwpSMUwzVG90NS90aEVYY2xmVXpIdVg3ZlZKeHdNVXB0YjF1OVBKUXBWdGJITDdEUWx3cUZBbUJWVlh3ZUpoRGs5CjZxeGZqbFRnaGg4YUJLZGI0Wm0wRkw4VUpycVZOeEJLOXdHT1ZyM01HeTl4ZVhwN3g4THVoSDdDdEw2ei92ejUKV2xrQXZKWkhRQ2lKT2NJVHFoS3FHYUt1bjZqM2pxdFplVGx3UHkrQUlsMjBEUDNBN05ZbWhRYUNhY0RWeFpvTwoxTVNrRGlDaTd1N1FWN2RyZXB3b3dMUVFTdEhOZDBvWmxqY1hjaFdwOUQxbWVYcFU3L2FLT2JIenRrempVb2doCkhLcVJlUUlEQVFBQm8xWXdWREFPQmdOVkhROEJBZjhFQkFNQ0JhQXdFd1lEVlIwbEJBd3dDZ1lJS3dZQkJRVUgKQXdJd0RBWURWUjBUQVFIL0JBSXdBREFmQmdOVkhTTUVHREFXZ0JRWEhqK3pJTUdQWEZGcnB5UzBaaFNGcGhYdwo2akFOQmdrcWhraUc5dzBCQVFzRkFBT0NBUUVBV1BTR1krV01neUZzeHgwWW5EK3Z2ZkQxb2tQUzBSOFRyY3ZECmNyU3hiM2JKMWhnZFpJSTg4WFhRbTAxWWVCVE9SUVZMcDNMY0ljMVY1d0F4ZDFXYVZjZ3NCWUhRTlpSb2N0MXAKQVRiVVZTSVdhRGl6cDFEYnlsaHQwSGdmV3AwVTFucmdjQ0htZTNxVkZlUDNhTWZmd01Ob0lWYkR2d2V0aytGTwowOURBZEhSc0dadG1nN2RBc0gvRS9VMjRhR2FxTmRUZTI5SGkxck5Na2xGRWRhOCs4RE0ySHQvbDA3SUtQTlJMCjErcDQ1bGhSZTAyeDJOYTdqN25BVWpyTlR5TFVIaXZCOHBHVTZ4S2hWZmc2aC9oNDBzdUpLeFQ5UTVoNGs1dXgKcEJnbWRGbW83VlNJclFWSEtFSTQyRC95U2lqdjZFZXJ4cWc2V00yNVhaaHkzVnFmaXc9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
    client-key-data: LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFb3dJQkFBS0NBUUVBdDgyQXdGc2cvYXhJdlJZTmNTdWJHTjlxbkpCa1RveC9qUGZjbFZhdUhvNEIzWjluCjlFQ3JwVnBJbjliMThBWk9vZ3RXTzQxWi9IVFlrRkVPUjFMM1RvdDUvdGhFWGNsZlV6SHVYN2ZWSnh3TVVwdGIKMXU5UEpRcFZ0YkhMN0RRbHdxRkFtQlZWWHdlSmhEazk2cXhmamxUZ2hoOGFCS2RiNFptMEZMOFVKcnFWTnhCSwo5d0dPVnIzTUd5OXhlWHA3eDhMdWhIN0N0TDZ6L3Z6NVdsa0F2SlpIUUNpSk9jSVRxaEtxR2FLdW42ajNqcXRaCmVUbHdQeStBSWwyMERQM0E3TlltaFFhQ2FjRFZ4Wm9PMU1Ta0RpQ2k3dTdRVjdkcmVwd293TFFRU3RITmQwb1oKbGpjWGNoV3A5RDFtZVhwVTcvYUtPYkh6dGt6alVvZ2hIS3FSZVFJREFRQUJBb0lCQVFDTHBGN2dSWnZ2L25lWQo2T3MzZ3ZpbjBmM09pMGthQUZaYnhHaGJNV3JDSGdPKzIvLy9xeTU5UnZXTU1xWFJRUWwyeFlRelpIWHNmdDJWCjcyOFlzeWpmRE1xWDJyaytRK0xmY3p6MmpkVXNqSHUwT3dKd2JvcER5dkZKUkpaNGt6bm8vOWZ5YzZyVHN3ZEEKWkxqczFSOFlKTlljTC83MWNDMDNYaTVaNEw0dm1TSUE3Y1hJcXRPNlhkVDN2K2lTaXNIMXZxclV6amwyNHpmdQpHZnExQ01pM0pjTXJDdks4K2dGVjk2TVp0dTlaZUJSOGIraWpxUlBFaDJGeUlhVXhOVWRlQStSdDJHbWxWMVErCmNUU2tKQWV6QXV2bUNlWG9KdlhGbkFZMTl6enpMVEM5YUNzUEJYZXJRVVFNdjMzbk94VUhuclJ4TG5jZ2VQdUEKTUV3ZmF3K05Bb0dCQU9SS3NJUmZTSmVMNnVidk1LRnR1dG5RWUpvcGpDQlhRTkZpeXhNS3Z4VS91ZU84blVZegp6cWpnT2kvMGRoMTVSVXllbi9YVWRkODhsTTdKYzhrWkJ0WkhGaGVXd3NPVzFYd0RPeDNrL294TDNWN3lYRG4vCkJ6Wnk1eTN3RXZWMXZOUWFPU2p1OUpobjVwK1dja0ZZdGdxdDRja2t4RzQyQm9OeTF3amFjWG5YQW9HQkFNNGMKZS9VdXZ0djZlT2JteS9JOVdNbzhzQ3lDN0M5M3ZFeDNkdTRvSTBWZDB3dUYrdjl4b1dOZjQ5QlRPSnBYUXh0ZApMNkJHTisvUG50ZVNXVS9KNWtrNmxHT3NrK2RrTzhLeXdrelFNNXQrY1h1ZmRoUDMzcHdJSlNCN1NJeFd3OW9nCk80Wk9SMFRtdG9NWCtzVy81ckRCV3R1dk5ZTFZQTXZKcFdiQ3JBVXZBb0dBVGVLcGZFL2h2VXBRRnYrdDBMVlcKRlMvQmRYY05SbzllSHRHY3hOOWF0ODRwQm1oNEk5WlRBRXlYclhxeXZYVjlUaG1rSzBPVC8xaDAwR1BzYThSdApEN2ZxOHB0TjBWcnBkTWpKWjNhVDNadVlaK2M1emRPVFMyRkNPK3IzSE9WUlNlKzBacUczc3pObmZEVGd3Q2lhCjJ1UGQ3empyQjBySlNCbHJBYXM5SWJzQ2dZQStkeGVDU1RhQ3lMaFhrbDhBL1dLcGVCY1VobUU2U1ptQnV6c0sKRnBRSjg5T0FUSXl6V2liRlRVeG4yTER3NWIxcXo2VWRkK3AvL1had2N1UXFjRkFncFdaUGh3QVVRcVp4N1dkQgpqRi8zb2l5V2dNOXlZYzdQanhCaGRidVkvTHJDb3I0bmlCWEZaZjZ1WUZnYUVuekIyUGZHV0tWcEQyTXJoK05lCjcyVGU5UUtCZ0RBV1hsdTYxM1BaNmYxZHVKSG4zSUFKbk4rUFhBc2YxSEoyUW5qSS9iZmNVcUloMUJOTmNUbFIKWXUxeGNKRERVN0V2bXJ4YUNxU0RGdzl1WTlqNjA0dDRFMVlTN2VSd25zTndFd3JQZkl0amo1ZnB5SHJQZlh4dgpvNlFTa2VpZ0hueXlpOFN5Z21SanRMY1d0WkJyeFZBcit0ZFpVYjgwUUltdmVudGwvdFh2Ci0tLS0tRU5EIFJTQSBQUklWQVRFIEtFWS0tLS0tCg==
- name: viewuser
  user:
    token: eyJhbGciOiJSUzI1NiIsImtpZCI6IlVmcVY0WDdYbUN3dTlGZGJOVDNwUHBpVFBIR2RZV2NjUGJ6c255ZHBDZFUifQ.eyJhdWQiOlsiaHR0cHM6Ly9rdWJlcm5ldGVzLmRlZmF1bHQuc3ZjLmNsdXN0ZXIubG9jYWwiXSwiZXhwIjoxNjY1NDI5MjQxLCJpYXQiOjE2NjU0MjU2NDEsImlzcyI6Imh0dHBzOi8va3ViZXJuZXRlcy5kZWZhdWx0LnN2Yy5jbHVzdGVyLmxvY2FsIiwia3ViZXJuZXRlcy5pbyI6eyJuYW1lc3BhY2UiOiJhcHAtbmFtZXNwYWNlIiwic2VydmljZWFjY291bnQiOnsibmFtZSI6InZpZXd1c2VyIiwidWlkIjoiZWQ0NGJjMTktMzk4MS00NDE5LWFhNTctMmYyN2VmNzY2NDMzIn19LCJuYmYiOjE2NjU0MjU2NDEsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDphcHAtbmFtZXNwYWNlOnZpZXd1c2VyIn0.Jn8vfVSGnGRmJ4Wy4zyd8XEgW_Oqur1wAGL7GHnmI5DKyONrVEMzFEZKeYSmkT2E_HHNR7quYarILhfZDwZ1FGZN2bi7afH4NgTVD4_zBT2gL_0_FiLuvqikXoaqYfMoFCRRqQbZFtWt2kR6FseqUFUVQ0sciNDLkY7J-pmsBQa0ggPO5cwpxnP8S1KRHi0Uldpq9KVKCX3D_XJwso6PNl7-v3GKv2yMLTQ7dWy3laWoYfF3Tl8B6mgq4cFz_zxTlPR7UZTHvPjNL7avn02ltRqyV_ESyyMfaaO82D0TB17zlgwaImXyD7ofOUbUOL0xeQYYcXTf4HFA3tqvIopdtg

```
### 3. Изменение количества реплик
```commandline
vlad@home:~/Documents/Netology/DevOps/dz_№56$ kubectl get pods
NAME                     READY   STATUS    RESTARTS   AGE
hello-7645474cc5-ct8bd   1/1     Running   0          4s
hello-7645474cc5-dqkbd   1/1     Running   0          4s
hello-7645474cc5-hh86v   1/1     Running   0          5m6s
hello-7645474cc5-n6578   1/1     Running   0          4s
hello-7645474cc5-xxrqc   1/1     Running   0          5m6s
```