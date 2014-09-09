import time;

def strftime( epoch_time ):
  '''time.strftime wrapper'''
  return time.strftime( '%b %d, %Y at %H:%M:%S', time.gmtime( epoch_time ))


def explain( seconds ):
  '''Converts seconds to hh:mm:ss format'''
  seconds = int( seconds )
  hours   = seconds / 3600
  minutes = ( seconds - ( hours * 3600 )) / 60
  seconds = ( seconds - ( hours * 3600 ) - ( minutes * 60 ))
  return "{0:02d}:{1:02d}:{2:02d}".format( hours, minutes, seconds )


class FilterModule( object ):
  ''' Custom Ansible filters '''

  def filters( self ):
    return {
      'strftime': strftime,
      'explain' : explain,
    }
