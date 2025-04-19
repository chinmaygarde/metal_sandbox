
if(__metal_library)
  return()
endif()
set(__metal_library INCLUDED)

set(TOOLBOX_DIR "${CMAKE_CURRENT_LIST_DIR}")

function(metal_library LIBRARY_NAME)
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
            ${SHADER_OBJECTS}
  )

  add_custom_target(
    ${LIBRARY_NAME}
    ALL
    DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/${LIBRARY_NAME}.metallib
  )

  # For IDEs. Otherwise does nothing.
  target_sources(
    ${LIBRARY_NAME}
      PRIVATE
        ${SHADER_SOURCES}
  )

endfunction()
