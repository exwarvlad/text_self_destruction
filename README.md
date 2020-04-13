# Text self destruction
[show on Heroku](https://shrouded-fjord-28356.herokuapp.com/)

![](public/images/high_load.png)

### Description

High load app which have create self destroyer messages
* with timestamp
* after number of link visits

All the messages are stored encrypted on the server. With helpfully algorithm
[AES](https://ru.wikipedia.org/wiki/Advanced_Encryption_Standard)

Before shown message requires a password  
Default environment account  
login: admin  
password: admin 

## How to run app

You need a [docker](https://www.docker.com/)  

```
ruby bin/setup_env.rb 
docker-compose up -d 
```

Visit a **localhost:4567**
