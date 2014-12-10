# -----------------------------------------------------------------------------------------
# https://github.com/ansible/ansible/blob/devel/lib/ansible/runner/filter_plugins/core.py
# -----------------------------------------------------------------------------------------

import time
import subprocess
import re
import sys
from ansible import errors


def merge( hash_a, hash_b ):
  '''Merges two hashes'''
  return dict( hash_a.items() + hash_b.items());

def strftime( epoch_time ):
  '''time.strftime wrapper'''
  return time.strftime( '%b %d, %Y at %H:%M:%S (GMT)', time.gmtime( epoch_time ))

def transform( values, format ):
    '''Transforms array of values using format specified (map-like)'''
    return [ format.format( v ) for v in values ]

def explain( seconds ):
  '''Converts seconds to hh:mm:ss format'''
  seconds = int( seconds )
  hours   = seconds / 3600
  minutes = ( seconds - ( hours * 3600 )) / 60
  seconds = ( seconds - ( hours * 3600 ) - ( minutes * 60 ))
  return "{0:02d}:{1:02d}:{2:02d}".format( hours, minutes, seconds )

def calculate( version, vars_tree ):
  '''Retrieves latest version if needed by running the command specified'''
  version = str( version )
  ( command, pattern ) = read_latest( vars_tree )

  if version == 'latest':
    if sys.platform == "darwin":
      command = command.replace( 'sed -r', 'sed -E' )
    version = subprocess.check_output( command, shell=True ).strip()
    print "[{0}] => [{1}]".format( command, version )

  if not re.match( pattern, version ):
    raise errors.AnsibleFilterError( "Version '{0}' doesn't match pattern '{1}'".format( version, pattern ))

  return version


def read_latest( vars_tree ):
  if not vars_tree.has_key( 'command' ):
    raise errors.AnsibleFilterError( "{0} - 'command' is missing".format( vars_tree ))

  if not vars_tree.has_key( 'pattern' ):
    raise errors.AnsibleFilterError( "{0} - 'pattern' is missing".format( vars_tree ))

  command = vars_tree['command']
  pattern = vars_tree['pattern']

  if not command.strip():
    raise errors.AnsibleFilterError( "{0} - 'command' '{1}' is empty".format( vars_tree, command ))

  if not pattern.strip():
    raise errors.AnsibleFilterError( "{0} - 'pattern' '{1}' is empty".format( vars_tree, pattern ))

  return ( command, pattern )


class FilterModule( object ):
  ''' Custom Ansible filters '''

  def filters( self ):
    return {
      'merge'     : merge,
      'strftime'  : strftime,
      'transform' : transform,
      'explain'   : explain,
      'calculate' : calculate,
    }
