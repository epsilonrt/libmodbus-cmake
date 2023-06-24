# Copyright © 2023 Pascal JEAN, epsilonrt <epsilonrt@gmail.com>
#
# SPDX-License-Identifier: BSD-1-Clause
#
# @file LibModbusAutoconfVersion.cmake
# output variables:
# ${_prefix}_FOUND
# Si ${_prefix}_FOUND = TRUE:
#   ${_prefix}_VERSION
#   ${_prefix}_MAJOR
#   ${_prefix}_MINOR
#   ${_prefix}_MICRO

function(FindVersionPart _var _part _configure)
  string(REGEX MATCH "m4_define\\(\\[libmodbus_version_${_part}\\]\\,\\ \\[([0-9]*)\\]" _ ${_configure})
  if (NOT CMAKE_MATCH_1)
    message(FATAL_ERROR "Unable to find current project version !")
  endif()
  set(${_var} ${CMAKE_MATCH_1} PARENT_SCOPE)
  # message(STATUS "FindVersionPart: ${_var}: ${CMAKE_MATCH_1}")
endfunction(FindVersionPart)

function(GetAutoconfVersion _prefix _src_dir)
  set (${_prefix}_FOUND FALSE PARENT_SCOPE)

  file(STRINGS "${_src_dir}/configure.ac" configure_ac REGEX "^m4_define")
  # message(STATUS "GetAutoconfVersion: ${_src_dir}/configure.ac= ${configure_ac}")

  FindVersionPart(major "major" "${configure_ac}")
  FindVersionPart(minor "minor" "${configure_ac}")
  FindVersionPart(micro "micro" "${configure_ac}")
  set(version ${major}.${minor}.${micro})

  # message(STATUS "GetAutoconfVersion: version = ${version}")

  set (${_prefix}_FOUND TRUE PARENT_SCOPE)
  set (${_prefix}_VERSION_MAJOR ${major} PARENT_SCOPE)
  set (${_prefix}_VERSION_MINOR ${minor} PARENT_SCOPE)
  set (${_prefix}_VERSION_MICRO ${minor} PARENT_SCOPE)
  set (${_prefix}_VERSION ${version} PARENT_SCOPE)

  unset(configure_ac)
  unset(major)
  unset(minor)
  unset(minor)
  unset(version)
endfunction(GetAutoconfVersion)
