# Example of using Rust from Python on \[MUSL-based\] Alpine Linux

## One-liner for testing

```console
docker build -t pew . && docker run --rm pew & docker rmi pew
```

## Notes

I managed to compile an `.so` that can be used from Python but my solution with [-Ctarget-feature=-crt-static](https://rust-lang.github.io/rfcs/1721-crt-static.html) still requires GNU libc. Without [`gcompat`](https://pkgs.alpinelinux.org/package/edge/main/x86_64/gcompat) you'll get

```text
Traceback (most recent call last):
  File "//call_rust.py", line 5, in <module>
    cdll = cdll.LoadLibrary(so)
           ^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.11/ctypes/__init__.py", line 454, in LoadLibrary
    return self._dlltype(name)
           ^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.11/ctypes/__init__.py", line 376, in __init__
    self._handle = _dlopen(self._name, mode)
                   ^^^^^^^^^^^^^^^^^^^^^^^^^
OSError: Error loading shared library ld-linux-x86-64.so.2: No such file or directory (needed by ./libexample.so)
```

In response to my question about this, I received the following:

> (hyeonu) alpine is not a typical musl target. it uses distro-provided dynamically linked musl libc. every other use cases of musl libc statically link it to the executable. if your program is a pure rust project including all your deps, normal statically linked musl would likely work as well. you have system library deps? well, good luck. alpine would be a no-brainer choice for languages which hardly have system libs deps like java and go. but for langs with heavily deps on system libs like python and rust, alpine would not worth a try.
> ...
> (hyeonu) problem is linking C libs dynamically. since noone else uses dynamic musl virtually no build system is ready for it
> (ilyvion) You can definitely run Rust on tiny images (I run a Rust web service on one of Google's "distroless" Docker containers), but this doesn't seem like it's just Rust.
