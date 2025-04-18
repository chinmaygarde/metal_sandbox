//
//  main.m
//  MetalSandbox
//
//  Created by Chinmay Garde on 4/12/25.
//

#define GLFW_EXPOSE_NATIVE_COCOA
#import <GLFW/glfw3.h>
#import <GLFW/glfw3native.h>

#include <Metal/Metal.h>
#import <QuartzCore/CAMetalLayer.h>
#import <fml/command_line.h>
#import <fml/logging.h>
#import "macros.h"

namespace ms {

struct WindowData {
  CAMetalLayer* layer = nil;
};

bool Main(const fml::CommandLine& cmd) {
  FML_CHECK(::glfwInit() == GLFW_TRUE);
  ::glfwSetErrorCallback([](int code, const char* description) {
    FML_LOG(ERROR) << "GLFW Error '" << description << "'  (" << code << ").";
  });
  ::glfwDefaultWindowHints();
  ::glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API);
  ::glfwWindowHint(GLFW_VISIBLE, GLFW_FALSE);
  auto window = ::glfwCreateWindow(1, 1, "Metal Sandbox", nullptr, nullptr);
  FML_CHECK(!!window);
  FML_DEFER(::glfwDestroyWindow(window));
  ::glfwSetWindowSize(window, 800, 600);
  ::glfwSetWindowPos(window, 200, 100);
  ::glfwShowWindow(window);
  WindowData window_data;
  ::glfwSetWindowUserPointer(window, &window_data);
  window_data.layer = [CAMetalLayer layer];
  window_data.layer.device = MTLCreateSystemDefaultDevice();
  window_data.layer.pixelFormat = MTLPixelFormatBGRA8Unorm;
  window_data.layer.framebufferOnly = NO;
  NSWindow* cocoa_window = ::glfwGetCocoaWindow(window);
  cocoa_window.contentView.layer = window_data.layer;
  cocoa_window.contentView.wantsLayer = YES;
  while (true) {
    @autoreleasepool {
      ::glfwPollEvents();
      if (::glfwWindowShouldClose(window)) {
        return true;
      }
    }
  }
  return true;
}

}  // namespace ms

int main(int argc, const char* argv[]) {
  @autoreleasepool {
    return ms::Main(fml::CommandLineFromPlatformOrArgcArgv(argc, argv))
               ? EXIT_SUCCESS
               : EXIT_FAILURE;
  }
}
