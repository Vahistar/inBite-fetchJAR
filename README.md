# fetchJAR

A minimal Java jar that fetches text from a URL and prints it in the server console.

The URL is baked into the jar at build time, so the jar takes no arguments and reads no config at runtime. It prints the text, clears the console first, and keeps running — which is what makes it usable on Minecraft hosting panels like Pterodactyl, where a process that exits is treated as a stopped server.

## Features

- Prints exactly what the URL returns
- Clears the console before printing
- Keeps running after printing, so the server is never flagged as stopped
- Standalone — no dependencies, no runtime config files

## Build

Requires JDK 11+ with `javac` and `jar` on PATH.

Windows:

```
build.bat
```

Linux / macOS:

```
chmod +x build.sh
./build.sh
```

The script asks for a URL and produces `server.jar`.

## Run

```
java -jar server.jar
```

## Layout

```
src/Main.java     entry point — fetches the URL and prints it
logo.txt          ASCII banner shown by the build scripts
build.bat         build script for Windows
build.sh          build script for Linux / macOS
```

## Notes

- Use a raw link, e.g. `raw.githubusercontent.com/...`. A regular GitHub page returns HTML.
- To change the URL, rebuild the jar.
- Bad HTTP responses and network errors are printed instead of crashing the process.
