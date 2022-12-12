Convert armor to other armor(s) on the fly via json maps.

## Requirements
* [CMake](https://cmake.org/)
	* Add this to your `PATH`
* [Vcpkg](https://github.com/microsoft/vcpkg)
	* Add the environment variable `VCPKG_ROOT` with the value as the path to the folder containing vcpkg
* [Visual Studio Community 2022](https://visualstudio.microsoft.com/)
	* C++ Clang tools for Windows
	* Desktop development with C++

## Building
```
# if using native tools command prompt
git clone https://github.com/MaidV/TransformArmor
cd TransformArmor
git submodule update --init --recursive
git submodule update --recursive --remote
cmake -B build -S . -G Ninja
# I just use VSCode with the cmake plugin and the default generator set to Ninja
```
