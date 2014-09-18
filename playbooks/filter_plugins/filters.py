import time;
import subprocess;

def strftime( epoch_time ):
  '''time.strftime wrapper'''
  return time.strftime( '%b %d, %Y at %H:%M:%S (GMT)', time.gmtime( epoch_time ))


def explain( seconds ):
  '''Converts seconds to hh:mm:ss format'''
  seconds = int( seconds )
  hours   = seconds / 3600
  minutes = ( seconds - ( hours * 3600 )) / 60
  seconds = ( seconds - ( hours * 3600 ) - ( minutes * 60 ))
  return "{0:02d}:{1:02d}:{2:02d}".format( hours, minutes, seconds )

def calculate( version, latest_version_command ):
  '''Retrieves latest version if needed by running the command specified'''
  if version == 'latest':
    return subprocess.check_output( latest_version_command, shell=True ).strip()
  else:
    return version


class FilterModule( object ):
  ''' Custom Ansible filters '''

  def filters( self ):
    return {
      'strftime'  : strftime,
      'explain'   : explain,
      'calculate' : calculate,
    }
