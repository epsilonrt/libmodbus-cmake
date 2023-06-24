# Copyright © 2023 Pascal JEAN, epsilonrt <epsilonrt@gmail.com>
#
# SPDX-License-Identifier: BSD-1-Clause
#
# @file GitUtils.cmake
cmake_minimum_required(VERSION 3.0.0)

include(CMakeParseArguments)

find_package(Git REQUIRED)

#
# This function applies patch to git repository if patch is applicable
# Arguments are path to git repository and path to the git patch
#
function(git_apply_patch)
  cmake_parse_arguments(
    PARGS
    "QUIET"
    "PATCH_FILE;REPO_PATH"
    ""
    ${ARGN}
  )

  if(NOT PARGS_PATCH_FILE)
    message(FATAL_ERROR "You must provide a patch file")
  endif()

  if(NOT PARGS_REPO_PATH)
    message(FATAL_ERROR "You must provide a repository path")
  endif()

  get_filename_component(patchname ${PARGS_PATCH_FILE} NAME)
  get_filename_component(repo ${PARGS_REPO_PATH} NAME)

  # check if patch already applied
  execute_process(COMMAND git apply --reverse --check ${PARGS_PATCH_FILE}
    WORKING_DIRECTORY ${PARGS_REPO_PATH}
    RESULT_VARIABLE SUCCESS
    ERROR_QUIET)

  if(NOT ${SUCCESS} EQUAL 0)
    # path not applied, check if it can be applied
    execute_process(COMMAND ${GIT_EXECUTABLE} apply --check ${PARGS_PATCH_FILE}
    WORKING_DIRECTORY ${PARGS_REPO_PATH}
    RESULT_VARIABLE SUCCESS
    ERROR_QUIET)

    if(${SUCCESS} EQUAL 0)
      message(STATUS "Applying git patch ${patchname} in ${repo} repository")
      execute_process(COMMAND ${GIT_EXECUTABLE} apply --whitespace=nowarn ${PARGS_PATCH_FILE}
          WORKING_DIRECTORY ${PARGS_REPO_PATH}
          RESULT_VARIABLE SUCCESS)

      if(${SUCCESS} EQUAL 1)
          # We don't stop here because it can happen in case of parallel builds
          message(WARNING "\nError: failed to apply the patch patch: ${PARGS_PATCH_FILE}\n")
      endif()
    endif()
  else()
      message(STATUS "Patch ${patchname} already applied in ${repo} repository")
  endif()
endfunction()

# This function updates git submodules
function(git_update_submodules)
  cmake_parse_arguments(
    PARGS
    "QUIET"
    "REPO_PATH"
    ""
    ${ARGN}
  )

  if(NOT PARGS_REPO_PATH)
    message(FATAL_ERROR "You must provide a repository path")
  endif()

  get_filename_component(repo ${PARGS_REPO_PATH} NAME)

  if(GIT_FOUND AND EXISTS "${PARGS_REPO_PATH}/.git")
  # Update submodules as needed
      option(GIT_SUBMODULE "Check submodules during build" ON)
      if(GIT_SUBMODULE)
          message(STATUS "Submodule update")
          execute_process(COMMAND ${GIT_EXECUTABLE} submodule update --init --recursive
                          WORKING_DIRECTORY ${PARGS_REPO_PATH}
                          RESULT_VARIABLE GIT_SUBMOD_RESULT)
          if(NOT GIT_SUBMOD_RESULT EQUAL "0")
              message(FATAL_ERROR "git submodule update --init --recursive failed with ${GIT_SUBMOD_RESULT}, please checkout submodules")
          endif()
      endif()
  endif()
endfunction()

