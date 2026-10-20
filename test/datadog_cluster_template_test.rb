require 'erb'
require 'minitest/autorun'
require 'yaml'

class DatadogClusterTemplateTest < Minitest::Test
  SPEC_PROPERTIES = YAML.safe_load(File.read(File.expand_path('../jobs/datadog-cluster-agent/spec', __dir__))).fetch('properties')
  TEMPLATE = File.read(File.expand_path('../jobs/datadog-cluster-agent/templates/datadog-cluster.yaml.erb', __dir__))

  class TemplateProperties
    def initialize(properties, overrides)
      @properties = properties
      @overrides = overrides
    end

    def p(name, fallback = nil)
      @overrides.fetch(name) { @properties.fetch(name).fetch('default', fallback) }
    end

    def render(template)
      ERB.new(template).result(binding)
    end
  end

  def render(overrides = {})
    properties = { 'cluster_agent.api_key' => '' }.merge(overrides)
    YAML.safe_load(TemplateProperties.new(SPEC_PROPERTIES, properties).render(TEMPLATE))
  end

  def test_site_and_fqdn_conversion
    [
      [{}, 'datadoghq.com', true],
      [{ 'cluster_agent.site' => 'datadoghq.eu', 'cluster_agent.convert_dd_site_fqdn.enabled' => false }, 'datadoghq.eu', false]
    ].each do |properties, site, convert_fqdn|
      config = render(properties)
      assert_equal site, config.fetch('site')
      assert_equal convert_fqdn, config.fetch('convert_dd_site_fqdn').fetch('enabled')
    end
  end
end
