import io.gatling.core.Predef._
import io.gatling.core.structure.ScenarioBuilder
import scala.io.Source
import io.gatling.http.Predef._

class {{ repo_name }}{{ item.name }} extends Simulation {

  val artifacts = Source.fromFile( "{{ test_repo.files_dir }}/{{ item.artifacts }}" ).getLines()

  def buildChain( coordinateName: String, path: String, extractor: String => String ) =
    artifacts.map( extractor ).toList.distinct.sorted.foldLeft( exec()){
    ( e, coordinate ) =>
    val query = path.replace( s"<${coordinateName}>", coordinate )
    e.exec( http( query ).get( query ))
  }

  def groupId   ( artifact:String ) = { val array = artifact.split( "/" )
                                        array.take( array.size - 3 ).mkString( "." )}
  def artifactId( artifact:String ) = artifact.split( "/" ).takeRight( 3 )( 0 )
  def version   ( artifact:String ) = artifact.split( "/" ).takeRight( 2 )( 0 )

  {% if   ( item.search | default('')) == 'quick' %}
  val chain = buildChain( "name", "{{ quick_search }}", artifactId( _ ).split( '-' )( 0 ))
  {% elif ( item.search | default('')) == 'groupId' %}
  val chain = buildChain( "g", "{{ groupId_search }}", groupId )
  {% elif ( item.search | default('')) == 'artifactId' %}
  val chain = buildChain( "a", "{{ artifactId_search }}", artifactId )
  {% elif ( item.search | default('')) == 'version' %}
  val chain = buildChain( "v", "{{ version_search }}", version )
  {% elif ( item.search | default('')) == 'gav' %}
  val chain = artifacts.foldLeft( exec()){
    ( e, artifact ) =>
    val g     = groupId( artifact )
    val a     = artifactId( artifact )
    val v     = version( artifact )
    val query = "{{ gav_search }}".replace( "<g>", g ).
                                   replace( "<a>", a ).
                                   replace( "<v>", v )
    e.exec( http( query ).get( query ))
  }
  {% else %}
  val chain = artifacts.foldLeft( exec()){
    ( e, artifact ) =>
    val query = "{{ repo }}".replace( "<repo>",     "{{ import_repo }}" ).
                             replace( "<artifact>", artifact )
    e.exec( http( query ).get( query ))
  }
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
