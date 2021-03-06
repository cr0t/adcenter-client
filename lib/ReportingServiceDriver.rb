require 'ReportingService.rb'
require 'ReportingServiceMappingRegistry.rb'
require 'soap/rpc/driver'

module AdCenterWrapper

class IReportingService < ::SOAP::RPC::Driver
  DefaultEndpointUrl = "https://adcenterapi.microsoft.com/Api/Advertiser/V8/Reporting/ReportingService.svc"

  Methods = [
    [ "SubmitGenerateReport",
      "submitGenerateReport",
      [ ["in", "parameters", ["::SOAP::SOAPElement", "https://adcenter.microsoft.com/v8", "SubmitGenerateReportRequest"]],
        ["out", "parameters", ["::SOAP::SOAPElement", "https://adcenter.microsoft.com/v8", "SubmitGenerateReportResponse"]] ],
      { :request_style =>  :document, :request_use =>  :literal,
        :response_style => :document, :response_use => :literal,
        :faults => {"AdCenterWrapper::AdApiFaultDetailFault"=>{:encodingstyle=>"document", :use=>"literal", :ns=>"https://adcenter.microsoft.com/v8", :namespace=>nil, :name=>"AdApiFaultDetailFault"}, "AdCenterWrapper::ApiFaultDetailFault"=>{:encodingstyle=>"document", :use=>"literal", :ns=>"https://adcenter.microsoft.com/v8", :namespace=>nil, :name=>"ApiFaultDetailFault"}} }
    ],
    [ "PollGenerateReport",
      "pollGenerateReport",
      [ ["in", "parameters", ["::SOAP::SOAPElement", "https://adcenter.microsoft.com/v8", "PollGenerateReportRequest"]],
        ["out", "parameters", ["::SOAP::SOAPElement", "https://adcenter.microsoft.com/v8", "PollGenerateReportResponse"]] ],
      { :request_style =>  :document, :request_use =>  :literal,
        :response_style => :document, :response_use => :literal,
        :faults => {"AdCenterWrapper::AdApiFaultDetailFault"=>{:encodingstyle=>"document", :use=>"literal", :ns=>"https://adcenter.microsoft.com/v8", :namespace=>nil, :name=>"AdApiFaultDetailFault"}, "AdCenterWrapper::ApiFaultDetailFault"=>{:encodingstyle=>"document", :use=>"literal", :ns=>"https://adcenter.microsoft.com/v8", :namespace=>nil, :name=>"ApiFaultDetailFault"}} }
    ]
  ]

  def initialize(endpoint_url = nil)
    endpoint_url ||= DefaultEndpointUrl
    super(endpoint_url, nil)
    self.mapping_registry = ReportingServiceMappingRegistry::EncodedRegistry
    self.literal_mapping_registry = ReportingServiceMappingRegistry::LiteralRegistry
    init_methods
  end

private

  def init_methods
    Methods.each do |definitions|
      opt = definitions.last
      if opt[:request_style] == :document
        add_document_operation(*definitions)
      else
        add_rpc_operation(*definitions)
        qname = definitions[0]
        name = definitions[2]
        if qname.name != name and qname.name.capitalize == name.capitalize
          ::SOAP::Mapping.define_singleton_method(self, qname.name) do |*arg|
            __send__(name, *arg)
          end
        end
      end
    end
  end
end


end
