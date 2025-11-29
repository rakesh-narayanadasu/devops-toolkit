Go is `self-contained binary`, a single executable file that contains your Go code, all required libraries and the Go runtime. 

We can run it where go is not installed.

It does not depend on system libraries like glibc or libstdc++.

*That's why we are using **alpine** in the second stage in the Dockerfile*

### Add non-root user

```
RUN adduser -D -u 1000 appuser
```
-D = default settings (no password, no home)

-u 1000 = set user ID to 1000
