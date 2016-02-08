# tetradR
R Wrapper for Tetrad Library

## R Library Requirement
[rJava](https://cran.r-project.org/web/packages/rJava/index.html), 
[graph](http://bioconductor.org/packages/release/bioc/html/graph.html)
[RBGL] (http://bioconductor.org/packages/release/bioc/html/RBGL.html)

## Installation

1. Install the R library requirements:
```R
source("https://bioconductor.org/biocLite.R")
biocLite("graph")
biocLite("RBGL")
```
2. Install the release version of devtools from CRAN with `install.packages("devtools")`.
3. Install tetradR from github:

```R
library(devtools)
install_github("bd2kccd/tetradR")
```

## Useful `rJava` Trouble-shooting Installation in Mac OS X Links

1. [http://stackoverflow.com/questions/26948777/how-can-i-make-rjava-use-the-newer-version-of-java-on-osx/32544358#32544358](http://stackoverflow.com/questions/26948777/how-can-i-make-rjava-use-the-newer-version-of-java-on-osx/32544358#32544358)
2. [http://andrewgoldstone.com/blog/2015/02/03/rjava/](http://andrewgoldstone.com/blog/2015/02/03/rjava/)
