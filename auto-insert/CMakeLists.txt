cmake_minimum_required(VERSION 4.0)

project(MyProject VERSION 0.1 LANGUAGES CXX)


# Set the standard to C++23
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED YES)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")


# find_package(fmt REQUIRED)

# add_executable(main
#   main.cpp
# )
# target_link_libraries(main fmt::fmt)
