# SteamCMD on ARM64

This Docker image uses [my Box86/64 base](https://github.com/000yesnt/box86-box64-docker) to run SteamCMD. 
With it, you can run game servers on ARM hardware. It'll only work on 64-bit devices until I can figure out
how to make a 32-bit image.

## Usage
This image isn't meant to be used on its own, but you can use an interactive shell to run SteamCMD inside the container. [See the CM2Walki examples](https://github.com/CM2Walki/steamcmd?tab=readme-ov-file#how-to-use-this-image)
