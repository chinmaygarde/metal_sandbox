add_executable(metal_sandbox
  AppDelegate.h
  AppDelegate.mm
  GameViewController.h
  GameViewController.mm
  macros.h
  main.mm
  Renderer.h
  Renderer.mm
  ShaderTypes.h
)

target_include_directories(metal_sandbox
  PUBLIC
    ../third_party/hedley
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
