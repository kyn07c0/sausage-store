# Sausage Store

![image](https://user-images.githubusercontent.com/9394918/121517767-69db8a80-c9f8-11eb-835a-e98ca07fd995.png)


## Technologies used

* Frontend – TypeScript, Angular.
* Backend  – Java 16, Spring Boot, Spring Data.
* Database – H2.

## Installation guide
### Backend

Install Java 16 and maven and run:

```bash
cd backend
mvn package
cd target
java -jar sausage-store-0.0.1-SNAPSHOT.jar
```

### Frontend

Install NodeJS and npm on your computer and run:

```bash
cd frontend
npm install
npm run build
npm install -g http-server
sudo http-server ./dist/frontend/ -p 80 --proxy http://localhost:8080
```

Then open your browser and go to [http://localhost](http://localhost)

### Пример добавления секретных данных в vault

```bash
vault kv put secret/sausage-store spring.datasource.username=std-017-006 spring.datasource.password=Testusr1234 spring.data.mongodb.uri=mongodb://std-017-006:Testusr1234@rc1a-u0nwp06gbwh8qsoq.mdb.yandexcloud.net:27018/std-017-006?tls=true\\\&tlsAllowInvalidCertificates=true
```
