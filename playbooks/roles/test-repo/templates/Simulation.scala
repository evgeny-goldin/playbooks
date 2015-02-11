import io.gatling.core.Predef._
import io.gatling.core.structure.ScenarioBuilder
import scala.io.Source
import io.gatling.http.Predef._

class {{ repo_name }}{{ item.name }} extends Simulation {

  val artifacts = Source.fromFile( "{{ test_repo.files_dir }}/{{ item.artifacts }}" ).getLines()

  {% if ( item.search | default('')) == 'quick' %}
  // "activemq/activemq/3.2-M1/activemq-3.2-M1.pom" => "activemq"
  val chain = artifacts.map( a => a.split( '/' ).last.split( '-' )( 0 )).
              toSet.toList.sorted.
              foldLeft( exec()){
    ( e, name ) =>
    e.exec( http( name ).get( "{{ quick_search }}".replace( "<name>", name )))
  }
  {% elif ( item.search | default('')) == 'class' %}

  // Do Nothing

  {% elif ( item.search | default('')) == 'gavc' %}

  // Do Nothing

  {% else %}
  val chain = artifacts.
              foldLeft( exec()){
    ( e, artifact ) =>
    e.exec( http( artifact.split( '/' ).last ).get( "{{ repo }}".replace( "<repo>", "{{ import_repo }}" ).replace( "<artifact>", artifact )))
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
