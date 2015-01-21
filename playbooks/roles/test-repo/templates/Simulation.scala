import io.gatling.core.Predef._
import io.gatling.core.structure.ScenarioBuilder
import scala.io.Source
import io.gatling.http.Predef._

class {{ name }} extends Simulation {

  val scn = Source.fromFile( "{{ artifacts }}" ).getLines().foldLeft( scenario( "{{ repo_name }}{{ name }}" )) {
    ( scn, artifact ) => scn.exec( http( artifact.split( '/' ).last ).get( artifact ))
  }

  val httpConf = http.baseURL( "{{ repo }}" ).
                      acceptHeader( "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" ).
                      doNotTrackHeader( "1" ).
                      acceptLanguageHeader( "en-US,en;q=0.5" ).
                      acceptEncodingHeader( "gzip, deflate" ).
                      userAgentHeader( "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:35.0) Gecko/20100101 Firefox/35.0" )

  setUp( scn.inject( atOnceUsers( {{ users }} ))).protocols( httpConf )
}
