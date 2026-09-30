LOGIN:
 In order to take quizzes and receive a badge for completion
	https://learn.rocketsoftware.com

DOWNLOAD the newest UniVerse Trial Edition:
        https://www.rocketsoftware.com/en-us/products/multivalue/universe/linux-free-trial

BUILD: 
 Build the docker image you just downloaded
	Unzip the files into a directory like dockers/universe-pickleball
        Add the UVTE version you downloaded to that same directory
	Run	docker build -t universe-pickleball .

RUN WITH SAVED PROGRESS:
 This is preferred if you want to KEEP your tutorial accounts separate from the docker. Allowing you to
 save your work as you progress through the tutorial.

 Linux:         docker run -it -p2223:23 --rm -v /savedUV:/mystuff:z universe-pickleball:latest
 Windows:       docker run -it --rm -v C:\savedUV:/mystuff:z universe-pickleball:latest

 Note: The directory/folder specification before the colon must exist and can be any preferably empty one
       in place of the /savedUV or C:\savedUV.

RUN WITHOUT SAVED PROGRESS:
 If you do not want or cannot save progress, you can run the docker without external volume.

 Linux:         docker run -it -p2223:23 --rm universe-pickleball:latest
 Windows:       docker run -it --rm universe-pickleball:latest

Note:  The -p2223:23 allows telnet access to the docker on host port 2223.
       Add -p32438:31438 -p50000-50010:50000-50010 to allow for MVVS/VSCode access with debugging.
       Ports 2223 and 32348 are arbitrary and you can use whatever is available.
       The ports 50000-50010 are dap ports for debugging and cannot be changed if you want to debug in VSCode.
