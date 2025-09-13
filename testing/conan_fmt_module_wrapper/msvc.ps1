conan profile detect
conan install . --output-folder=build --build=missing
Remove-Item CMakeUserPresets.json
cmake -S . -B build -GNinja -DCMAKE_BUILD_TYPE=Release
cmake --build build
