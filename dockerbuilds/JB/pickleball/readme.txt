LOGIN:
 In order to take quizzes and receive a badge for completion
	https://learn.rocketsoftware.com

DOWNLOAD the newest jBASE Personal Edition:
	https://www.rocketsoftware.com/en-us/products/multivalue/jbase/linux-free-trial

BUILD: 
 Build the docker image you just downloaded
        Unzip the files into a directory like dockers/jbase-pickleball
        Add the JBPE version you downloaded to that same directory
        Run     docker build -t jbase-pickleball .

RUN WITH SAVED PROGRESS:
 This is preferred if you want to KEEP your tutorial accounts separate from the docker. Allowing you to
 save your work as you progress through the tutorial.

 Linux:		docker run -it -p2223:23 --rm -v /savedJB:/mystuff:z jbase-pickleball:latest
 Windows: 	docker run -it --rm -v C:\savedJB:/mystuff:z jbase-pickleball:latest

 Note: The directory/folder specification before the colon must exist and can be any preferably empty one
       in place of the /savedJB or C:\savedJB.

RUN WITHOUT SAVED PROGRESS:
 If you do not want or cannot save progress, you can run the docker without external volume

 Linux:		docker run -it -p2223:23 --rm jbase-pickleball:latest
 Windows: 	docker run -it --rm jbase-pickleball:latest

Note:  The -p2223:23 allows telnet access to the docker on host port 2223.
       Add -p32438:20002 to allow for MVVS/VSCode access.
       Ports 2223 and 32348 are arbitrary and you can use whatever is available.
