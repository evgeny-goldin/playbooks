import io.gatling.core.Predef._
import io.gatling.core.structure.ChainBuilder
import io.gatling.core.structure.ScenarioBuilder
import scala.io.Source
import io.gatling.http.Predef._

class {{ repo_name }}{{ item.name }} extends Simulation {

  // Artifacts read from the file, each one as Array[String], split by "/"
  // Lines having less than 4 elements (groupId, artifactId, version, artifact) are ignored
  val artifacts:Iterator[Array[String]] = Source.fromFile( "{{ test_repo.files_dir }}/{{ item.artifacts }}" ).
                                          getLines().map( _.split( "/" )).filter( _.size > 3 )
  // Coordinates extractors
  def groupId   ( artifact: Array[String] ) = artifact.take( artifact.size - 3 ).mkString( "." )
  def artifactId( artifact: Array[String] ) = artifact.takeRight( 3 )( 0 )
  def version   ( artifact: Array[String] ) = artifact.takeRight( 2 )( 0 )

  /**
   * Builds a chain of calls based on query path,
   * token to replace in path and extractor returning the value to replace the token with given the artifact
   */
  def buildChain( path: String, token: String, extractor: Array[String] => String ):ChainBuilder =
    buildChain( path, List(( token, extractor )))

  /**
   * Builds a chain of calls based on query path and
   * pairs of (token to replace in path, extractor returning the value to replace the token with given the artifact)
   */
  def buildChain( path: String, tokens: Iterable[( String, Array[String] => String )] ):ChainBuilder =
    // artifacts => queries => sorted and unique queries => execs
    artifacts.map {
      artifact: Array[String] => tokens.foldLeft( path ) {
        ( query, tokenAndExtractor ) => query.replace( s"<${tokenAndExtractor._1}>", tokenAndExtractor._2( artifact ))
      }
    }.
    toList.distinct.sorted.
    foldLeft( exec()){
      ( e, query ) => e.exec( http( query ).get( query ))
    }


  {% if   ( item.search | default('')) == 'quick' %}
  val chain = buildChain( "{{ quick_search }}", "name", artifactId( _ ).split( '-' )( 0 ))
  {% elif ( item.search | default('')) == 'groupId' %}
  val chain = buildChain( "{{ groupId_search }}", "g", groupId )
  {% elif ( item.search | default('')) == 'artifactId' %}
  val chain = buildChain( "{{ artifactId_search }}", "a", artifactId )
  {% elif ( item.search | default('')) == 'version' %}
  val chain = buildChain( "{{ version_search }}", "v", version )
  {% elif ( item.search | default('')) == 'gav' %}
  val chain = buildChain( "{{ gav_search }}", List(( "g", groupId ), ( "a", artifactId ), ( "v", version )))
  {% else %}
  val chain = buildChain( "{{ repo }}", List(( "repo",     artifact => "{{ import_repo }}" ),
                                             ( "artifact", artifact => artifact.mkString( "/" ))))
  {% endif %}

  // http://gatling.io/docs/2.1.4/general/scenario.html#scenario-loops

  val scn = scenario( "{{ repo_name }}{{ item.name }}" ).
            exec(
              {% if ( item.duration | default(0)) > 0 %}
                during( {{ item.duration }} ){ chain }
              {% elif ( item.repeat | default(0)) > 0 %}
                repeat( {{ item.repeat }} ){ chain }
              {% else %}
                chain
              {% endif %}
            )

  val httpConf = http.baseURL( "http://{{ host }}:{{ port }}" ).
                      acceptHeader( "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" ).
                      doNotTrackHeader( "1" ).
                      acceptLanguageHeader( "en-US,en;q=0.5" ).
                      acceptEncodingHeader( "gzip, deflate" ).
                      userAgentHeader( "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:35.0) Gecko/20100101 Firefox/35.0" )

  setUp( scn.inject( atOnceUsers( {{ item.users }} ))).protocols( httpConf )
}
