# Example of using Rust from Python on \[MUSL-based\] Alpine Linux

## One-liner for testing

```console
docker build -t pew . && docker run --rm pew
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
