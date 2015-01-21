import io.gatling.core.Predef._
import io.gatling.core.structure.ScenarioBuilder
import scala.io.Source
import io.gatling.http.Predef._

class LoadArtifacts extends Simulation {

  val baseURL   = "{{ repo }}"
  val artifacts = "{{ test_repo.load.artifacts }}"
  val scn       = Source.fromFile( artifacts ).getLines().foldLeft( scenario( "LoadArtifacts" )) {
    ( scn, artifact ) => scn.exec( http( artifact.split( '/' ).last ).get( artifact ))
  }

  val httpConf = http.baseURL( baseURL ).
                      acceptHeader( "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" ).
                      doNotTrackHeader( "1" ).
                      acceptLanguageHeader( "en-US,en;q=0.5" ).
                      acceptEncodingHeader( "gzip, deflate" ).
                      userAgentHeader( "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:35.0) Gecko/20100101 Firefox/35.0" )

  setUp( scn.inject( atOnceUsers( {{ test_repo.load.users }} ))).protocols( httpConf )
}
