# -----------------------------------------------------------------------------------------
# https://github.com/ansible/ansible/blob/devel/lib/ansible/runner/filter_plugins/core.py
# -----------------------------------------------------------------------------------------

import time
import subprocess
import re
from ansible import errors


def strftime( epoch_time ):
  '''time.strftime wrapper'''
  return time.strftime( '%b %d, %Y at %H:%M:%S (GMT)', time.gmtime( epoch_time ))

def transform( values, format ):
    '''Transforms array of values using format specified'''
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
    version = subprocess.check_output( command, shell=True ).strip()
    print "[{0}] => [{1}]".format( command, version )

  if not re.match( pattern, version ):
    raise errors.AnsibleFilterError( "Version '{0}' doesn't match pattern '{1}'".format( version, pattern ))

  return version


def read_latest( vars_tree ):
  if not vars_tree.has_key( 'latest' ):
    raise errors.AnsibleFilterError( "{0} variables - 'latest' is missing".format( vars_tree ))

  if not vars_tree['latest'].has_key( 'command' ):
    raise errors.AnsibleFilterError( "{0} variables - 'latest/command' is missing".format( vars_tree ))

  if not vars_tree['latest'].has_key( 'pattern' ):
    raise errors.AnsibleFilterError( "{0} variables - 'latest/pattern' is missing".format( vars_tree ))

  command = vars_tree['latest']['command']
  pattern = vars_tree['latest']['pattern']

  if not command.strip():
    raise errors.AnsibleFilterError( "{0} variables - 'latest/command' '{1}' is empty".format( vars_tree, command ))

  if not pattern.strip():
    raise errors.AnsibleFilterError( "{0} variables - 'latest/pattern' '{1}' is empty".format( vars_tree, pattern ))

  return ( command, pattern )


class FilterModule( object ):
  ''' Custom Ansible filters '''

  def filters( self ):
    return {
      'strftime'  : strftime,
      'transform' : transform,
      'explain'   : explain,
      'calculate' : calculate,
    }
