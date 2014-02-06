#
# denyhosts module
#
# Copyright 2008, Puzzle ITC GmbH
# Marcel Härry haerry+puppet(at)puzzle.ch
# Simon Josi josi+puppet(at)puzzle.ch
#
# This program is free software; you can redistribute
# it and/or modify it under the terms of the GNU
# General Public License version 3 as published by
# the Free Software Foundation.
#
# This module is used to configure the
# denyhosts script.
#

# configure the denyhosts service
#
# Parameters:
#
#  * allowed_hosts:
#     - autodiscover: collect exported denyhosts::allowed_hosts
#                     resources.
#     - unmanaged: do not manage the content of the file
#     - an array of ips: ensure that the array of ips is in the
#                        allowed hosts file
#     - any other string: use this string as content for the file
class denyhosts(
  $allowed_hosts = 'autodiscover',
) {
  case $::operatingsystem {
    gentoo: { include denyhosts::gentoo }
    debian: { include denyhosts::debian }
    default: { include denyhosts::base }
  }
}
