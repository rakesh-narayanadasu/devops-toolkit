Go is `self-contained binary`, a single executable file that contains your Go code, all required libraries and the Go runtime. 

We can run it where go is not installed.

It does not depend on system libraries like glibc or libstdc++.

*That's why we are using **alpine** in the second stage in the Dockerfile*
