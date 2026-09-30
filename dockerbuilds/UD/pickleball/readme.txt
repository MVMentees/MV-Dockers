LOGIN:
 In order to take quizzes and receive a badge for completion
	https://learn.rocketsoftware.com

DOWNLOAD the newest UniData Trial Edition:
        https://www.rocketsoftware.com/en-us/products/multivalue/unidata/linux-free-trial

BUILD: 
 Build the docker image you just downloaded
	Unzip the files into a directory like dockers/unidata-pickleball
	Add the UDTTE version you downloaded to that same directory
	docker build -t unidata-pickleball .

RUN WITH SAVED PROGRESS:
 This is preferred if you want to KEEP your tutorial accounts separate from the docker. Allowing you to
 save your work as you progress through the tutorial.

 Linux:         docker run -it -p2223:23 --rm -v /savedUD:/mystuff:z unidata-pickleball:latest
 Windows:       docker run -it --rm -v C:\savedUD:/mystuff:z unidata-pickleball:latest

 Note: The directory/folder specification before the colon must exist and can be any preferably empty one
       in place of the /savedUD or C:\savedUD.

RUN WITHOUT SAVED PROGRESS:
 If you do not want or cannot save progress, you can run the docker without external volume.

 Linux:         docker run -it -p2223:23 --rm unidata-pickleball:latest
 Windows:       docker run -it --rm unidata-pickleball:latest

Note:  The -p2223:23 allows telnet access to the docker on host port 2223.
       Add -p32438:31438 -p50000-50010:50000-50010 to allow for MVVS/VSCode access with debugging.
       Ports 2223 and 32348 are arbitrary and you can use whatever is available.
       The ports 50000-50010 are dap ports for debugging and cannot be changed if you want to debug in VSCode.
