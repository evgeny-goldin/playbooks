# -----------------------------------------------------------------------------------------
# https://github.com/ansible/ansible/blob/devel/lib/ansible/runner/filter_plugins/core.py
# -----------------------------------------------------------------------------------------

import time
import subprocess
import re
import sys
import os
import os.path
from   ansible import errors
from   timeit  import default_timer as timer


def index( array, elements ):
  '''Retrieves an array index of one of the elements specified'''
  for e in elements:
    if e in array:
      return array.index(e)
  raise Exception( "Unable to find any of {} elements in {}".format( elements, array ))

def escape_quotes( s ):
  '''Escapes all signle quotes with "'\''" (bash escape)'''
  return s.replace( "'", r"'\''" )

def contains( llist, element, check_regex = True ):
  '''Finds if any llist element contains the element or all elements specified'''
  # print("contains({}, {})".format(repr(llist), repr(element)))
  if type(llist) is not list:
    llist = str(llist).splitlines()

  assert type(llist) is list, \
         "contains(): llist is not a list: {} ({})".format(llist, type(llist))
  assert type(element) in [list, str, unicode, int, float, bool], \
         "contains(): element is not a list, str, unicode, int, or bool: {} ({})".format(element, type(element))

  # Empty llist and no elements to check
  if ( len(llist) == 0 ) and (( element == '' ) or ( element == [] )):
    return True

  if type( element ) is list:
    # element is a list = checking (recursively) if all its elements appear in llist
    return all( contains( llist, e ) for e in element )
  else:
    # element is not a list = checking if it appears (as substring or regex search) in any l, element of llist
    return any(( str(element) in str(l) or (check_regex and re.search(str(element), str(l)))) for l in llist )

def re_escape( pattern ):
  '''Returns \Qpattern\E, regex-escaped'''
  return re.escape( pattern )

def ext( url ):
  '''Returns URL extension'''
  if url.endswith( '.tar.gz' ):
     return 'tar.gz'
  if url.endswith( '.tar.bz2' ):
     return 'tar.bz2'
  return url.split('.')[-1]

def expand_path( env_dict, ansible_env ):
  '''Returns env variables dictionary where $PATH is replaced with ansible_env['PATH']'''
  if 'PATH' in env_dict:
    env_dict[ 'PATH' ] = env_dict[ 'PATH' ].replace( '$PATH', ansible_env['PATH'] )
  return env_dict;

def absolute_path( path ):
  '''Returns absolute path of the path provided'''
  return os.path.abspath( path );

def tokens( s, vars_tree ):
  '''Replaces all <token> sections in a string with corresponding Ansible variables'''
  new_str = re.sub( '<([^>]+)>', lambda m: str( vars_tree[ m.group(1) ]), s )
  # print( "[{}] => [{}]".format( s, new_str ))
  return new_str

def bare( hostname ):
  '''Leaves out the dot and everything that follows from a domain name: "helios-master.vm" => "helios-master"'''
  return re.sub( '\..*', '', hostname )

def merge( hash_a, hash_b ):
  '''Merges two hashes'''
  return dict( hash_a.items() + hash_b.items());

def strftime( epoch_time ):
  '''time.strftime wrapper'''
  return time.strftime( '%b %d, %Y at %H:%M:%S (GMT)', time.gmtime( epoch_time ))

def transform( values, mapper_string ):
    '''Transforms array of values using mapper function specified as a string'''
    # http://stackoverflow.com/a/26599198/472153
    # print( "eval({})".format( repr( mapper_string )))
    return [ eval( mapper_string )( v ) for v in values ]

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
    if sys.platform == "darwin": # OS X 'sed' uses '-E' where Linux one uses '-r'
      command = command.replace( 'sed -r', 'sed -E' )
    start   = timer()
    version = subprocess.check_output( command, shell=True ).strip()
    print( "[{}] => [{}] ({} sec)".format( command, version, int( timer() - start )))

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
      'index'         : index,
      'escape_quotes' : escape_quotes,
      'contains'      : contains,
      're_escape'     : re_escape,
      'ext'           : ext,
      'expand_path'   : expand_path,
      'absolute_path' : absolute_path,
      'tokens'        : tokens,
      'bare'          : bare,
      'merge'         : merge,
      'strftime'      : strftime,
      'transform'     : transform,
      'explain'       : explain,
      'calculate'     : calculate,
    }
