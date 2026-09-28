LOGIN:
 In order to take quizzes and receive a badge for completion
	https://learn.rocketsoftware.com

BUILD: 
 Build the docker image you just downloaded
	docker build -t jbase-essentials .

RUN WITH SAVED PROGRESS:
 This is preferred if you want to KEEP your tutorial accounts separate from the docker. Allowing you to
 save your work as you progress through the tutorial.

 Linux:		docker run -it -p2223:23 -p32438:20002 --rm -v /savedJB:/mystuff:z jbase-essentials:latest
 Windows: 	docker run -it --rm -v C:\savedJB:/mystuff:z jbase-essentials:latest

 Note: The directory/folder specification before the colon must exist and can be any preferably empty one
       in place of the /savedJB or C:\savedJB.

RUN WITHOUT SAVED PROGRESS:
 If you do not want or cannot save progress, you can run the docker without external volume

 Linux:		docker run -it --rm jbase-essentials:latest
 Windows: 	docker run -it -p2223:23 -p32438:20002 --rm jbase-essentials:latest

Note: The -p2223:23 redirects telnet on the docker to port 2223 on the host, this can be changed as well.
      Also, the -p32438:20002 redirects jbase_agent to port 32438 on the host and can be changed.
