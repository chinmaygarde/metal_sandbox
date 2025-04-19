if(__metal_library)
  return()
endif()
set(__metal_library INCLUDED)

function(metal_library TARGET_NAME)
  set(LIBRARY_NAME "${TARGET_NAME}_shaders")
  set(SHADER_OBJECTS)
  set(SHADER_SOURCES)
  foreach(SHADER_PATH IN LISTS ARGN)
    get_filename_component(ABSOLUTE_SHADER_PATH "${SHADER_PATH}" ABSOLUTE)
    get_filename_component(SHADER_NAME "${SHADER_PATH}" NAME)

    add_custom_command(
      OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${SHADER_NAME}.o
      DEPENDS ${ABSOLUTE_SHADER_PATH}
      DEPFILE ${CMAKE_CURRENT_BINARY_DIR}/${SHADER_NAME}.d
      COMMENT "Compiling Metal Shader: ${SHADER_NAME}"
      COMMAND xcrun metal
              -o ${CMAKE_CURRENT_BINARY_DIR}/${SHADER_NAME}.o
              -Oz
              -MMD
              -MF ${CMAKE_CURRENT_BINARY_DIR}/${SHADER_NAME}.d
              ${ABSOLUTE_SHADER_PATH}
    )

    list(APPEND SHADER_OBJECTS "${CMAKE_CURRENT_BINARY_DIR}/${SHADER_NAME}.o")
    list(APPEND SHADER_SOURCES ${ABSOLUTE_SHADER_PATH})
  endforeach()

  add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${LIBRARY_NAME}.metallib
    DEPENDS ${SHADER_OBJECTS}
    COMMENT "Linking Metal Library: ${LIBRARY_NAME}.metallib"
    COMMAND xcrun metal
            -o ${CMAKE_CURRENT_BINARY_DIR}/${LIBRARY_NAME}.metallib
            -Oz
            ${SHADER_OBJECTS}
  )

  xxd(${TARGET_NAME}
      ${CMAKE_CURRENT_BINARY_DIR}/${LIBRARY_NAME}.metallib
      )

endfunction()
