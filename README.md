# Sourcemod Plugins

A collection of stupid plugin that I wrote for myself

## Plugins
- [OnlyMySteamGroup](https://github.com/noaione/OnlyMySteamGroup) is a plugin to only allows a specified steam group to join the server.
- [mapstatus]() is a simple map status check with the players count and more.

## Building smx files

You can use this [website](https://spider.limetech.io/) to help you generate an .smx file from .sp file.

Just copy paste the code contents.

If the folder have `include` folder, that means you need to download everything in include folder and drop it in the website, after that change the line in .sp file that have:

```c
#include "include/xxxxxxxxxx"
```

Into just:

```c
#include "xxxxxxxxxx"
```

And then hit compile.

## License

All of my plugins are licensed with [GNU GPL-3 License](LICENSE) except stated otherwise