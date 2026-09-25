LOGIN:
 In order to take quizzes and receive a badge for completion
	https://learn.rocketsoftware.com

BUILD: 
 Build the docker image you just downloaded
	docker build -t universe-essentials .

RUN WITH SAVED PROGRESS:
 This is preferred if you want to KEEP your tutorial accounts separate from the docker. Allowing you to
 save your work as you progress through the tutorial.

 Linux:		docker run -it -p2223:23 -p32438:31438 --rm -v /savedUV:/mystuff:z universe-essentials:latest
 Windows: 	docker run -it --rm -v C:\savedUV:/mystuff:z universe-essentials:latest

 Note: The directory/folder specification before the colon must exist and can be any preferably empty one
       in place of the /savedUV or C:\savedUV.

RUN WITHOUT SAVED PROGRESS:
 If you do not want or cannot save progress, you can run the docker without external volume

 Linux:		docker run -it --rm universe-essentials:latest
 Windows: 	docker run -it -p2223:23 -p32438:31438 --rm universe-essentials:latest

Note: The -p2223:23 redirects telnet on the docker to port 2223 on the host, this can be changed as well.
      Also, the -p32438:31438 redirects uniRPC to port 32438 on the host and can be changed.
