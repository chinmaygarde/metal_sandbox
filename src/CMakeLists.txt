add_executable(metal_sandbox
  macros.h
  main.mm
  metal.cc
  ShaderTypes.h
)

target_include_directories(metal_sandbox
  PUBLIC
    ../third_party/hedley
    ../third_party/metalcpp/SingleHeader
)

target_compile_options(metal_sandbox PRIVATE "-fobjc-arc")

target_link_libraries(metal_sandbox
  PRIVATE
    "-framework AppKit"
    "-framework Foundation"
    "-framework Metal"
    "-framework MetalKit"
    "-framework ModelIO"
    "-framework QuartzCore"
    glfw
    glm
    jfml
)

metal_library(Shaders
  Shaders.metal
  more.metal
)
